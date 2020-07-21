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
        waitingScreenViewModel = WaitingScreenViewModel(delegate: self, gameData: gameData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitingScreenView.tableView.delegate = self
        waitingScreenView.tableView.dataSource = self
        
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endGamePopUp(shouldHide: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gameData.seguedToGameSession {
            waitingScreenView.spinner.reset()
            gameData.resetToPlayAgain()
            oldUsername = nil
            waitingScreenViewModel?.retrieveChosenPacksAndLocation()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pencilTapped), name: .editUsername, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI & Listeners
    private func setupView() {
        setupButtons()
        setUpKeyboard()

        scrollView.backgroundColor = .primaryBackgroundColor
        scrollView.addSubview(waitingScreenView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        waitingScreenView.startGame.touchUpInside = { [weak self] in
            self?.waitingScreenViewModel?.startGame()
        }
        waitingScreenView.leaveGame.touchUpInside = { [weak self] in
            self?.waitingScreenViewModel?.tryToLeaveGame()
        }
        customPopUp.changeNamePopUpView.cancelButton.touchUpInside = { [weak self] in
            self?.endGamePopUp(shouldHide: true)
        }
        customPopUp.changeNamePopUpView.doneButton.touchUpInside = { [weak self] in
            self?.waitingScreenViewModel?.changeUsername(to: self?.customPopUp.textField.text)
        }
    }
    
    // MARK: - Helper Methods
    private func endGamePopUp(shouldHide: Bool) {
        customPopUp.isHidden = shouldHide
        waitingScreenView.isUserInteractionEnabled = shouldHide
    }
    
    @objc
    private func pencilTapped() {
        customPopUp.textField.text = gameData.playerObject.username
        endGamePopUp(shouldHide: false)
        customPopUp.textField.becomeFirstResponder()
    }
    
    // MARK: - WaitingScreenViewModel Methods
    func startGameLoading() {
        if !waitingScreenView.spinner.isAnimating {
            waitingScreenView.spinner.animate(with: waitingScreenView.startGame)
        }
    }
    
    func updateTableView() {
        waitingScreenView.tableHeight.constant = CGFloat(gameData.playerList.count) * UIElementsManager.tableViewCellHeight
        waitingScreenView.tableView.reloadData()
        waitingScreenView.tableView.layoutIfNeeded()
    }

    func startGameSucceeded(gameData: GameData) {
        navigationController?.pushViewController(GameSessionController(gameData: gameData), animated: true)
    }
    
    func changeNameSucceeded() {
        if let text = customPopUp.textField.text {
            oldUsername = gameData.playerObject.username
            gameData.playerObject.username = text
            waitingScreenView.tableView.reloadData()
        }
        endGamePopUp(shouldHide: true)
    }
    
    func startGameFailed() {

    }
    
    func leaveGame() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showErrorFlash(_ error: SpyfallError) {
        HUD.dimsBackground = false
        HUD.flash(.label(error.message), delay: 1.0)
    }
    
    // MARK: - TextField & Keyboard Methods
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
