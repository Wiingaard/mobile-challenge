//
//  ExpenseManger.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ExpenseManager {
    
    // MARK: - Init
    
    private var load = BehaviorRelay<PageParameters>.init(value: .first)
    private var loadingPage = false
    private static let pageSize = 25
    private var maximumLoadedExpenseIndex: Int = 0
    
    private let networking = Networking()
    
    // MARK: - Get Expenses
    
    lazy var expenses: Driver<[Expense]> = {
        return load
            .flatMapLatest(getExpensesPage)
            .scan([], accumulator: +)
            .flatMapLatest(syncWithExpenseUpdate)
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    private lazy var getExpensesPage: (PageParameters) -> Observable<[Expense]> = { [weak self] params -> Observable<[Expense]> in
        guard let network = self?.networking else { return .empty() }
        return network
            .getExpenses(limit: params.limit, offset: params.offset)
            .do(onSuccess: {
                if $0.isEmpty {
                    self?.noResultsAt = Date()
                } else {
                    self?.noResultsAt = nil
                }
            })
            .do(onSuccess: {
                let maxIndex = $0.compactMap { $0.index }.max() ?? self?.maximumLoadedExpenseIndex
                guard let max = maxIndex else { return }
                self?.maximumLoadedExpenseIndex = max
            })
            .asObservable()
            .do(onNext: { _ in self?.loadingPage = false },
                onSubscribe: { self?.loadingPage = true }
        )
    }
    
    func getExpense(id: String) -> Observable<Expense?> {
        return expenses
            .map { $0.first { expense in expense.id == id } }
            .asObservable()
            .flatMapLatest { [weak self] expense -> Observable<Expense?> in
                if let expense = expense {
                    return .just(expense)
                } else {
                    return self?.networking.getExpense(id: id)
                        .asObservable()
                        .map(Optional.init)
                        ?? .just(nil)
                }
        }
    }
    
    // MARK: - Determind next page
    
    func loadNextPageIfReady() {
        guard !loadingPage else { return }
        guard ignoreIfNoResultsFoundRecently() else { return }
        
        let nextPage = PageParameters.init(offset: maximumLoadedExpenseIndex + 1, limit: ExpenseManager.pageSize)
        load.accept(nextPage)
    }
    
    private struct PageParameters {
        let offset: Int
        let limit: Int
        
        static let first = PageParameters(offset: 0, limit: ExpenseManager.pageSize)
    }
    
    private lazy var noResultsAt: Date? = nil
    
    private lazy var ignoreIfNoResultsFoundRecently: () -> Bool = { [weak self] () -> Bool in
        guard let foundNoResultsAt = self?.noResultsAt else { return true }
        let ignoreIf = foundNoResultsAt.timeIntervalSinceNow < -5
        return ignoreIf
    }
    
    // MARK: - Update Expense
    
    func updateExpenseComment(id: String, comment: String) -> Single<Expense> {
        networking
            .postExpenseComment(id: id, comment: comment)
            .do(onSuccess: { [weak self] in self?.didUpdateExpense.onNext($0) })
    }
    
    private let didUpdateExpense = PublishSubject<Expense>()
    
    lazy var syncWithExpenseUpdate: ([Expense]) -> Observable<[Expense]> = { [weak self] expenses -> Observable<[Expense]> in
        let passthrough = Observable.just(expenses)
        
        let expenseUpdate = self?.didUpdateExpense.map { updatedExpense -> [Expense] in
            expenses.map { $0.id == updatedExpense.id ? updatedExpense : $0 }
        } ?? .empty()
        
        return Observable.merge(passthrough, expenseUpdate)
    }
}
