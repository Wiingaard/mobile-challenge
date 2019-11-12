//
//  ExpenseCardViewModel.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseCardViewModel {
    
    // MARK: - Init
    
    private let expense: Driver<Expense>
    
    init(expense: Observable<Expense>) {
        self.expense = expense.asDriver(onErrorDriveWith: .empty())
    }
    
    // MARK: - Outputs
    
    lazy var nameText: Driver<String> = {
        expense.map { $0.user.first + " " + $0.user.last }
    }()
    
    lazy var amountText: Driver<String> = {
        expense.map { $0.amount.value + " " + $0.amount.currency }
    }()
    
    lazy var dateText: Driver<String> = {
        expense.map { DateFormat.date($0.date) + " at " + DateFormat.time($0.date)  }
    }()
    
}
