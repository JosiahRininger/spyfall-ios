//
//  PackView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/22/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import Lottie

class PackView: UIView {
    
    var checkAnimationView: AnimationView = {
        let av = AnimationView(name: "check_animation")
        av.animationSpeed = 2.0
        av.tintColor = .secondaryColor
        av.translatesAutoresizingMaskIntoConstraints = false
        
        return av
    }()
    
    var boundsLayerView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 9
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
       
        return v
    }()

    var numberLabel: UILabel = {
        let l = UILabel()
        l.textColor = .primaryWhite
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: 49)
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    var whiteView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var packNameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.numberOfLines = 2
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    var transparentView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0.5
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    //bool propety
    @IBInspectable var isChecked:Bool = false {
        didSet{
            if self.isChecked {
                checkAnimationView.isHidden = false
                checkAnimationView.play()
                transparentView.isHidden = false
            } else {
                checkAnimationView.isHidden = true
                checkAnimationView.stop()
                transparentView.isHidden = true
            }
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
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        isChecked.toggle()
    }
    
    private func setupView() {
        addSubview(boundsLayerView)
        boundsLayerView.addSubviews(whiteView, numberLabel, packNameLabel, transparentView, checkAnimationView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            boundsLayerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            boundsLayerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            boundsLayerView.topAnchor.constraint(equalTo: topAnchor),
            boundsLayerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            transparentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transparentView.topAnchor.constraint(equalTo: topAnchor),
            transparentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkAnimationView.topAnchor.constraint(equalTo: topAnchor),
            checkAnimationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            whiteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            whiteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: UIElementSizes.packViewHeight * 0.36),
            
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            numberLabel.bottomAnchor.constraint(equalTo: whiteView.topAnchor, constant: -10),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            packNameLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 2),
            packNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            packNameLabel.widthAnchor.constraint(equalTo: widthAnchor)
            
            ])
    }
    
}
