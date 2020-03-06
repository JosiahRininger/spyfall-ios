//
//  WaitingScreenViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds
import PKHUD
import os.log

final class WaitingScreenController: UIViewController, GADBannerViewDelegate {
    var scrollView = UIScrollView()
    var waitingScreenView = WaitingScreenView()
    var customPopUp = ChangeNamePopUpView()
    var spinner = Spinner(frame: .zero)
    
#if FREE
    var bannerView = UIElementsManager.createBannerView()
#endif
    
    private var gameData = GameData()
    private var oldUsername: String?
    private var listener: ListenerRegistration?
    
    init(gameData: GameData) {
        self.gameData = gameData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingScreenView.tableView.delegate = self
        waitingScreenView.tableView.dataSource = self
        
        listenToPlayerList()
        
#if FREE
        initializeBanner()
#endif
        
        if gameData.chosenLocation.isEmpty { retrieveChosenPacksAndLocation() }
        setupView()

        NotificationCenter.default.addObserver(self, selector: #selector(pencilTapped), name: .editUsername, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gameData.seguedToGameSession {
            spinner.reset()
            gameData.resetToPlayAgain()
            oldUsername = nil
            retrieveChosenPacksAndLocation()
        }
    }
    
    deinit {
        // Remove any listeners
        guard let listener = listener else { return }
        listener.remove()
        NotificationCenter.default.removeObserver(self, name: .editUsername, object: nil)
        NotificationCenter.default.removeObserver(self, name: .gameInactive, object: nil)
    }
    
    // MARK: - Setup UI & Listeners
    private func setupView() {
        setupButtons()
        setUpKeyboard()
        spinner = Spinner(frame: CGRect(x: 45.0, y: waitingScreenView.startGame.frame.minY + 21.0, width: 20.0, height: 20.0))

        scrollView.backgroundColor = .primaryBackgroundColor
        scrollView.addSubview(waitingScreenView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.codeLabel.text = gameData.accessCode
        
        view.backgroundColor = .primaryBackgroundColor
        view.addSubviews(scrollView, customPopUp)
        
#if FREE
        view.addSubview(bannerView)
#endif
        
        waitingScreenView.startGame.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            waitingScreenView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            waitingScreenView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            waitingScreenView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            waitingScreenView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
        
#if FREE
        bannerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
#endif
        // scrollView.contentSize = waitingScreenView.bounds.size
    }
    
    private func setupButtons() {
        waitingScreenView.startGame.addSubview(spinner)
        
        waitingScreenView.startGame.touchUpInside = { [weak self] in self?.startGameWasTapped() }
        waitingScreenView.leaveGame.touchUpInside = { [weak self] in self?.leaveGameWasTapped() }
        
        // Sets up the actions around the change name pop up
        customPopUp.changeNamePopUpView.cancelButton.touchUpInside = { [weak self] in self?.resetViews() }
        customPopUp.changeNamePopUpView.doneButton.touchUpInside = { [weak self] in
            self?.finishChangingUsername()
        }
    }

#if FREE
    private func initializeBanner() {
        bannerView.delegate = self
        bannerView.adUnitID = Constants.IDs.waitingScreenAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        os_log("Google Mobile Ads SDK version: %@", GADRequest.sdkVersion())
    }
#endif
    
    // listener that updates playerList and tableView when firestore playerList is updated
    private func listenToPlayerList() {
        listener = FirestoreManager.addListener(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            // Successfully adds listener
            case .success(let document):
                self?.listenToPlayerListSuccess(with: document)
            // Failure to add listener
            case .failure(let error):
                os_log("FirestoreManager.addListener error: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            }
        }
    }
    
    private func listenToPlayerListSuccess(with document: DocumentSnapshot) {
        guard let playerList = document.get(Constants.DBStrings.playerList) as? [String],
            let started = document.get("started") as? Bool else {
                os_log("Document data was empty.")
                return
        }
        
        self.gameData.playerList = playerList
        self.gameData.started = started
        self.waitingScreenView.tableHeight.constant = CGFloat(self.gameData.playerList.count) * UIElementsManager.tableViewCellHeight
        self.waitingScreenView.tableView.reloadData()
        self.waitingScreenView.tableView.setNeedsUpdateConstraints()
        self.waitingScreenView.tableView.layoutIfNeeded()
        self.spinner = Spinner(frame: CGRect(x: 45.0, y: self.waitingScreenView.startGame.frame.minY + 21.0, width: 20.0, height: 20.0))
        
        if self.gameData.started {
            self.spinner.animate(with: self.waitingScreenView.startGame)
        }
        
        // Check for segue
        if let playerObjectList = document.get("playerObjectList") as? [[String: Any]] {
            if !playerObjectList.isEmpty
                && !self.gameData.seguedToGameSession {
                self.gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
                self.segueToGameSessionController()
            }
        }
    }
    
    // MARK: - Helper Methods
    // Retrieves the stored chosenPacks and ChosenLocation
    private func retrieveChosenPacksAndLocation() {
        FirestoreManager.retrieveChosenPacksAndLocation(accessCode: gameData.accessCode) { [weak self] result in
            self?.gameData.chosenPacks = result.chosenPacks
            self?.gameData.chosenLocation = result.chosenLocation
        }
    }
    
    // check if Start Game has been clicked
    private func startGameWasTapped() {
        if gameData.started == true { return }
        
        // Set started to true
        gameData.started = true
        FirestoreManager.updateGameData(accessCode: self.gameData.accessCode, data: ["started": true])
        
        FirestoreManager.retrieveRoles(chosenPacks: self.gameData.chosenPacks, chosenLocation: gameData.chosenLocation) { [weak self] result in
            self?.handleRolesFromFirebase(with: result)
        }
        StatsManager.incrementTotalNumberOfGamesPlayed()
    }
    
    // Assigns each player a role
    private func handleRolesFromFirebase(with result: [String]) {
        var roles = result
        self.gameData.playerList.shuffle()
        roles.shuffle()
        for i in 0..<(self.gameData.playerList.count - 1) {
            self.gameData.playerObjectList.append(Player(role: roles[i], username: self.gameData.playerList[i], votes: 0))
        }
        self.gameData.playerObjectList.append(Player(role: "The Spy!", username: self.gameData.playerList.last!, votes: 0))
        
        // Add playerObjectList field to document
        self.gameData.playerObjectList.shuffle()
        let playerObjectListDict = self.gameData.playerObjectList.map { $0.toDictionary() }
        FirestoreManager.updateGameData(accessCode: self.gameData.accessCode,
                                        data: ["playerObjectList": playerObjectListDict])
    }
    
    // deletes player from game and deletes game if playerList is empty
    private func leaveGameWasTapped() {
        if gameData.started { return }
        gameData.playerList.removeAll(where: { $0 == gameData.playerObject.username })
        switch gameData.playerList.isEmpty {
        case true: FirestoreManager.deleteGame(accessCode: gameData.accessCode)
        case false: FirestoreManager.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerList: FieldValue.arrayRemove([gameData.playerObject.username])])
        }
        navigationController?.popToRootViewController(animated: true)
    }
        
