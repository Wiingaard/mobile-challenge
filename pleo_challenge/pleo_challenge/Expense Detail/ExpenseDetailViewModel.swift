//
//  ExpenseDetailViewModel.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ExpenseDetailViewModel {
    
    // MARK: - Init
    private let initialExpense: Expense?
    private let expenseId: String
    private let expenseManager: ExpenseManager
    
    /// Start with a concrete expense. It's continously kept fresh by the expense manager.
    init(expense: Expense, expenseManager: ExpenseManager) {
        self.initialExpense = expense
        self.expenseId = expense.id
        self.expenseManager = expenseManager
    }
    
    /// Initialize without a concrete expense at hand. This could be handy for deep linking from a notification
    init(expenseId: String, expenseManager: ExpenseManager) {
        self.initialExpense = nil
        self.expenseId = expenseId
        self.expenseManager = expenseManager
    }
    
    // MARK: - Expense
    
    private lazy var loadExpense: Observable<Expense?> = {
        let observableExpense: Observable<Expense?>
        if let preloadedExpense = initialExpense {
            observableExpense = expenseManager.getExpense(id: expenseId).startWith(preloadedExpense)
        } else {
            observableExpense = expenseManager.getExpense(id: expenseId)
        }
        return observableExpense
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)
    }()
    
    private lazy var expense: Observable<Expense> = {
        return loadExpense
            .do(onNext: { [weak self] _ in self?._loadingExpense.onNext(false) })
            .filter { $0 != nil }.map { $0! }
    }()
    
    private lazy var errorLoadingExpense: Observable<Void> = {
        return loadExpense
            .filter { $0 == nil }.map { _ in () }
    }()
    
    // MARK: - Outputs
    
    private let _loadingExpense = BehaviorSubject<Bool>.init(value: true)
    lazy var loadingExpense = _loadingExpense.asDriver(onErrorDriveWith: .empty())
    
    lazy var expenseCardViewModel = ExpenseCardViewModel.init(expense: expense)
    lazy var expenseCommentViewModel = ExpenseCommentViewModel.init(expense: expense, expenseManager: expenseManager)
    
}
