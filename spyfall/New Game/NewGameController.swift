//
//  NewGameViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import PKHUD
import os.log
import Reachability

final class NewGameController: UIViewController, NewGameViewModelDelegate, UITextFieldDelegate {
    var newGameView = NewGameView()
    var newGameViewModel: NewGameViewModel?
    var networkErrorPopUp = NetworkErrorPopUpView()
    var keyboardHeight: CGFloat = 0.0
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newGameView.usernameTextField.delegate = self
        newGameView.timeLimitTextField.delegate = self
        newGameViewModel = NewGameViewModel(delegate: self)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        setUpKeyboard()
        view.addSubviews(newGameView, networkErrorPopUp)
    }
    
    private func setupButtons() {
        newGameView.create.touchUpInside = { [weak self] in self?.createWasTapped() }
        newGameView.back.touchUpInside = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        networkErrorPopUp.networkErrorPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.networkErrorPopUp.isUserInteractionEnabled = false
            self?.networkErrorPopUp.networkErrorPopUpView.isHidden = true
        }
    }
    
    // MARK: - Helper Methods
    private func createWasTapped() {
        guard textFieldsAreValid else { return }
        
        switch reachability.connection {
        case .wifi, .cellular:
            newGameView.isUserInteractionEnabled = false
            newGameView.spinner.animate(with: newGameView.create)

            newGameViewModel?.createNewGame(chosenPacks: chosenPacks,
                                           initialPlayer: newGameView.usernameTextField.text ?? "",
                                           timeLimit: Int(newGameView.timeLimitTextField.text ?? "0") ?? 1)
        case .unavailable, .none:
            networkErrorPopUp.isUserInteractionEnabled = true
            networkErrorPopUp.networkErrorPopUpView.isHidden = false
        }
    }
    
    private var chosenPacks: [String] {
        // store selected location packs
        var chosenPacks = [String]()
        if newGameView.packOneView.isChecked { chosenPacks.append(Constants.DBStrings.standardPackOne) }
        if newGameView.packTwoView.isChecked { chosenPacks.append(Constants.DBStrings.standardPackTwo) }
        if newGameView.specialPackView.isChecked { chosenPacks.append(Constants.DBStrings.specialPackOne) }
        chosenPacks.shuffle()
        
        return chosenPacks
    }

    private var textFieldsAreValid: Bool {
        HUD.dimsBackground = false
        if newGameView.usernameTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a username"), delay: 1.0)
        } else if chosenPacks.isEmpty {
            HUD.flash(.label("Please select pack(s)"), delay: 1.0)
        } else if newGameView.timeLimitTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a time limit"), delay: 1.0)
        } else if Int(newGameView.timeLimitTextField.text ?? "11") ?? 11 > 10
            || Int(newGameView.timeLimitTextField.text ?? "0") ?? 0 < 1 {
            newGameView.timeLimitTextField.text = ""
            HUD.flash(.label("Please enter a time limit between 1 and 10"), delay: 1.0)
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

        // make sure the result is under the respective textfields max characters
        switch textField {
        case newGameView.usernameTextField: return updatedText.count <= 24
        case newGameView.timeLimitTextField: return updatedText.count <= 2
        default: os_log("INVALID TEXTFIELD"); return false
        }
    }
    
    // MARK: - NewGameViewModel Methods
    func gameDataSet(gameData: GameData) {
        self.navigationController?.pushViewController(WaitingScreenController(gameData: gameData),
                                                      animated: true)
    }
    
    // MARK: - Keyboard Set Up
    private func setUpKeyboard() {
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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewGameController.dismissKeyboard))
        doneButton.tintColor = .secondaryColor
        let flexibilitySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibilitySpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        newGameView.usernameTextField.inputAccessoryView = toolBar
        newGameView.timeLimitTextField.inputAccessoryView = toolBar
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
