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
    private let presenter = PublishSubject<UIViewController>()
    private let disposeBag = DisposeBag()
    private lazy var imageHelper = ImageHelper(presenter: presenter)
    
    init(expense: Observable<Expense>, expenseManager: ExpenseManager) {
        self.expense = expense
        self.expenseManager = expenseManager
        
        addPhotoPressed
            .flatMap(getImage)
            .withLatestFrom(expense) { ($0, $1) }
            .flatMap(updateExpense)
            .subscribe(onNext: { [weak self] _ in self?.presentAlert(title: "Saved", message: "The image was saved") },
                       onError: { [weak self] _ in self?.presentAlert(title: "Error", message: "An error happend while saving the image. Please try again.") })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    
    let addPhotoPressed = PublishSubject<Void>()
    
    // MARK: - Output
    
    lazy var presentViewController = presenter.asObservable()
    
    lazy var receiptImages: Driver<[String]> = {
        return expense
            .map { $0.receipts }
            .map { $0.map { $0.url.replacingOccurrences(of: "/receipts/", with: "") } }
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    // MARK: - Image
    
    private lazy var getImage: () -> Observable<UIImage> = { [weak self] in
        return self?.imageHelper.getImage()
            ?? .empty()
    }
    
    private lazy var updateExpense: (UIImage, Expense) -> Observable<Expense> = { [weak self] (image, expense) -> Observable<Expense>  in
        return self?.expenseManager.updateExpenseReceiptImage(id: expense.id, image: image)
            .asObservable()
            ?? .empty()
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        presenter.onNext(alert)
    }
    
}
