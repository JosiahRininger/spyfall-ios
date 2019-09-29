//
//  UserInfoView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/23/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    var shownConstraints = [NSLayoutConstraint]()
    var hiddenConstraints = [NSLayoutConstraint]()
    
    var mainView: UIView = {
        let v = UIView()
        v.backgroundColor = .cellBackground
        v.layer.cornerRadius = 30
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var subView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondaryColor
        v.layer.cornerRadius = 18
        v.addShadowWith(radius: 2, offset: CGSize(width: 0, height: 2), opacity: 0.16)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var roleLabel = UIElementsManager.createLabel(with: "Role: ", fontSize: 24, textAlignment: .center, isHeader: true)
    var locationLabel = UIElementsManager.createLabel(with: "Location: ", fontSize: 17)
    var subViewLabel = UIElementsManager.createLabel(with: "Hide", fontSize: 18, color: .hexToColor(hexString: "#FCFCFC"), textAlignment: .center, isHeader: true)
    
    //bool propety
    @IBInspectable var isShown: Bool = true {
        didSet {
            subViewLabel.text = self.isShown ? "Hide" : "Show"
            self.resetConstraints(isShown: isShown)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        setupView()
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
        shownConstraints = [
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 81),
            
            roleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            roleLabel.bottomAnchor.constraint(equalTo: mainView.centerYAnchor),
            
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: mainView.centerYAnchor),
            
            subView.centerYAnchor.constraint(equalTo: mainView.bottomAnchor),
            subView.centerXAnchor.constraint(equalTo: centerXAnchor),
            subView.heightAnchor.constraint(equalToConstant: 36),
            subView.widthAnchor.constraint(equalToConstant: 120),
            
            subViewLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            subViewLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor)
        ]
        
        hiddenConstraints = [
            subView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            subView.centerXAnchor.constraint(equalTo: centerXAnchor),
            subView.heightAnchor.constraint(equalToConstant: 36),
            subView.widthAnchor.constraint(equalToConstant: 120),
            
            subViewLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            subViewLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(shownConstraints)
        
    }
    
    private func resetConstraints(isShown: Bool) {
        if isShown {
            self.mainView.isHidden = false
            self.roleLabel.isHidden = false
            self.locationLabel.isHidden = false
            UIView.animate(withDuration: 0.15, animations: {
                self.subView.center.y += 63
            })
            UIView.transition(with: mainView, duration: 0.15,
                              options: [.curveEaseOut, .showHideTransitionViews],
                              animations: {
                                self.mainView.alpha = 1
                                self.roleLabel.alpha = 1
                                self.locationLabel.alpha = 1
                                NSLayoutConstraint.deactivate(self.hiddenConstraints)
                                NSLayoutConstraint.activate(self.shownConstraints)
            })
            setNeedsUpdateConstraints()
            layoutIfNeeded()
        } else {
            roleLabel.alpha = 0
            locationLabel.alpha = 0
            NSLayoutConstraint.activate(self.hiddenConstraints)
            UIView.animate(withDuration: 0.15, animations: {
                    self.subView.center.y -= 63
            })
            UIView.transition(with: mainView, duration: 0.15,
                              options: [.curveEaseOut, .showHideTransitionViews],
                              animations: {
                                self.mainView.alpha = 0
            },
                              completion: { _ in
                                self.mainView.isHidden = true
                                self.roleLabel.isHidden = true
                                self.locationLabel.isHidden = true
                                NSLayoutConstraint.deactivate(self.shownConstraints)
            })
            setNeedsUpdateConstraints()
            layoutIfNeeded()
        }
    }
}
