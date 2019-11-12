//
//  UIView+Extension.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Adds constraints to all four edge anchors
    @discardableResult
    func pinEdges(to subview: UIView) -> [NSLayoutConstraint] {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let leading = leadingAnchor.constraint(equalTo: subview.leadingAnchor)
        let top = topAnchor.constraint(equalTo: subview.topAnchor)
        let trailing = trailingAnchor.constraint(equalTo: subview.trailingAnchor)
        let bottom = bottomAnchor.constraint(equalTo: subview.bottomAnchor)
        let constraints = [leading, top, trailing, bottom]
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
    static func make(height: CGFloat? = nil, width: CGFloat? = nil, color: UIColor = .clear) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        if let width = width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return view
    }
    
}
