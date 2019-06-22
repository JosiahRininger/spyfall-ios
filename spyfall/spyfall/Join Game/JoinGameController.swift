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

class JoinGameController: UIViewController {

    @IBOutlet weak var accessCodeTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var joinGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCodeTextField.borderStyle = UITextField.BorderStyle.roundedRect
        usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        joinGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        joinGame.layer.borderWidth = 1
        
        setupKeyboard()
        
    }
    
    @IBAction func joinGameAction(_ sender: Any) {
    
    }
    
    func setupKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JoinWaitingScreen" {
            let currentUsername: String
            currentUsername = usernameTextField.text!
            guard let dest = segue.destination as? WaitingScreenController else {
                fatalError()
            }
            dest.currentUsername = currentUsername
            dest.accessCode = accessCodeTextField.text!
        }
    }

}
