//
//  NewGameViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import os.log

final class NewGameController: UIViewController, NewGameViewModelDelegate, UITextFieldDelegate {
    private var newGameView = NewGameView()
    private var newGameViewModel = NewGameViewModel()
    private var keyboardHeight: CGFloat = 0.0
    
    private var chosenPacks: [String] {
        var packs = [String]()
        if newGameView.packOneView.isChecked { packs.append(Constants.DBStrings.standardPackOne) }
        if newGameView.packTwoView.isChecked { packs.append(Constants.DBStrings.standardPackTwo) }
        if newGameView.specialPackView.isChecked { packs.append(Constants.DBStrings.specialPackOne) }
        packs.shuffle()
        return packs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameView.usernameTextField.delegate = self
        newGameView.timeLimitTextField.delegate = self
        newGameViewModel.delegate = self

        setupView()

        // Notifications for KeyBoard Behavior
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        setUpKeyboard()
        view.addSubview(newGameView)
    }
    
    private func setupButtons() {
        newGameView.back.touchUpInside = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        newGameView.create.touchUpInside = { [weak self] in
            guard let self = self else { return }
            self.newGameViewModel.createGame(chosenPacks: self.chosenPacks,
                                              initialPlayer: self.newGameView.usernameTextField.text ?? "",
                                              timeLimit: Int(self.newGameView.timeLimitTextField.text ?? "-1") ?? -1)
        }
    }
    
    // MARK: - NewGameViewModel Methods
    func newGameLoading() {
        newGameView.create.isUserInteractionEnabled = false
        newGameView.spinner.animate(with: newGameView.create)
    }
    
    func createGameSucceeded(gameData: GameData) {
        newGameView.spinner.reset()
        self.navigationController?.pushViewController(WaitingScreenController(gameData: gameData),
                                                      animated: true)
    }
    
    func createGameFailed() {
        newGameView.spinner.reset()
        newGameView.create.isUserInteractionEnabled = true
    }
    
    func showErrorMessage(_ error: SpyfallError) {
        switch error {
        case SpyfallError.network: ErrorManager.showPopUp(for: view)
        default:
            if error.message == SpyfallError.newGame(.invalidTimeLimitSelected).message {
                newGameView.timeLimitTextField.text = ""
            }
            ErrorManager.showFlash(with: error.message)
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
        case newGameView.usernameTextField: return updatedText.count <= 24
        case newGameView.timeLimitTextField: return updatedText.count <= 2
        default: SpyfallError.unknown.log("Invalid NewGameController Textfield")
        return false
        }
    }
    
    private func setUpKeyboard() {
        let toolBar = UIElementsManager.createToolBar(with: UIBarButtonItem(title: "Done",
                                                                            style: .plain,
                                                                            target: self,
                                                                            action: #selector(NewGameController.dismissKeyboard)))
        newGameView.usernameTextField.inputAccessoryView = toolBar
        newGameView.timeLimitTextField.inputAccessoryView = toolBar
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
        if textField == newGameView.timeLimitTextField {
            let yPos = UIElementsManager.windowHeight
                - (newGameView.newGameStackView.frame.maxY
                    - (newGameView.timeView.frame.height
                        - newGameView.timeLimitTextField.frame.maxY))
            if yPos < keyboardHeight && newGameView.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.33, animations: {
                    self.newGameView.frame.origin.y -= (10 + self.keyboardHeight - yPos)
                })
            }
        }
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        if newGameView.timeLimitTextField.isFirstResponder {
            keyboardHeight = keyboardSize.cgRectValue.height
        }
    }
    
    // Moves view down if not centerd on screen
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if self.newGameView.frame.origin.y != 0 {
            self.newGameView.frame.origin.y = 0
        }
    }
    
    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if newGameView.timeLimitTextField.isFirstResponder {
                keyboardHeight = keyboardFrame.cgRectValue.size.height
                textFieldDidBeginEditing(newGameView.timeLimitTextField)
            }
        }
    }    
}
