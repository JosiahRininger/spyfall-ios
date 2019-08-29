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

final class JoinGameController: UIViewController, UITextFieldDelegate {

    var joinGameView = JoinGameView()
    
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
        
        view = joinGameView
    }
    
    @objc func segueToHomeController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func segueToWaitingScreenController() {
        if !textFieldsAreValid() { return }
        
        let nextScreen = WaitingScreenController()
        if let currentUsername = self.joinGameView.usernameTextField.text, let accessCode = self.joinGameView.accessCodeTextField.text {
            nextScreen.currentUsername = currentUsername
            nextScreen.accessCode = accessCode
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    func textFieldsAreValid() -> Bool {
        let alert = CreateAlertController().with(actions: UIAlertAction(title: "OK", style: .default))
        if joinGameView.usernameTextField.text?.isEmpty ?? true {
            alert.title = "Please enter a username"
        } else if joinGameView.usernameTextField.text?.count ?? 25 > 24 {
            alert.title = "Please enter a username less than 25 characters"
        } else if joinGameView.accessCodeTextField.text?.isEmpty ?? true {
            alert.title = "Please enter an access code"
        } else {
            return true
        }
        self.present(alert, animated: true)
        return false
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
