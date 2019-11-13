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
    
    private lazy var _loadingExpenses = BehaviorSubject<Bool>.init(value: true)
    private let expenseManager: ExpenseManager
    
    init(expenseManager: ExpenseManager) {
        self.expenseManager = expenseManager
    }
    
    // MARK: - Inputs
    
    func didScrollCloseToBottom(_ isClose: Bool) {
        guard isClose else { return }
        expenseManager.loadNextPageIfReady()
    }
    
    let didSelectExpense = PublishSubject<Expense>()
    
    let filterMode = BehaviorSubject<ExpensesTableViewController.FilterMode?>.init(value: .all)
    
    // MARK: - Output
    
    let title = "Expenses"
    
    lazy var expenses: Observable<[Expense]> = {
        expenseManager.expenses
            .flatMapLatest(updateWithFilter)
            .do(onNext: { [weak self] _ in self?._loadingExpenses.onNext(false) },
                onError: { [weak self] _ in self?._loadingExpenses.onNext(false) })
            .share(replay: 1, scope: .whileConnected)
    }()
    
    lazy var showLoadingIndicator: Driver<Bool> = _loadingExpenses.distinctUntilChanged().asDriver(onErrorDriveWith: .empty())
    
    lazy var presentExpenseDetail: Observable<ExpenseDetailViewModel> = {
        return didSelectExpense
            .flatMapLatest { [weak self] expense -> Observable<ExpenseDetailViewModel> in
                guard let expenseManager = self?.expenseManager else { return .empty() }
                return .just(ExpenseDetailViewModel(expense: expense, expenseManager: expenseManager))
        }
    }()
    
    lazy var showEmptyStateWithMessage: Driver<String?> = {
        let error = errorLoadingExpenses.map { _ in "Could not load expenses" }.map(Optional.init)
        let expenseResult = expenses.map { $0.isEmpty ? "Did not find any expenses" : nil }
        return Observable.merge(error, expenseResult)
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    // MARK: - Error
    
    private lazy var errorLoadingExpenses: Observable<Error> = {
        return self.expenses
            .materialize()
            .flatMapLatest { event -> Observable<Error> in
                switch event {
                case .error(let error): return .just(error)
                case .completed, .next: return .empty()
                }
        }
    }()
    
    // MARK: - Filter
    
    private lazy var updateWithFilter: ([Expense]) -> Observable<[Expense]> = { [weak self] expenses in
        guard let filter = self?.filterMode else { return .just(expenses) }
        return filter.flatMap { filter -> Observable<[Expense]> in
            let filteredExpenses = self?.filterExpenses(expenses, filter) ?? expenses
            return .just(filteredExpenses)
        }
    }
    
    private lazy var filterExpenses: ([Expense], ExpensesTableViewController.FilterMode?) -> [Expense] = { (expenses, filter)  in
        guard let filter = filter else { return expenses }
        return expenses.filter { expense -> Bool in
            switch filter {
            case .all: return true
            case .comment: return !expense.comment.isEmpty
            case .receipt: return !expense.receipts.isEmpty
            }
        }
    }
}
