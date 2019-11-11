//
//  DateFormat.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import Foundation

class DateFormat {
    static func date(_ date: Date) -> String {
        let formatter = DateFormatter.init()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    static func time(_ date: Date) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
