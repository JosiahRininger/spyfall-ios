//
//  UserInfoView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/23/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    var mainView: UIView = {
        let v = UIView()
        v.backgroundColor = .tableViewCellGray
        v.layer.cornerRadius = 30
        v.layer.shadowRadius = 3
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowOpacity = 0.16
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var subView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondaryColor
        v.layer.cornerRadius = 14
        v.layer.shadowRadius = 2
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowOpacity = 0.16
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var roleLabel = UIElementsManager.createHeaderLabel(with: "Role: ", fontSize: 20)
    var locationLabel = UIElementsManager.createGenericLabel(with: "Location: ", fontSize: 17)
    
    var subViewLabel = UIElementsManager.createHeaderLabel(with: "Hide", fontSize: 16, color: .white)
    
    //bool propety
    @IBInspectable var isShown: Bool = true {
        didSet{
            self.resetConstraints(isShown: isShown)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        setupView()
    }
    
    func animate() {
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        isShown.toggle()
    }
    
    private func setupView() {
        addSubviews(mainView, subView)
        mainView.addSubviews(roleLabel, locationLabel)
        subView.addSubview(subViewLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        var shownConstraints = [
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 81),
            
            roleLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            roleLabel.bottomAnchor.constraint(equalTo: mainView.centerYAnchor),
            
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: mainView.centerYAnchor),
            
            subView.centerYAnchor.constraint(equalTo: mainView.bottomAnchor),
            subView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            subView.heightAnchor.constraint(equalToConstant: 29),
            subView.widthAnchor.constraint(equalToConstant: 120),
            
            subViewLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            subViewLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor)
            ]
        
//        var hiddenConstraints = [
//
//            ]
        NSLayoutConstraint.activate(shownConstraints)
    }
    
    private func resetConstraints(isShown: Bool) {
        if isShown {
//            NSLayoutConstraint.activate(shownConstraints)
//            NSLayoutConstraint.deactivate(hiddenConstraints)
            mainView.isHidden = false
            roleLabel.isHidden = false
            locationLabel.isHidden = false
        } else {
//            NSLayoutConstraint.activate(hiddenConstraints)
//            NSLayoutConstraint.deactivate(shownConstraints)
            mainView.isHidden = true
            roleLabel.isHidden = true
            locationLabel.isHidden = true
        }
    }
}
