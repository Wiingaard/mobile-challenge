//
//  ExpenseDetailViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseDetailViewController: UIViewController {
    
    // MARK: - Init
    
    private let viewModel: ExpenseDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ExpenseDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .background
        
        setupSupviews()
        subscribeToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupSupviews() {
        
        view.addSubview(contentStackView)
        view.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: -16).isActive = true
        view.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: 16).isActive = true
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -16).isActive = true
        
        let expenseCardVc = ExpenseCardViewController.init(viewModel: viewModel.expenseCardViewModel)
        displayContent(viewController: expenseCardVc, in: cardExpenseContainerView)
        
        let expenseCommentVc = ExpenseCommentViewController.init(viewModel: viewModel.expenseCommentViewModel)
        displayContent(viewController: expenseCommentVc, in: cardCommentContainerView)
        
        let expenseReceiptVc = ExpenseReceiptViewController.init(viewModel: viewModel.expenseReceiptViewModel)
        displayContent(viewController: expenseReceiptVc, in: cardReceiptContainerView)
        
    }
    
    private func subscribeToViewModel() {
        viewModel.loadingExpense
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: - View hierarchy
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var contentStackView = UIStackView.make([cardExpenseContainerView, cardCommentContainerView, cardReceiptContainerView], spacing: 24)
    
    private let cardExpenseContainerView = UIView.make()
    private let cardCommentContainerView = UIView.make()
    private let cardReceiptContainerView = UIView.make()
    
}
