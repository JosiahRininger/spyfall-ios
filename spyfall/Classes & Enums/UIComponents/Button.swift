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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setTouchDownState()
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setTouchUpStateWithAnimation()
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.setTouchUpStateWithAnimation()
    }
    
    @objc func handleAction() {
        touchUpInside?()
    }
    
    func setTouchDownState() {
        let touchDownScale: CGFloat = AnimationPressViewProperty.touchDownScale.value
        UIView.animate(withDuration: TimeInterval(AnimationPressViewProperty.touchDownDuration.value),
                       delay: TimeInterval(AnimationPressViewProperty.delay.value),
                       usingSpringWithDamping: AnimationPressViewProperty.damping.value,
                       initialSpringVelocity: AnimationPressViewProperty.velocity.value,
                       options: .curveLinear,
                       animations: {
                        self.transform = self.transform.scaledBy(x: touchDownScale, y: touchDownScale)
                       })
    }
    
    func setTouchUpStateWithAnimation() {
        UIView.animate(withDuration: TimeInterval(AnimationPressViewProperty.touchDownDuration.value),
                       delay: TimeInterval(AnimationPressViewProperty.delay.value),
                       usingSpringWithDamping: AnimationPressViewProperty.damping.value,
                       initialSpringVelocity: AnimationPressViewProperty.velocity.value,
                       options: .curveEaseInOut,
                       animations: {
                        self.transform = .identity
                       })
    }
    
}
