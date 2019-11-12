//
//  Expense.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import Foundation

struct Expense: Codable {
    let id: String
    let amount: Amount
    let date: Date
    let merchant: String
    let receipts: [Receipt]
    let comment: String
    let category: String
    let user: User
    let index: Int?
}
