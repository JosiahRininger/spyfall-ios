//
//  HomeViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/6/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseCrashlytics

final class HomeController: UIViewController {

    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        animateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.infoView.backgroundColor = .secondaryColor
        homeView.rulesLabel.textColor = .secondaryColor
        homeView.joinGame.backgroundColor = .secondaryColor
        homeView.rulesPopUpView.doneButton.backgroundColor = .secondaryColor
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        view = homeView
    }
    
    private func animateView() {
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
    
    fileprivate func setupButtons() {
        homeView.newGame.touchUpInside = { [weak self] in
            self?.navigationController?.pushViewController(NewGameController(), animated: true)
        }
        homeView.joinGame.touchUpInside = { [weak self] in
            self?.navigationController?.pushViewController(JoinGameController(), animated: true)
        }
        homeView.settings.touchUpInside = {  [weak self] in
            guard let self = self else { return }
            self.present(SettingsController(parentVC: self), animated: true)
        }
        
        // Sets up the actions around the rules pop up
        let rulesGesture = UITapGestureRecognizer(target: self, action: #selector(rulesViewTapped))
        homeView.rulesView.addGestureRecognizer(rulesGesture)
        homeView.rulesPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.endGamePopUp(shouldHide: true)
        }
    }
    
    // MARK: - Helper Methods
    private func endGamePopUp(shouldHide: Bool) {
        homeView.settings.isUserInteractionEnabled = shouldHide
        homeView.newGame.isUserInteractionEnabled = shouldHide
        homeView.joinGame.isUserInteractionEnabled = shouldHide
        homeView.rulesPopUpView.isHidden = shouldHide
    }
    
    @objc
    private func rulesViewTapped() {
        endGamePopUp(shouldHide: false)
    }
}
