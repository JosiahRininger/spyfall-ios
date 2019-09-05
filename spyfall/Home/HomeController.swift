//
//  HomeViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/6/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

final class HomeController: UIViewController {

    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.newGame.addTarget(self, action: #selector(segueToNewGameController), for: .touchUpInside)
        homeView.joinGame.addTarget(self, action: #selector(segueToJoinGameController), for: .touchUpInside)
        homeView.settings.addTarget(self, action: #selector(segueToSettingsController), for: .touchUpInside)
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.infoView.backgroundColor = .secondaryColor
        homeView.rulesLabel.textColor = .secondaryColor
        homeView.joinGame.backgroundColor = .secondaryColor
    }

    private func setupView() {
        
        view = homeView
    }
    
    @objc func segueToNewGameController() {
        self.navigationController?.pushViewController(NewGameController(), animated: true)
    }
    
    @objc func segueToJoinGameController() {
        self.navigationController?.pushViewController(JoinGameController(), animated: true)
    }
    
    @objc func segueToSettingsController() {
        self.navigationController?.pushViewController(SettingsController(), animated: true)
    }
}
