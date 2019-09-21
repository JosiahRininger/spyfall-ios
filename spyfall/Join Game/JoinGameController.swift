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
    let spinner = Spinner(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinGameView.join.addTarget(self, action: #selector(segueToWaitingScreenController), for: .touchUpInside)
        joinGameView.back.addTarget(self, action: #selector(segueToHomeController), for: .touchUpInside)
        
        joinGameView.usernameTextField.delegate = self
        joinGameView.accessCodeTextField.delegate = self
        
        setupView()
        createToolBar()
        setupKeyboard()
    }
    
    func setupView() {
        joinGameView.join.addSubview(spinner)
        
        view = joinGameView
    }
    
    @objc func segueToHomeController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func segueToWaitingScreenController() {
        if !textFieldsAreValid() { return }
        
        spinner.animate(with: joinGameView.join)
        
        joinGameView.back.isUserInteractionEnabled = false
        joinGameView.join.isUserInteractionEnabled = false
        
        let nextScreen = WaitingScreenController()
        if let currentUsername = self.joinGameView.usernameTextField.text, let accessCode = self.joinGameView.accessCodeTextField.text {
            nextScreen.currentUsername = currentUsername
            nextScreen.accessCode = accessCode
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    func textFieldsAreValid() -> Bool {
        HUD.dimsBackground = false
        if joinGameView.accessCodeTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter an access code"), delay: 1.0)
        } else if joinGameView.usernameTextField.text?.isEmpty ?? true {
            HUD.flash(.label("Please enter a username"), delay: 1.0)
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
        case joinGameView.accessCodeTextField: return updatedText.count <= 6
        case joinGameView.usernameTextField: return updatedText.count <= 24
        default: print("INVALID TEXTFIELD"); return false
        }
    }
    
    func createToolBar() {
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
    
    func setupKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
