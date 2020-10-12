//
//  UIView+Extension.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit

extension UIView {
    func makeCorners(radius: CGFloat = 24) {
        layer.cornerRadius = radius
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1
        animation.values = [-20.0, 20.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
