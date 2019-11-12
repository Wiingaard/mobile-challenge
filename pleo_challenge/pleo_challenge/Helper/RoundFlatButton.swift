//
//  RoundFlatButton.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

public extension RoundFlatButton {
    
    static func make(title: String, color: UIColor) -> RoundFlatButton {
        let button = RoundFlatButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Font.button
        button.backgroundColor = color
        return button
    }
    
}

@IBDesignable
public class RoundFlatButton: UIButton {
    
    private let defaultContentEdgeIntest: UIEdgeInsets = .init(top: 8, left: 24, bottom: 8, right: 24)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentEdgeInsets = defaultContentEdgeIntest
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        applyLayer()
    }
    
    private func applyLayer() {
        layer.cornerRadius = bounds.height / 2
    }
    
    public override var isEnabled: Bool {
        didSet { setEnabled(isEnabled) }
    }
    
    private func setEnabled(_ enabled: Bool) {
        let alpha: CGFloat = enabled ? 1 : 0.34
        backgroundColor = backgroundColor?.withAlphaComponent(alpha)
    }
    
    public override func prepareForInterfaceBuilder() {
        applyLayer()
    }
}
