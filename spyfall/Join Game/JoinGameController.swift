//
//  JoinGameViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/15/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore
import PKHUD
import os.log
import Reachability

final class JoinGameController: UIViewController, JoinGameViewModelDelegate, UITextFieldDelegate {

    var joinGameView = JoinGameView()
    var joinGameViewModel: JoinGameViewModel?
    var networkErrorPopUp = NetworkErrorPopUpView()
    var keyboardHeight: CGFloat = 0.0
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinGameView.usernameTextField.delegate = self
        joinGameView.accessCodeTextField.delegate = self
        joinGameViewModel = JoinGameViewModel(delegate: self)
        
        setupView()
        
        // Listen to changes in connection
        do {
            try reachability.startNotifier()
        } catch {
            os_log("Notifier error: ",
                   log: SystemLogger.shared.logger,
                   type: .error,
                   "Unable to start notifier")
        }
        
        // Notifications for KeyBoard Behavior
        NotificationCenter.default.addObserver(self, selector: #selector(JoinGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JoinGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        setupKeyboard()
        view.addSubviews(joinGameView, networkErrorPopUp)
    }
    
    private func setupButtons() {
        joinGameView.join.touchUpInside = { [weak self] in self?.joinGameWasTapped() }

        joinGameView.back.touchUpInside = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        networkErrorPopUp.networkErrorPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.networkErrorPopUp.isUserInteractionEnabled = false
            self?.networkErrorPopUp.networkErrorPopUpView.isHidden = true
        }
    }
    
    // MARK: - Helper Methods
    @objc
    private func joinGameWasTapped() {
        
        switch reachability.connection {
        case .wifi, .cellular:
            joinGameView.isUserInteractionEnabled = false
            joinGameView.spinner.animate(with: self.joinGameView.join)
            joinGameViewModel?.handleGamData(accessCode: joinGameView.accessCodeTextField.text?.lowercased() ?? "",
                                             username: joinGameView.usernameTextField.text ?? "")
        case .unavailable, .none:
            networkErrorPopUp.isUserInteractionEnabled = true
            networkErrorPopUp.networkErrorPopUpView.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under the respective textfields max characters
        switch textField {
        case joinGameView.accessCodeTextField: return updatedText.count <= 6
        case joinGameView.usernameTextField: return updatedText.count <= 24
        default: os_log("INVALID TEXTFIELD"); return false
        }
    }
    
    // MARK: - NewGameViewModel Methods
    @discardableResult
    func fieldsAreValid(_ validity: GameDataValidity) -> Bool {
        joinGameView.spinner.reset()
        HUD.dimsBackground = false
        switch validity {
        case .accessCodeIsEmpty: HUD.flash(.label("Please enter an access code"), delay: 1.0)
        case .usernameIsEmpty: HUD.flash(.label("Please enter a username"), delay: 1.0)
        case .gameDoesNotExist: HUD.flash(.label("No game with that access code"), delay: 1.0)
        case .usernameIsTaken: HUD.flash(.label("Username is already taken"), delay: 1.0)
        case .playersAreFull: HUD.flash(.label("Game is full"), delay: 1.0)
        case .gameHasAlreadyStarted: HUD.flash(.label("Game has already started"), delay: 1.0)
        case .AllFieldsAreValid: return true
        }
        joinGameView.isUserInteractionEnabled = true
        return false
    }
    
    func gameDataUpdated(gameData: GameData) {
        self.navigationController?.pushViewController(WaitingScreenController(gameData: gameData), animated: true)
    }
    
    // MARK: - Keyboard Set Up
    private func setupKeyboard() {
        createToolBar()
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(JoinGameController.dismissKeyboard))
        doneButton.tintColor = .secondaryColor
        let flexibilitySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibilitySpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        joinGameView.usernameTextField.inputAccessoryView = toolBar
        joinGameView.accessCodeTextField.inputAccessoryView = toolBar
    }

    // Moves view up if textfield is covered
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == joinGameView.usernameTextField {
            let yPos = UIElementsManager.windowHeight - joinGameView.usernameTextField.frame.maxY
            if yPos < keyboardHeight && joinGameView.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.33, animations: {
                    self.joinGameView.frame.origin.y -= (10 + self.keyboardHeight - yPos)
                })
            }
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        if joinGameView.usernameTextField.isFirstResponder {
            keyboardHeight = keyboardSize.cgRectValue.height
        }
    }
    
    // Moves view down if not centerd on screen
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.joinGameView.frame.origin.y != 0 {
            self.joinGameView.frame.origin.y = 0
        }
    }
    
    @objc
    private func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if joinGameView.usernameTextField.isFirstResponder {
                keyboardHeight = keyboardFrame.cgRectValue.size.height
                textFieldDidBeginEditing(joinGameView.usernameTextField)
            }
        }
    }
}
