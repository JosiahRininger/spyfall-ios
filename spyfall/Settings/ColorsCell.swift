//
//  ColorsCell.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/2/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import Lottie

class ColorsCell: UICollectionViewCell {
    
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.addShadowWith(radius: 3, offset: CGSize(width: 0, height: 3), opacity: 0.16)
        view.layer.masksToBounds = false
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var label = UIElementsManager.createLabel(with: "", fontSize: 18, color: .textGray)
    
    var checkAnimationView: AnimationView = {
        let av = AnimationView(name: "check_animation")
        av.animationSpeed = 2.0
        av.tintColor = .secondaryColor
        av.translatesAutoresizingMaskIntoConstraints = false
        
        return av
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
    @IBInspectable var isChecked: Bool = false {
        didSet {
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
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        backgroundColor = .primaryWhite
        
        addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(label)
        setupConstraints()
    }
    
    func configure(color: UIColor, label: String = "") {
        cellBackgroundView.backgroundColor = color
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            cellBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            cellBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            transparentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transparentView.topAnchor.constraint(equalTo: topAnchor),
            transparentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkAnimationView.topAnchor.constraint(equalTo: topAnchor),
            checkAnimationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
    
}
