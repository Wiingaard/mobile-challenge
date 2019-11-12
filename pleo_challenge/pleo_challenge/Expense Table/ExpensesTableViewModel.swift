//
//  ExpensesTableViewModel.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpensesTableViewModel {
    
    // MARK: - Init
    
    private let expenseManager: ExpenseManager
    
    init(expenseManager: ExpenseManager) {
        self.expenseManager = expenseManager
    }
    
    // MARK: - Inputs
    
    func didScrollCloseToBottom(_ isClose: Bool) {
        guard isClose else { return }
        expenseManager.loadNextPageIfReady()
    }
    
    // MARK: - Output
    
    let title = "Expenses"
    
    lazy var expenses = {
        expenseManager.expenses
            .do(onNext: { [weak self] _ in self?._loadingExpenses.onNext(false) })
    }()
    
    lazy var _loadingExpenses = BehaviorSubject<Bool>.init(value: true)
    lazy var showLoadingIndicator: Driver<Bool> = _loadingExpenses.distinctUntilChanged().asDriver(onErrorDriveWith: .empty())
    
}
