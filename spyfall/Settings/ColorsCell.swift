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
        let v = UIView()
        v.layer.cornerRadius = 9
        v.backgroundColor = .secondaryBackgroundColor
        v.addShadowWith(radius: 3, offset: CGSize(width: 0, height: 3), opacity: 0.16)
        v.layer.masksToBounds = false
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var contentsLayer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 9
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var label = UIElementsManager.createLabel(with: "", fontSize: 12, numberOfLines: 2, color: .subText, textAlignment: .center)
    
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
    var isChecked: Bool = false {
        didSet {
            switch self.isChecked {
            case true:
                checkAnimationView.isHidden = false
                checkAnimationView.play()
                transparentView.isHidden = false
            case false:
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
        backgroundColor = .primaryBackgroundColor
        
        addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(contentsLayer)
        contentsLayer.addSubviews(label, transparentView, checkAnimationView)
        setupConstraints()
    }
    
    func configure(color: UIColor = .secondaryBackgroundColor, labelText: String = "") {
        cellBackgroundView.backgroundColor = color
        self.label.text = labelText
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            cellBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            cellBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            contentsLayer.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor),
            contentsLayer.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor),
            contentsLayer.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor),
            contentsLayer.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalTo: cellBackgroundView.widthAnchor),
            
            transparentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transparentView.topAnchor.constraint(equalTo: topAnchor),
            transparentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            checkAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            checkAnimationView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            checkAnimationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
    }
    
}
