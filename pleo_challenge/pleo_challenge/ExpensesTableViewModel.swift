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
    private let disposeBag = DisposeBag()
    
    init(expenseManager: ExpenseManager) {
        self.expenseManager = expenseManager
        
        didScrollToBottom
            .subscribe(onNext: { [weak self] in self?.expenseManager.loadNextPage() })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Inputs
    
    let didScrollToBottom = PublishSubject<Void>()
    
    // MARK: - Expense
    
    lazy var expenses = expenseManager.expenses
    
    lazy var backgroundColor: UIColor = .systemGreen
    
}
