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
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupView() {
        setupButtons()
        setupKeyboard()
        spinner = Spinner(frame: CGRect(x: 45.0, y: joinGameView.join.frame.minY + 21.0, width: 20.0, height: 20.0))
        view.addSubview(joinGameView)
        joinGameView.join.addSubview(spinner)
    }
    
    private func setupButtons() {
        joinGameView.join.touchUpInside = { [weak self] in
            self?.segueToWaitingScreenController()
        }

        joinGameView.back.touchUpInside = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func segueToWaitingScreenController() {
        self.joinGameView.back.isUserInteractionEnabled = false
        self.joinGameView.join.isUserInteractionEnabled = false
        spinner.animate(with: self.joinGameView.join)
        FirestoreManager.checkGamData(accessCode: joinGameView.accessCodeTextField.text ?? "", username: joinGameView.usernameTextField.text ?? "") { result in
            if self.fieldsAreValid(result: result) {
                let gameData = GameData()
                gameData.accessCode = self.joinGameView.accessCodeTextField.text ?? ""
                gameData.playerObject.username = self.joinGameView.usernameTextField.text ?? ""
                gameData.playerList = [gameData.playerObject.username]
                self.navigationController?.pushViewController(WaitingScreenController(gameData: gameData), animated: true)
            }
        }
    }
    
    private func fieldsAreValid(result: (gameExists: Bool, usernameFree: Bool)) -> Bool {
        spinner.reset()

        HUD.dimsBackground = false
        if self.joinGameView.accessCodeTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter an access code"), delay: 1.0)
        } else if self.joinGameView.usernameTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a username"), delay: 1.0)
        } else if !result.gameExists {
            HUD.flash(.label("No game with that access code"), delay: 1.0)
        } else if !result.usernameFree {
            HUD.flash(.label("Username is already taken"), delay: 1.0)
        } else {
            return true
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
        default: print("INVALID TEXTFIELD"); return false
        }
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
