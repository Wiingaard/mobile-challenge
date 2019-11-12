//
//  UILabel+Extension.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func make(_ font: UIFont, text: String? = nil, horizontalHugging: Bool? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = text
        if let isHugging = horizontalHugging {
            let priority = isHugging ? UILayoutPriority(248) : UILayoutPriority(252)
            label.setContentHuggingPriority(priority, for: .horizontal)
        }
        return label
    }
    
}
