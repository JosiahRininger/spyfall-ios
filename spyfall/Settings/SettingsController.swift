//
//  SettingsController.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

final class SettingsController: UIViewController {

    var settingsView = SettingsView()
    var infoPopUpView = CustomPopUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoTapGesture = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        settingsView.infoView.addGestureRecognizer(infoTapGesture)
        
        setupView()
    }
    
    func setupView() {
        view = settingsView
    }
    
    @objc func infoTapped() {
        infoPopUpView.isHidden = false
    }

}
