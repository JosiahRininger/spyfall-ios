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

final class WaitingScreenController: UIViewController {
    
    var scrollView = UIScrollView()
    var waitingScreenView = WaitingScreenView()
    var customPopUp = ChangeNamePopUpView()
    let spinner = Spinner(frame: .zero)
    
    var playerObjectList = [Player]()
    var playerList = [String]()
    var currentUsername = String()
    var accessCode = String()
    var chosenPacks = [String]()
    var chosenLocation = String()
    var isStarted = false
    var segued = false
    var oldUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingScreenView.tableView.delegate = self
        waitingScreenView.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(pencilTapped), name: .editUsername, object: nil)
        
        setupView()
        addUsernameToPlayerList()
        updatePlayerList()
        setUpKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetViews()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//    }
    
    private func setupView() {
        setupButtons()
        
        scrollView.backgroundColor = .primaryWhite
        scrollView.addSubview(waitingScreenView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.codeLabel.text = accessCode
        
        view.backgroundColor = .primaryWhite
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
        //        scrollView.contentSize = waitingScreenView.bounds.size
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
    func startGameWasTapped() {
        if isStarted == true { return }
        
        // Set isStarted to true
        isStarted = true
        FirestoreManager.updateGameData(accessCode: self.accessCode, data: ["started": true])
        
        FirestoreManager.retrieveRoles(chosenPack: chosenPacks[0], chosenLocation: chosenLocation) { result in
            // Assigns each player a role
            var roles = result
            self.playerList.shuffle()
            roles.shuffle()
            for i in 0..<(self.playerList.count - 1) {
                self.playerObjectList.append(Player(role: roles[i], username: self.playerList[i], votes: 0))
            }
            self.playerObjectList.append(Player(role: "The Spy!", username: self.playerList.last!, votes: 0))
            
            for playerObject in self.playerObjectList {
                // Add playerObjectList field to document
                FirestoreManager.updateGameData(accessCode: self.accessCode, data: ["playerObjectList": FieldValue.arrayUnion([[
                    "role": playerObject.role,
                    "username": playerObject.username,
                    "votes": playerObject.votes]])
                    ])
            }
        }
    }
    
    //     deletes player from game and deletes game if playerList is empty
    func leaveGameWasTapped() {
        if isStarted == true { return }
        playerList = playerList.filter { $0 != currentUsername }
        FirestoreManager.updateGameData(accessCode: accessCode, data: ["playerList": playerList])
        if playerList.isEmpty { FirestoreManager.deleteGame(accessCode: accessCode) }
        navigationController?.popToRootViewController(animated: true)
    }
        
    @objc func pencilTapped() {
        customPopUp.textField.text = currentUsername
        customPopUp.isUserInteractionEnabled = true
        customPopUp.changeNamePopUpView.isHidden = false
        waitingScreenView.leaveGame.isUserInteractionEnabled = false
        waitingScreenView.startGame.isUserInteractionEnabled = false
    }
    
    //     adds players username to firestore
    func addUsernameToPlayerList() {
        FirestoreManager.updateGameData(accessCode: accessCode, data: ["playerList": FieldValue.arrayUnion([currentUsername])])
    }
    
    // listener that updates playerList and tableView when firestore playerList is updated
    func updatePlayerList() {
        FirestoreManager.addListener(accessCode: accessCode) { result in
            switch result {
            // Successfully adds listener
            case .success(let document):
                guard let playerListData = document.get("playerList"),
                    let isStartedData = document.get("started"),
                    let chosenPacksData = document.get("chosenPacks"),
                    let chosenLocationData = document.get("chosenLocation") else {
                        print("Document data was empty.")
                        return
                }
                
                // update playerList and tableView
                if let playerList = playerListData as? [String],
                    let isStarted = isStartedData as? Bool,
                    let chosenPacks = chosenPacksData as? [String],
                    let chosenLocation = chosenLocationData as? String {
                    self.playerList = playerList
                    self.isStarted = isStarted
                    self.chosenPacks = chosenPacks
                    self.chosenLocation = chosenLocation
                }
                
                self.waitingScreenView.tableHeight.constant = CGFloat(self.playerList.count) * UIElementSizes.tableViewCellHeight
                self.waitingScreenView.tableView.reloadData()
                self.waitingScreenView.tableView.setNeedsUpdateConstraints()
                self.waitingScreenView.tableView.layoutIfNeeded()
                
                if self.isStarted && self.spinner.alpha != 1.0 { self.spinner.animate(with: self.waitingScreenView.startGame) }
                
                // Check for segue
                if let playerObjects = document.get("playerObjectList") as? [[String: Any]] {
                    if playerObjects.last?["role"] as? String == "The Spy!" && !self.segued {
                        self.segueToGameSessionController()
                    }
                }
            // Failure to add listener
            case .failure(let error):
                print("FirestoreManager.addListener error: ", error)
            }
        }
    }
    
    private func finishChangingUsername() {
        if !textFieldIsValid() { return }
        if let text = customPopUp.textField.text {
            oldUsername = currentUsername
            currentUsername = text
            waitingScreenView.tableView.reloadData()
        }
        resetViews()
    }
    
    func textFieldIsValid() -> Bool {
        HUD.dimsBackground = false
        if customPopUp.textField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a username"), delay: 1.0)
        } else if customPopUp.textField.text == currentUsername {
            HUD.flash(.label("Please enter a new username"), delay: 1.0)
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
    
    private func resetViews() {
        customPopUp.isUserInteractionEnabled = false
        customPopUp.changeNamePopUpView.isHidden = true
        waitingScreenView.leaveGame.isUserInteractionEnabled = true
        waitingScreenView.startGame.isUserInteractionEnabled = true
    }
    
    private func segueToGameSessionController() {
        segued.toggle()
        let nextScreen = GameSessionController()
        nextScreen.currentUsername = self.currentUsername
        nextScreen.accessCode = self.accessCode
        nextScreen.chosenPacks = self.chosenPacks
        navigationController?.pushViewController(nextScreen, animated: true)
    }

    func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        }
}

// MARK: - Table View Delegate & Data Source
extension WaitingScreenController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isUser = Bool()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDs.playerListCellId) as? PlayersWaitingTableViewCell else {
            fatalError()
        }
        
        // updates playerList when player changes name
        if let oldUsername = oldUsername {
            if playerList[indexPath.row] == oldUsername {
                playerList[indexPath.row] = currentUsername
                self.oldUsername = nil
                FirestoreManager.updateGameData(accessCode: accessCode, data: ["playerList": playerList])
            }
        }
        
        // configures the cells
        cell.selectionStyle = .none
        isUser = playerList[indexPath.row] == currentUsername
        cell.configure(username: (playerList[indexPath.row]), index: indexPath.row + 1, isCurrentUsername: isUser)
        
        return cell
    }

}
