//
//  ExpenseReceiptViewModel.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseReceiptViewModel {
    
    // MARK: - Init
    
    private let expense: Observable<Expense>
    private let expenseManager: ExpenseManager
    
    init(expense: Observable<Expense>, expenseManager: ExpenseManager) {
        self.expense = expense
        self.expenseManager = expenseManager
    }
}
