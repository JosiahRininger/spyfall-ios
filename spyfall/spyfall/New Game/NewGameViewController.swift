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
    
    let timeRange = ["1","2","3","4","5","6","7","8","9","10"]
    var selectedTime = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        createGame.layer.borderWidth = 1
        createTimeLimitPicker()
        createPickerToolBar()
    }
    
    @IBAction func createGameAction(_ sender: Any) {
        
        //let newGame = Game(playerList: ["playerList" : [Player("username": "name", "role": "None", "votes": 0)]], timeLimit: ["timeLimit" : selectedTime])
        //Game(timeLimit: selectedTime, playerList: [Player(username: nameTextField.text! ?? "Name", role: "None", votes: 0)])
        
//        func saveToFirebase() {
//            let usersRef = myFirebase.child(users)
//            let dict = ["name": self.myName, "food", self.myFood]
//
//            let thisUserRef = usersRef.childByAutoId()
//            thisUserRef.setValue(dict)
//        }
        
        let ref = Database.database().reference().child("games")
        let id = ref.childByAutoId()

        var accessCode = ""
        for character in id.key! where (character.isLetter || character.isNumber) && accessCode.count < 9 {accessCode.append(character)}
        
        ref.child("\(accessCode)").setValue(["playerList":[], "timeLimit":selectedTime])
        
        
        
        
//        ref.child("someid").observeSingleEvent(of: .value) {
//            (snapshot) in
//            let data = snapshot.value as? [String:Any]
//        }
 
        // Add a new document with a generated ID
//        let db = Firestore.firestore()
//
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//
//        let citiesRef = db.collection("cities")
//
//        citiesRef.document("SF").setData([
//            "name": "San Francisco",
//            "state": "CA",
//            "country": "USA",
//            "capital": false,
//            "population": 860000,
//            "regions": ["west_coast", "norcal"]
//            ])
        
        
        
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        selectedTime = Int(timeRange[row])!
        timeLimitTextField.text = timeRange[row]
        timeLimitTextField.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
}
