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
    
    let timeRange = ["1","2","3","4","5","6","7","8","9","10"]
    var timeLimit = 8
    var accessCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        createGame.layer.borderWidth = 1
        createTimeLimitPicker()
        createPickerToolBar()
    }
    
    @IBAction func createGameAction(_ sender: Any) {
        
        // store selected location packs
        var chosenLocations = [String]()
        if packOne.isChecked {
            chosenLocations.append("pack 1")
        }
        if packTwo.isChecked {
            chosenLocations.append("pack 2")
        }
        if specialPack.isChecked {
            chosenLocations.append("special pack")
        }
        
        // create Player object
        let newPlayer = nameTextField.text!

        // create access code
        accessCode = NSUUID().uuidString.lowercased()
        while accessCode.count > 6 { accessCode.removeLast() }
        
        // set values on firebase
        let db = Firestore.firestore()

        // Add a new document with a generated ID
        db.collection("games").document(accessCode).setData([
            "playerList": [newPlayer],
            "timeLimit": timeLimit,
            "isStarted": false,
            "chosenPacks": chosenLocations
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
//        db.collection("games").document().updateData(["playerList" : FieldValue.arrayUnion(["Josiahisbetterthanyou"])]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//        // Atomically remove a region from the "regions" array field.
//        washingtonRef.updateData([
//            "regions": FieldValue.arrayRemove(["east_coast"])
//            ])
        /*ref.child("\(accessCode)").setValue(["playerList": [newPlayer]])
        ref.child("\(accessCode)").updateChildValues(["timeLimit" : timeLimit])
        ref.child("\(accessCode)").updateChildValues(["isStarted" : false])
        ref.child("\(accessCode)").updateChildValues(["chosenPacks" : chosenLocations])*/
//        ref.child("\(accessCode)").updateChildValues(["chosenLocation" : newGame.chosenLocation])
    }
    
//      let location: String = grabLocation(locations: chosenLocations)
//    func grabLocation(locations: [String]) -> String {
//        var randomLocation = String()
//        let db = Firestore.firestore()
//        db.collection(locations.randomElement()!).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                let document = querySnapshot!.documents.randomElement()
//                randomLocation = document!.documentID
//                print("\n\n\n\n\n\(document!.documentID)")
//                print("\n\n\n\n\n\(randomLocation)")
//            }
//        }
//        // this exacutes once location are grabbed
//        return randomLocation
//    }
    //        ref.child("someid").observeSingleEvent(of: .value) {
    //            (snapshot) in
    //            let data = snapshot.value as? [String:Any]
    //        }
    
    // Add a new document with a generated ID
    //        let db = Firestore.firestore()
    //
    //        var ref: DocumentReference? = nil

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaitingScreen" {
            let currentUsername: String
            currentUsername = nameTextField.text!
            guard let dest = segue.destination as? WaitingScreenTableViewController else {
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
