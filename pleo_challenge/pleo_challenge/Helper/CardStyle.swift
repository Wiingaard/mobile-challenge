//
//  CardStyle.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

struct CardStyle {
    
    let cornerRadius: CGFloat
    let shadowColor: UIColor
    let shadowOffset: CGSize
    let shadowOpacity: Float
    let shadowRadius: CGFloat
    
    static let `default` = CardStyle.init(
        cornerRadius: 20,
        shadowColor: UIColor.black.withAlphaComponent(0.09),
        shadowOffset: CGSize(width: 0, height: 1),
        shadowOpacity: 1,
        shadowRadius: 4
    )
}

extension UIView {
    
    func applyCardStyle(_ style: CardStyle) {
        layer.cornerRadius = style.cornerRadius
        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowOpacity = style.shadowOpacity
        layer.shadowRadius = style.shadowRadius
    }

}
