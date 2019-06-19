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

class NewGameController: UIViewController {
    
    var newGameView = NewGameView()
    
    var chosenLocation = String()
    var accessCode = String()
    var timeLimit = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        createTimeLimitPicker()
        createToolBar()
        setUpKeyboard()
    }
    
    private func setupView() {
        
        view = newGameView
    }
    
    @objc func createGameAction() {
        
        // store selected location packs
        var chosenPacks = [String]()
        if newGameView.packOneCheckBox.isChecked { chosenPacks.append("pack 1") }
        if newGameView.packTwoCheckBox.isChecked { chosenPacks.append("pack 2") }
        if newGameView.specialPackCheckBox.isChecked { chosenPacks.append("special pack") }
        
        // create Player object
        let newPlayer = newGameView.nameTextField.text!

        // create access code
        accessCode = NSUUID().uuidString.lowercased()
        while accessCode.count > 6 { accessCode.removeLast() }
        
        // set values on firebase
        let db = Firestore.firestore()
        
        // Grab random location
        chosenPacks.shuffle()
        db.collection(chosenPacks[0]).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents.randomElement()
                self.chosenLocation = document!.data()["location"] as! String
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
//            let currentUsername: String
//            currentUsername = newGameView.nameTextField.text!
//            guard let dest = segue.destination as? WaitingScreenViewController else {
//                fatalError()
//            }
//            dest.currentUsername = currentUsername
//            dest.accessCode = accessCode
//            present(NewGameController(), animated: true, completion: nil)
        }
    }

    private func createTimeLimitPicker() {
        let timePicker = UIPickerView()
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.selectRow(newGameView.timeRange.firstIndex(of: "8") ?? 0, inComponent: 0, animated: true)

        newGameView.timeLimitTextField.inputView = timePicker
        newGameView.timeLimitTextField.tintColor = .clear
        
        timePicker.backgroundColor = .white
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewGameController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        newGameView.nameTextField.inputAccessoryView = toolBar
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CreateWaitingScreen" {
//            let currentUsername: String
//            currentUsername = newGameView.nameTextField.text!
//            guard let dest = segue.destination as? WaitingScreenViewController else {
//                fatalError()
//            }
//            dest.currentUsername = currentUsername
//            dest.accessCode = accessCode
//        }
//    }
}

extension NewGameController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return newGameView.timeRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return newGameView.timeRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeLimit = Int(newGameView.timeRange[row])!
        newGameView.timeLimitTextField.text = newGameView.timeRange[row]
        newGameView.timeLimitTextField.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
}
