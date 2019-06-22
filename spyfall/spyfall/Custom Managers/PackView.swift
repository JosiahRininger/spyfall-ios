//
//  PackView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/22/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class PackView: UIView {

    var numberLabel: UILabel = {
        let l = UILabel()
        l.textColor = .primaryWhite
        l.font = .boldSystemFont(ofSize: 49)
        
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
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PackView.tapped)))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PackView.tapped)))
        setupView()
    }
    
    override func init(packColor: UIColor, packNumberString: String, packName: String) {
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = packColor
    }
    
    
    func animate() {
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        if(sender == self){
            isChecked = !isChecked
        }
    }
    
}
