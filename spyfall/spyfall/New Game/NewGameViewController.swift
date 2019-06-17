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

class NewGameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeLimitTextField: UITextField!
    @IBOutlet weak var createGame: UIButton!
    
    @IBOutlet weak var packOne: CheckBox!
    @IBOutlet weak var packTwo: CheckBox!
    @IBOutlet weak var specialPack: CheckBox!
    
    var chosenLocation = String()
    let timeRange = ["1","2","3","4","5","6","7","8","9","10"]
    var timeLimit = 8
    var accessCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        createGame.layer.borderWidth = 1
        timeLimitTextField.tintColor = .clear
        createTimeLimitPicker()
        createPickerToolBar()
        setUpKeyboard()
    }
    
    @IBAction func createGameAction(_ sender: Any) {
        
        // store selected location packs
        var chosenPacks = [String]()
        if packOne.isChecked { chosenPacks.append("pack 1") }
        if packTwo.isChecked { chosenPacks.append("pack 2") }
        if specialPack.isChecked { chosenPacks.append("special pack") }
        
        // create Player object
        let newPlayer = nameTextField.text!

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
                "isStarted": false,
                "chosenPacks": chosenPacks,
                "chosenLocation": self.chosenLocation
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }

    private func createTimeLimitPicker() {
        let timePicker = UIPickerView()
        timePicker.delegate = self
        timeLimitTextField.inputView = timePicker
        
        timePicker.backgroundColor = .white
    }
    
    func createPickerToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewGameViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        timeLimitTextField.inputAccessoryView = toolBar
    }
    
    func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateWaitingScreen" {
            let currentUsername: String
            currentUsername = nameTextField.text!
            guard let dest = segue.destination as? WaitingScreenViewController else {
                fatalError()
            }
            dest.currentUsername = currentUsername
            dest.accessCode = accessCode
        }
    }
}

extension NewGameViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,     numberOfRowsInComponent component: Int) -> Int {
        return timeRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeLimit = Int(timeRange[row])!
        timeLimitTextField.text = timeRange[row]
        timeLimitTextField.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
}
