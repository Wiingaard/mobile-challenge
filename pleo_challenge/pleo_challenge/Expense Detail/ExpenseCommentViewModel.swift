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
    private let disposeBag = DisposeBag()
    private let _presentAlert = PublishSubject<UIAlertController>()
    private lazy var _didFinishEditingComment = PublishSubject<Void>()
    
    init(expense: Observable<Expense>, expenseManager: ExpenseManager) {
        self.expense = expense
        self.expenseManager = expenseManager
        
        let commentAndExpense = Observable.combineLatest(textDidChange, expense)
        
        savePressed
            .withLatestFrom(commentAndExpense)
            .flatMapLatest(updateComment)
            .subscribe(onNext: { [weak self] _ in self?.presentAlert(title: "Saved", message: "The comment was saved") },
                       onError: { [weak self] _ in self?.presentAlert(title: "Error", message: "An error happend while saving the comment. Please try again.") })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    
    let textDidChange = PublishSubject<String?>()
    
    let savePressed = PublishSubject<Void>()
    
    // MARK: - Output
    
    lazy var commentText: Driver<String> = {
        return expense.map { $0.comment }.asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var isPlaceholderHidden: Driver<Bool> = {
        return textDidChange.map { $0?.isEmpty ?? true }.map(!).asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var isSaveButtonEnabled: Driver<Bool> = {
        return textDidChange
            .map { $0?.isEmpty ?? true }
            .map(!)
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var presentAlert = _presentAlert.asObservable()
    
    lazy var didFinishEditingComment = _didFinishEditingComment.asObservable()
    
    // MARK: - Update comment
    
    private lazy var updateComment: (String?, Expense) -> Observable<Void> = { [weak self] (comment, expense) -> Observable<Void> in
        guard let manager = self?.expenseManager,
            let comment = comment
            else { return .empty() }
        
        return manager.updateExpenseComment(id: expense.id, comment: comment)
            .do(onSuccess: { [weak self] _ in self?._didFinishEditingComment.onNext(()) })
            .asObservable()
            .map { _ in () }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        _presentAlert.onNext(alert)
    }
    
}
