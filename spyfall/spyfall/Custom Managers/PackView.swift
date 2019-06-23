//
//  PackView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/22/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class PackView: UIView {
    
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
    
    //bool propety
    @IBInspectable var isChecked:Bool = false {
        didSet{
            self.animate()
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
        isChecked.toggle()
    }
    
    private func setupView() {
        addSubview(boundsLayerView)
        boundsLayerView.addSubviews(whiteView, numberLabel, packNameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            boundsLayerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            boundsLayerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            boundsLayerView.topAnchor.constraint(equalTo: topAnchor),
            boundsLayerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
