//
//  HomeViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/6/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.newGame.addTarget(self, action: #selector(segueToNewGameController), for: .touchUpInside)
        homeView.joinGame.addTarget(self, action: #selector(segueToJoinGameController), for: .touchUpInside)
        
        setupView()
    }

    private func setupView() {
        
        view = homeView
    }
    
    @objc func segueToNewGameController() {
        present(NewGameController(), animated: true, completion: nil)
    }
    
    @objc func segueToJoinGameController() {
        present(JoinGameController(), animated: true, completion: nil)
    }
}