    @objc private func pencilTapped() {
        customPopUp.textField.text = gameData.playerObject.username
        customPopUp.isUserInteractionEnabled = true
        customPopUp.changeNamePopUpView.isHidden = false
        customPopUp.textField.becomeFirstResponder()
        waitingScreenView.leaveGame.isUserInteractionEnabled = false
        waitingScreenView.startGame.isUserInteractionEnabled = false
    }
    
    private func segueToGameSessionController() {
        gameData.seguedToGameSession = true
        StatsManager.incrementTotalNumberOfPlayers()
        navigationController?.pushViewController(GameSessionController(gameData: gameData), animated: true)
    }
    
    private func finishChangingUsername() {
        if !textFieldIsValid() { return }
        if let text = customPopUp.textField.text {
            oldUsername = gameData.playerObject.username
            gameData.playerObject.username = text
            waitingScreenView.tableView.reloadData()
        }
        resetViews()
    }
    
    private func resetViews() {
        customPopUp.isUserInteractionEnabled = false
        customPopUp.changeNamePopUpView.isHidden = true
        waitingScreenView.leaveGame.isUserInteractionEnabled = true
        waitingScreenView.startGame.isUserInteractionEnabled = true
    }
    
    // Remove current user from playerList and delete game if playerList is empty
    @objc private func gameInactive() {
        navigationController?.popToRootViewController(animated: true)
        switch gameData.playerList.count {
        case let x where x > 1:
            FirestoreManager.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerList: FieldValue.arrayRemove([gameData.playerObject.username])])
        case 1:
            FirestoreManager.deleteGame(accessCode: gameData.accessCode)
        default: return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 25 characters
        return updatedText.count <= 24
    }
    
    // MARK: - Keyboard Set Up
    private func setUpKeyboard() {
        createToolBar()
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WaitingScreenController.dismissKeyboard))
        doneButton.tintColor = .secondaryColor
        let flexibilitySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibilitySpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        customPopUp.textField.inputAccessoryView = toolBar
    }
    
    private func textFieldIsValid() -> Bool {
        HUD.dimsBackground = false
        if customPopUp.textField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a username"), delay: 1.0)
        } else if customPopUp.textField.text == gameData.playerObject.username {
            HUD.flash(.label("Please enter a new username"), delay: 1.0)
        } else if gameData.playerList.contains(customPopUp.textField.text ?? "") {
            HUD.flash(.label("Username is already taken"), delay: 1.0)
        } else {
            return true
        }
        return false
    }
}

// MARK: - Table View Delegate & Data Source
extension WaitingScreenController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameData.playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isUser = Bool()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDs.playerListCellId) as? PlayersWaitingTableViewCell else {
            fatalError()
        }
        
        // updates playerList when player changes name
        if let oldUsername = oldUsername {
            if gameData.playerList[indexPath.row] == oldUsername {
                gameData.playerList[indexPath.row] = gameData.playerObject.username
                self.oldUsername = nil
                FirestoreManager.updateGameData(accessCode: gameData.accessCode, data: [Constants.DBStrings.playerList: gameData.playerList])
            }
        }
        
        // configures the cells
        cell.selectionStyle = .none
        isUser = gameData.playerList[indexPath.row] == gameData.playerObject.username
        cell.configure(username: (gameData.playerList[indexPath.row]), index: indexPath.row + 1, isCurrentUsername: isUser)
        
        return cell
    }
}
