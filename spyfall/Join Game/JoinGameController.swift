//
//  JoinGameViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/15/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import PKHUD
import os.log

final class JoinGameController: UIViewController, UITextFieldDelegate {

    var joinGameView = JoinGameView()
    var spinner = Spinner(frame: .zero)
    var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinGameView.usernameTextField.delegate = self
        joinGameView.accessCodeTextField.delegate = self
        
        setupView()
        
        // Notifications for KeyBoard Behavior
        NotificationCenter.default.addObserver(self, selector: #selector(JoinGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JoinGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        setupKeyboard()
        spinner = Spinner(frame: CGRect(x: 45.0, y: joinGameView.join.frame.minY + 21.0, width: 20.0, height: 20.0))
        view.addSubview(joinGameView)
        joinGameView.join.addSubview(spinner)
    }
    
    private func setupButtons() {
        joinGameView.join.touchUpInside = { [weak self] in self?.joinGameWasTapped() }

        joinGameView.back.touchUpInside = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Helper Methods
    @objc private func joinGameWasTapped() {
        self.joinGameView.back.isUserInteractionEnabled = false
        self.joinGameView.join.isUserInteractionEnabled = false
        spinner.animate(with: self.joinGameView.join)
        FirestoreManager.checkGamData(accessCode: joinGameView.accessCodeTextField.text?.lowercased() ?? "", username: joinGameView.usernameTextField.text ?? "") { [weak self] result in
            self?.handleGamData(validity: result)
        }
    }
    
    private func handleGamData(validity: GameDataValidity) {
        guard self.fieldsAreValid(validity) else { return }
        let gameData = GameData()
        gameData.accessCode = self.joinGameView.accessCodeTextField.text?.lowercased() ?? ""
        gameData.playerObject.username = self.joinGameView.usernameTextField.text ?? ""
        gameData.playerList = [gameData.playerObject.username]
        FirestoreManager.updateGameData(accessCode: gameData.accessCode,
                                        data: ["playerList": FieldValue.arrayUnion([gameData.playerObject.username])])
        self.navigationController?.pushViewController(WaitingScreenController(gameData: gameData), animated: true)
    }
    
    private func fieldsAreValid(_ validity: GameDataValidity) -> Bool {
        spinner.reset()
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
        self.joinGameView.back.isUserInteractionEnabled = true
        self.joinGameView.join.isUserInteractionEnabled = true
        return false
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
    
    // MARK: - Keyboard Set Up
    private func setupKeyboard() {
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        if joinGameView.usernameTextField.isFirstResponder {
            keyboardHeight = keyboardSize.cgRectValue.height
        }
    }
    
    // Moves view down if not centerd on screen
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.joinGameView.frame.origin.y != 0 {
            self.joinGameView.frame.origin.y = 0
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if joinGameView.usernameTextField.isFirstResponder {
                keyboardHeight = keyboardFrame.cgRectValue.size.height
                textFieldDidBeginEditing(joinGameView.usernameTextField)
            }
        }
    }
}
