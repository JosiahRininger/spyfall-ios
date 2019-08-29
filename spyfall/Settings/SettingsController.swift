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
        
        settingsView.back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        let infoTapGesture = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        settingsView.infoView.addGestureRecognizer(infoTapGesture)
        
        setupView()
    }
    
    func setupView() {
        view = settingsView
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func infoTapped() {
        infoPopUpView.isHidden = false
    }

}
