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

final class NewGameController: UIViewController, UITextFieldDelegate {
    
    var newGameView = NewGameView()
    
    var chosenLocation = String()
    var accessCode = String()
    var timeLimit = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameView.create.addTarget(self, action: #selector(createGameAction), for: .touchUpInside)
        newGameView.back.addTarget(self, action: #selector(segueToHomeController), for: .touchUpInside)

        newGameView.usernameTextField.delegate = self
        newGameView.timeLimitTextField.delegate = self
        newGameView.timeLimitTextField.addTarget(self, action: #selector(resignedFirstResponder(_:)), for: .editingChanged)
        
        setupView()
        createToolBar()
        setUpKeyboard()
    }
    
    private func setupView() {
        
        view = newGameView
    }
    
    @objc func segueToHomeController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createGameAction() {
        if !textFieldsAreValid() { return }
        // store selected location packs
        var chosenPacks = [String]()
        if newGameView.packOneView.isChecked { chosenPacks.append("pack 1") }
        if newGameView.packTwoView.isChecked { chosenPacks.append("pack 2") }
        if newGameView.specialPackView.isChecked { chosenPacks.append("special pack") }
        
        // create Player object
        let newPlayer = newGameView.usernameTextField.text!
        
        // create access code
        accessCode = NSUUID().uuidString.lowercased()
        while accessCode.count > 6 { accessCode.removeLast() }
        
        // set values on firebase
        let db = Firestore.firestore()
        
        // Grab random location
        chosenPacks.shuffle()
        db.collection(chosenPacks[0]).getDocuments { [unowned self] querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents.randomElement()
//                self.chosenLocation = document!.data()["location"] as! String
                if let chosenLocation = document?.data()["location"] as? String {
                    self.chosenLocation = chosenLocation
                }
            }
            
            if let timeLimit = Int(self.newGameView.timeLimitTextField.text ?? "0") {
                self.timeLimit = timeLimit
            }
            
            // Add a new document with a generated ID
            db.collection("games").document(self.accessCode).setData([
                "playerList": [newPlayer],
                "timeLimit": self.timeLimit,
                "started": false,
                "chosenPacks": chosenPacks,
                "chosenLocation": self.chosenLocation
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            let nextScreen = WaitingScreenController()
            nextScreen.currentUsername = self.newGameView.usernameTextField.text!
            nextScreen.accessCode = self.accessCode
            self.navigationController?.pushViewController(nextScreen, animated: true)
        }
    }

    func textFieldsAreValid() -> Bool {
        let alert = CreateAlertController().with(title: "",
                                                 message: nil,
                                                 actions: UIAlertAction(title: "OK", style: .default, handler: nil))
        if newGameView.usernameTextField.text?.isEmpty ?? true {
            alert.title = "Please enter a username"
        } else if newGameView.usernameTextField.text?.count ?? 25 > 24 {
            alert.title = "Please enter a username less than 25 characters"
        } else if !newGameView.packOneView.isChecked
            && !newGameView.packTwoView.isChecked
            && !newGameView.specialPackView.isChecked {
            alert.title = "Please select pack(s)"
        } else if newGameView.timeLimitTextField.text?.isEmpty ?? true {
            alert.title = "Please enter a time limit"
        } else {
            return true
        }
        self.present(alert, animated: true, completion: nil)
        return false
    }
    
    @objc func resignedFirstResponder(_ sender: Any) {
        if Int(newGameView.timeLimitTextField.text ?? "0") ?? 0 > 10 {
            newGameView.timeLimitTextField.text = ""
            let alert = CreateAlertController().with(title: "Please enter a time limit that is equal to or less than 10",
                                                     message: nil,
                                                     actions: UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    
    func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
