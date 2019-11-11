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
    
    private var page = BehaviorRelay<Int>.init(value: 0)
    private static let pageSize = 10
    private let networking = Networking()
    
    lazy var expenses: Driver<[Expense]> = {
        return page
            .flatMapLatest(getExpensesPage)
            .scan([], accumulator: +)
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var getExpensesPage: (Int) -> Observable<[Expense]> = { [weak self] page -> Observable<[Expense]> in
        guard let network = self?.networking else { return .empty() }
        let params = ExpenseManager.pageParameters(page: page)
        return network.getExpenses(limit: params.limit, offset: params.offset).asObservable()
    }
    
    func loadNextPage() {
        page.accept(page.value + 1)
    }
    
    static func pageParameters(page: Int) -> (limit: Int, offset: Int) {
        return (limit: pageSize, offset: page * pageSize)
    }
    
}
