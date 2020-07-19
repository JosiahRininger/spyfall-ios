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

final class WaitingScreenController: UIViewController, WaitingScreenViewModelDelegate, GADBannerViewDelegate {
    private var scrollView = UIScrollView()
    private var waitingScreenView = WaitingScreenView()
    private var waitingScreenViewModel: WaitingScreenViewModel?
    private var customPopUp = ChangeNamePopUpView()
    private var gameData = GameData()
    private var oldUsername: String?
    
#if FREE
    private var bannerView = UIElementsManager.createBannerView()
#endif
    
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
        waitingScreenViewModel = WaitingScreenViewModel(delegate: self, gameData: gameData)
        
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gameData.seguedToGameSession {
            waitingScreenView.spinner.reset()
            gameData.resetToPlayAgain()
            oldUsername = nil
            waitingScreenViewModel?.retrieveChosenPacksAndLocation(gameData: gameData)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pencilTapped), name: .editUsername, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    deinit {
        // Remove any listeners
        waitingScreenViewModel?.removeListener()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI & Listeners
    private func setupView() {
        setupButtons()
        setUpKeyboard()

        scrollView.backgroundColor = .primaryBackgroundColor
        scrollView.addSubview(waitingScreenView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.codeLabel.text = gameData.accessCode
        
        view.backgroundColor = .primaryBackgroundColor
        view.addSubviews(scrollView, customPopUp)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            waitingScreenView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            waitingScreenView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            waitingScreenView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            waitingScreenView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
#if FREE
        view.addSubview(bannerView)
        bannerView.delegate = self
        bannerView.adUnitID = Constants.IDs.waitingScreenAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
#endif
        // scrollView.contentSize = waitingScreenView.bounds.size
    }
    
    private func setupButtons() {
        waitingScreenView.startGame.touchUpInside = { [weak self] in self?.startGameWasTapped() }
        waitingScreenView.leaveGame.touchUpInside = { [weak self] in self?.leaveGameWasTapped() }
        
        // Sets up the actions around the change name pop up
        customPopUp.changeNamePopUpView.cancelButton.touchUpInside = { [weak self] in self?.resetViews() }
        customPopUp.changeNamePopUpView.doneButton.touchUpInside = { [weak self] in
            self?.finishChangingUsername()
        }
    }
    
    func listenToPlayerListSuccess(with document: DocumentSnapshot) {
        guard let playerList = document.get(Constants.DBStrings.playerList) as? [String],
            let started = document.get("started") as? Bool else {
                os_log("Document data was empty.")
                return
        }
        
        gameData.playerList = playerList
        gameData.started = started
        waitingScreenView.tableHeight.constant = CGFloat(gameData.playerList.count) * UIElementsManager.tableViewCellHeight
        waitingScreenView.tableView.reloadData()
        waitingScreenView.tableView.setNeedsUpdateConstraints()
        waitingScreenView.tableView.layoutIfNeeded()
        
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
    // check if Start Game has been clicked
    private func startGameWasTapped() {
        if gameData.started == true { return }
        waitingScreenView.spinner.animate(with: waitingScreenView.startGame)
        
        // Set started to true
        gameData.started = true
        waitingScreenViewModel?.startGame(gameData: gameData)
    }
    
    private func leaveGameWasTapped() {
        if waitingScreenViewModel?.shouldLeaveGame(gameData: gameData) ?? false {
            navigationController?.popToRootViewController(animated: true)
        }
    }
        
    @objc
    private func pencilTapped() {
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
    @objc
    private func gameInactive() {
        waitingScreenViewModel?.handleInActive(gameData: gameData)
        navigationController?.popToRootViewController(animated: true)
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
        let toolBar = UIElementsManager.createToolBar(with: UIBarButtonItem(title: "Done",
                                                                            style: .plain,
                                                                            target: self,
                                                                            action: #selector(WaitingScreenController.dismissKeyboard)))
        customPopUp.textField.inputAccessoryView = toolBar
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
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
                FirestoreService.updateGameData(accessCode: gameData.accessCode, data: [Constants.DBStrings.playerList: gameData.playerList])
            }
        }
        
        // configures the cells
        cell.selectionStyle = .none
        isUser = gameData.playerList[indexPath.row] == gameData.playerObject.username
        cell.configure(username: (gameData.playerList[indexPath.row]), index: indexPath.row + 1, isCurrentUsername: isUser)
        
        return cell
    }
}
