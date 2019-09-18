//
//  HomeViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/6/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import Crashlytics

final class HomeController: UIViewController {

    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        homeView.welcomeToLabel.center.y += 30
        homeView.welcomeToLabel.alpha = 0.0
        homeView.spyfallLabel.center.y += 30
        homeView.spyfallLabel.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.homeView.welcomeToLabel.center.y -= 30.0
            self.homeView.welcomeToLabel.alpha = 1.0
            self.homeView.spyfallLabel.center.y -= 30.0
            self.homeView.spyfallLabel.alpha = 1.0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.infoView.backgroundColor = .secondaryColor
        homeView.rulesLabel.textColor = .secondaryColor
        homeView.joinGame.backgroundColor = .secondaryColor
        homeView.rulesPopUpView.doneButton.backgroundColor = .secondaryColor
    }

    private func setupView() {
        view = homeView
        
        setupButtons()
    }
    
    fileprivate func setupButtons() {
        
        // Sets up homeView buttons
        homeView.newGame.touchUpInside = { [weak self] in
            self?.navigationController?.pushViewController(NewGameController(), animated: true)
        }
        homeView.joinGame.touchUpInside = { [weak self] in
            self?.navigationController?.pushViewController(JoinGameController(), animated: true)
        }
        homeView.settings.touchUpInside = {  [weak self] in
            self?.navigationController?.pushViewController(SettingsController(), animated: true)
        }
        
        // Sets up the actions around the rules pop up
        let rulesGesture = UITapGestureRecognizer(target: self, action: #selector(rulesViewTapped))
        homeView.rulesView.addGestureRecognizer(rulesGesture)
        homeView.rulesPopUpView.doneButton.touchUpInside = { [weak self] in self?.resetViews() }
    }
    
    @objc func rulesViewTapped() {
        homeView.newGame.isUserInteractionEnabled = false
        homeView.joinGame.isUserInteractionEnabled = false
        homeView.rulesPopUpView.isHidden = false
    }
    
    private func resetViews() {
        homeView.newGame.isUserInteractionEnabled = true
        homeView.joinGame.isUserInteractionEnabled = true
        homeView.rulesPopUpView.isHidden = true
    }
}
