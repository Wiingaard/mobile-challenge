//
//  Font.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

class Font {
    static let title = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let button = UIFont.systemFont(ofSize: 17, weight: .medium)
    static let body = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let bodyPlaceholder = UIFont.italicSystemFont(ofSize: 15)
    static let bodySmall = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    class Color {
        static let placeholder: UIColor = .gray
    }
}
