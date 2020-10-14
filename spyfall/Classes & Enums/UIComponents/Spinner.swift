//
//  Spinner.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/16/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class Spinner: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.style = .whiteLarge
        self.startAnimating()
        self.alpha = 0.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.alpha = 0.0
        self.center.x += 5.0
    }
    
    func animate(with button: Button) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.center = CGPoint(x: 40.0, y: button.frame.height / 2)
            self.alpha = 1.0
        })
    }
}
