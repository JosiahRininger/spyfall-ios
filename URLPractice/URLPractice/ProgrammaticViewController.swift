//
//  ProgrammaticViewController.swift
//  URLPractice
//
//  Created by Josiah Rininger on 4/15/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class ProgrammaticViewController: UIViewController {

    var label: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        text.text = "You Did It!"
        text.font = UIFont(name: "AvenirNext-Regular", size: 50)
        text.layer.masksToBounds = false
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    var urlLabel: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        text.text = "You Did It!"
        text.font = UIFont(name: "AvenirNext-Regular", size: 50)
        text.layer.masksToBounds = false
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        textField.layer.cornerRadius = 25
        textField.keyboardType = .emailAddress
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        textField.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        textField.font = UIFont(name: "AvenirNext-Regular", size: 20)
        textField.returnKeyType = .done
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var accessCodeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        textField.layer.cornerRadius = 25
        textField.keyboardType = .emailAddress
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        textField.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        textField.placeholder = "Enter Access Code"
        textField.font = UIFont(name: "AvenirNext-Regular", size: 20)
        textField.returnKeyType = .done
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        view.backgroundColor = #colorLiteral(red: 0.07863354576, green: 0.5574134567, blue: 0.9573751092, alpha: 1)
        view.addSubview(label)
        view.addSubview(urlLabel)
        view.addSubview(emailTextField)
        view.addSubview(accessCodeTextField)
        view.addSubview(loginButton)
        setUpLabelConstraints()
        setUpUrlLabelConstraints()
        setUpEmailFieldConstraints()
        setUpAccessCodeFieldConstraints()
        setUpLoginButtonConstraints()
    }
    
    func setUpLabelConstraints() {
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.centerYAnchor.constraint(equalTo: urlLabel.topAnchor, constant: -50).isActive = true
    }
    
    func setUpUrlLabelConstraints() {
        urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        urlLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        urlLabel.centerYAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -50).isActive = true
    }
    
    func setUpEmailFieldConstraints() {
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: accessCodeTextField.topAnchor, constant: -50).isActive = true
    }
    
    func setUpAccessCodeFieldConstraints() {
        accessCodeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        accessCodeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        accessCodeTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        accessCodeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setUpLoginButtonConstraints() {
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: accessCodeTextField.bottomAnchor, constant: 50).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
