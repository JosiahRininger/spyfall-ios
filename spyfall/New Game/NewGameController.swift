//
//  NewGameViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import PKHUD

final class NewGameController: UIViewController, UITextFieldDelegate {
    
    var newGameView = NewGameView()
    let spinner = Spinner(frame: .zero)
    
    var chosenLocation = String()
    var accessCode = String()
    var timeLimit = Int()
    var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameView.create.addTarget(self, action: #selector(createGameAction), for: .touchUpInside)
        newGameView.back.addTarget(self, action: #selector(segueToHomeController), for: .touchUpInside)

        newGameView.usernameTextField.delegate = self
        newGameView.timeLimitTextField.delegate = self
        
        setupView()
        createToolBar()
        setUpKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupView() {
        view.addSubview(newGameView)
        newGameView.create.addSubview(spinner)
    }
    
    @objc func segueToHomeController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createGameAction() {
        if !textFieldsAreValid() { return }
        newGameView.back.isUserInteractionEnabled = false
        newGameView.create.isUserInteractionEnabled = false
        
        spinner.animate(with: newGameView.create)
        
        // store selected location packs
        var chosenPacks = [String]()
        if newGameView.packOneView.isChecked { chosenPacks.append(Constants.DBStrings.standardPackOne) }
        if newGameView.packTwoView.isChecked { chosenPacks.append(Constants.DBStrings.standardPackTwo) }
        if newGameView.specialPackView.isChecked { chosenPacks.append(Constants.DBStrings.specialPackOne) }
        
        // create access code
        accessCode = String(NSUUID().uuidString.lowercased().prefix(6))
        
        // Grab random location
        chosenPacks.shuffle()
        
        FirestoreManager.retrieveChosenLocation(chosenPack: chosenPacks[0]) { result in
            self.chosenLocation = result
            
            if let timeLimit = Int(self.newGameView.timeLimitTextField.text ?? "0") {
                self.timeLimit = timeLimit
            }
            
            // Add a new document with a generated ID
            FirestoreManager.setGameData(accessCode: self.accessCode, data: [
                "playerList": [self.newGameView.usernameTextField.text ?? ""],
                "timeLimit": self.timeLimit,
                "started": false,
                "chosenPacks": chosenPacks,
                "chosenLocation": self.chosenLocation
                ])
            
            // Navigate to the next screen with the new accessCode and username
            let nextScreen = WaitingScreenController()
            nextScreen.currentUsername = self.newGameView.usernameTextField.text!
            nextScreen.accessCode = self.accessCode
            self.navigationController?.pushViewController(nextScreen, animated: true)
        }
    }

    func textFieldsAreValid() -> Bool {
        HUD.dimsBackground = false
        if newGameView.usernameTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a username"), delay: 1.0)
        } else if !newGameView.packOneView.isChecked
            && !newGameView.packTwoView.isChecked
            && !newGameView.specialPackView.isChecked {
            HUD.flash(.label("Please select pack(s)"), delay: 1.0)
        } else if newGameView.timeLimitTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a time limit"), delay: 1.0)
        } else if Int(newGameView.timeLimitTextField.text ?? "11") ?? 11 > 10
            || Int(newGameView.timeLimitTextField.text ?? "0") ?? 0 < 1 {
            newGameView.timeLimitTextField.text = ""
            HUD.flash(.label("Please enter a time limit between 0 and 11"), delay: 1.0)
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
        default: print("INVALID TEXTFIELD"); return false
        }
    }
    
    func createToolBar() {
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
    
    // MARK: - Keyboard Set Up
    func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Moves view up if textfield is covered
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newGameView.timeLimitTextField {
            let yPos = UIElementSizes.windowHeight - newGameView.timeLimitTextField.frame.maxY
            if yPos < keyboardHeight && newGameView.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.33, animations: {
                    self.newGameView.frame.origin.y -= (10 + self.keyboardHeight - yPos)
                })
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        if newGameView.timeLimitTextField.isFirstResponder {
            keyboardHeight = keyboardSize.cgRectValue.height
        }
    }
    
    // Moves view down if not centerd on screen
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.newGameView.frame.origin.y != 0 {
            self.newGameView.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if newGameView.timeLimitTextField.isFirstResponder {
                keyboardHeight = keyboardFrame.cgRectValue.size.height
                textFieldDidBeginEditing(newGameView.timeLimitTextField)
            }
        }
    }    
}
