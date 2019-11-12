//
//  ExpenseCommentViewModel.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseCommentViewModel {
    
    // MARK: - Init
    
    private let expense: Observable<Expense>
    private let expenseManager: ExpenseManager
    
    init(expense: Observable<Expense>, expenseManager: ExpenseManager) {
        self.expense = expense
        self.expenseManager = expenseManager
    }
    
    // MARK: - Input
    
    let textDidChange = PublishSubject<String?>()
    
    // MARK: - Output
    
    lazy var commentText: Driver<String> = {
        return expense.map { $0.comment }.asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var isPlaceholderHidden: Driver<Bool> = {
        return textDidChange.map { $0?.isEmpty ?? true }.map(!).asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var isSaveButtonEnabled: Driver<Bool> = {
        let inputTextNotEmpty = textDidChange.map { $0?.isEmpty ?? true }.map(!).debug("Input")
        let initialTextNotEmpty = expense.map { $0.comment.isEmpty }.map(!).debug("Initial")
        return Observable.merge(inputTextNotEmpty, initialTextNotEmpty)
            .asDriver(onErrorDriveWith: .empty())
    }()
    
}
