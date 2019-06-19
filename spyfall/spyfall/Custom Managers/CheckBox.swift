//
//  CheckBox.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/15/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "Checked_Box")
    let unCheckedImage = UIImage(named: "Unchecked_Box")
    
    //bool propety
    @IBInspectable var isChecked:Bool = false{
        didSet{
            self.updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: UIControl.Event.touchUpInside)
        self.updateImage()    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: UIControl.Event.touchUpInside)
        self.updateImage()    }

    
    func updateImage() {
        if isChecked == true{
            self.setImage(checkedImage, for: [])
        }else{
            self.setImage(unCheckedImage, for: [])
        }
        
    }
    
    @objc func buttonClicked(sender:UIButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }
    
}
