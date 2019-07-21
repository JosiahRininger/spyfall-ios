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

class JoinGameController: UIViewController, UITextFieldDelegate {

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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func segueToWaitingScreenController() {
        if !textFieldsAreValid() { return }
        
        let nextScreen = WaitingScreenController()
        if let currentUsername = self.joinGameView.usernameTextField.text, let accessCode = self.joinGameView.accessCodeTextField.text {
            nextScreen.currentUsername = currentUsername
            nextScreen.accessCode = accessCode
            self.present(nextScreen, animated: true, completion: nil)
        }
    }
    
    func textFieldsAreValid() -> Bool {
        let sentAlert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        sentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if joinGameView.usernameTextField.text?.isEmpty ?? true {
            sentAlert.title = "Please enter a username"
        } else if joinGameView.usernameTextField.text?.count ?? 25 > 24 {
            sentAlert.title = "Please enter a username less than 25 characters"
        } else if joinGameView.accessCodeTextField.text?.isEmpty ?? true {
            sentAlert.title = "Please enter an access code"
        } else {
            return true
        }
        self.present(sentAlert, animated: true, completion: nil)
        return false
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(JoinGameController.dismissKeyboard))
        doneButton.tintColor = .secondaryColor
        toolBar.setItems([doneButton], animated: false)
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
