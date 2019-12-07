//
//  WaitingScreenViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import PKHUD
import os.log

final class WaitingScreenController: UIViewController {
    var scrollView = UIScrollView()
    var waitingScreenView = WaitingScreenView()
    var customPopUp = ChangeNamePopUpView()
    var spinner = Spinner(frame: .zero)
    
    var gameData = GameData()
    var oldUsername: String?
    
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
        
        // adds players username to firestore
        FirestoreManager.updateGameData(accessCode: gameData.accessCode,
                                        data: ["playerList": FieldValue.arrayUnion([gameData.playerObject.username])])
        
        updatePlayerList()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(pencilTapped), name: .editUsername, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gameData.seguedToGameSession {
            gameData.resetToPlayAgain()
            oldUsername = nil
        }
    }
    
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
    
    // check if Start Game has been clicked
    private func startGameWasTapped() {
        if gameData.started == true { return }
        
        // Set started to true
        gameData.started = true
        FirestoreManager.updateGameData(accessCode: self.gameData.accessCode, data: ["started": true])
        
        FirestoreManager.retrieveRoles(chosenPack: gameData.chosenPacks[0], chosenLocation: gameData.chosenLocation) { result in
            // Assigns each player a role
            var roles = result
            self.gameData.playerList.shuffle()
            roles.shuffle()
            for i in 0..<(self.gameData.playerList.count - 1) {
                self.gameData.playerObjectList.append(Player(role: roles[i], username: self.gameData.playerList[i], votes: 0))
            }
            self.gameData.playerObjectList.append(Player(role: "The Spy!", username: self.gameData.playerList.last!, votes: 0))
            
            // Add playerObjectList field to document
            let playerObjectListDict = self.gameData.playerObjectList.map { $0.toDictionary() }
            FirestoreManager.updateGameData(accessCode: self.gameData.accessCode,
                                            data: ["playerObjectList": playerObjectListDict])
        }
        updateStats()
    }
    
    // deletes player from game and deletes game if playerList is empty
    private func leaveGameWasTapped() {
        if gameData.started { return }
        gameData.playerList = gameData.playerList.filter { $0 != gameData.playerObject.username }
        FirestoreManager.updateGameData(accessCode: gameData.accessCode, data: ["playerList": gameData.playerList])
        if gameData.playerList.isEmpty { FirestoreManager.deleteGame(accessCode: gameData.accessCode) }
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
    
    // listener that updates playerList and tableView when firestore playerList is updated
    private func updatePlayerList() {
        FirestoreManager.addListener(accessCode: gameData.accessCode) { result in
            switch result {
            // Successfully adds listener
            case .success(let document):
                guard let playerListData = document.get("playerList"),
                    let startedData = document.get("started"),
                    let chosenPacksData = document.get("chosenPacks"),
                    let chosenLocationData = document.get("chosenLocation") else {
                        os_log("Document data was empty.")
                        return
                }
                
                // update playerList and tableView
                if let playerList = playerListData as? [String],
                    let started = startedData as? Bool,
                    let chosenPacks = chosenPacksData as? [String],
                    let chosenLocation = chosenLocationData as? String {
                    self.gameData.playerList = playerList
                    self.gameData.started = started
                    self.gameData.chosenPacks = chosenPacks
                    self.gameData.chosenLocation = chosenLocation
                }
                
                self.waitingScreenView.tableHeight.constant = CGFloat(self.gameData.playerList.count) * UIElementsManager.tableViewCellHeight
                self.waitingScreenView.tableView.reloadData()
                self.waitingScreenView.tableView.setNeedsUpdateConstraints()
                self.waitingScreenView.tableView.layoutIfNeeded()
                
                if self.gameData.started && self.spinner.alpha != 1.0 {
                    self.spinner.animate(with: self.waitingScreenView.startGame)
                }
                
                // Check for segue
                if let playerObjectList = document.get("playerObjectList") as? [[String: Any]] {
                    if playerObjectList.count == self.gameData.playerList.count
                        && !self.gameData.seguedToGameSession {
                        self.gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
                        self.segueToGameSessionController()
                    }
                }
            // Failure to add listener
            case .failure(let error):
                os_log("FirestoreManager.addListener error: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            }
        }
    }
    
    private func segueToGameSessionController() {
        spinner.reset()
        gameData.seguedToGameSession = true
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
    
    private func updateStats() {
        StatsManager.incrementTotalNumberOfGamesPlayed()
        StatsManager.incrementTotalNumberOfPlayers(by: gameData.playerList.count)
    }
    
    // MARK: - Keyboard Set Up
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

    private func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
                FirestoreManager.updateGameData(accessCode: gameData.accessCode, data: ["playerList": gameData.playerList])
            }
        }
        
        // configures the cells
        cell.selectionStyle = .none
        isUser = gameData.playerList[indexPath.row] == gameData.playerObject.username
        cell.configure(username: (gameData.playerList[indexPath.row]), index: indexPath.row + 1, isCurrentUsername: isUser)
        
        return cell
    }
}
