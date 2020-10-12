//
//  UITextField+Extension.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit

extension UITextField {
    
    func baseSetup(placeholder: String) {
        makeCorners()
        makePaddings()
        self.placeholder = placeholder
        backgroundColor = .gray
    }
    
    func makePaddings() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 0))
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 0))
        leftViewMode = .always
        rightViewMode = .always
    }
}
