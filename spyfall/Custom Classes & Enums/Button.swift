//
//  Button.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/4/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

//final such that swift compiler doesnt use dynamic dispatch, performance increase
final class Button: UIButton {
    var touchUpInside: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleAction() {
        touchUpInside?()
    }
}
