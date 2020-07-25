//
//  JoinGameViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/15/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import os.log

final class JoinGameController: UIViewController, JoinGameViewModelDelegate, UITextFieldDelegate {
    private var joinGameView = JoinGameView()
    private var joinGameViewModel: JoinGameViewModel?
    private var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinGameView.usernameTextField.delegate = self
        joinGameView.accessCodeTextField.delegate = self
        joinGameViewModel = JoinGameViewModel(delegate: self)
        
        setupView()
        
        // Notifications for KeyBoard Behavior
        NotificationCenter.default.addObserver(self, selector: #selector(JoinGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JoinGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        setupKeyboard()
        view.addSubview(joinGameView)
    }
    
    private func setupButtons() {
        joinGameView.join.touchUpInside = { [weak self] in
            guard let self = self else { return }
            self.joinGameViewModel?.joinGame(accessCode: self.joinGameView.accessCodeTextField.text?.lowercased() ?? "",
                                             username: self.joinGameView.usernameTextField.text ?? "")
        }

        joinGameView.back.touchUpInside = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - NewGameViewModel Methods
    func joinGameLoading() {
        joinGameView.isUserInteractionEnabled = false
        joinGameView.spinner.animate(with: self.joinGameView.join)
    }
    
    func joinGameSucceeded(gameData: GameData) {
        joinGameView.spinner.reset()
        self.navigationController?.pushViewController(WaitingScreenController(gameData: gameData), animated: true)
    }
    
    func joinGameFailed() {
        joinGameView.spinner.reset()
        joinGameView.isUserInteractionEnabled = true
    }
    
    func showErrorMessage(_ error: SpyfallError) {
        switch error {
        case SpyfallError.network: ErrorManager.showPopUp(for: view)
        default: ErrorManager.showFlash(with: error.message)
        }
    }
    
    // MARK: - TextField & Keyboard Methods
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
        default: SpyfallError.unknown.log("Invalid JoinGameController Textfield")
        return false
        }
    }
    
    private func setupKeyboard() {
        let toolBar = UIElementsManager.createToolBar(with: UIBarButtonItem(title: "Done",
                                                                            style: .plain,
                                                                            target: self,
                                                                            action: #selector(JoinGameController.dismissKeyboard)))
        joinGameView.usernameTextField.inputAccessoryView = toolBar
        joinGameView.accessCodeTextField.inputAccessoryView = toolBar
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc
    private func dismissKeyboard() {
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
