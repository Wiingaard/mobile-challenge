//
//  UIStackView+Extension.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

extension UIStackView {
    
    static func make(_ subviews: [UIView] = [], axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0) -> UIStackView {
        let stack = UIStackView.init(arrangedSubviews: subviews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = spacing
        return stack
    }
    
}
