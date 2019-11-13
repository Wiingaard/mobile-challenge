//
//  ExpensesTableViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpensesTableViewController: UIViewController {
    
    // MARK: - Init
    
    private let disposeBag = DisposeBag()
    private let viewModel: ExpensesTableViewModel
    private var readyToMeassureDistanceToBottom = false
    private let closeToBottomThreathold = 500
    
    init(viewModel: ExpensesTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        
        view.backgroundColor = .background
        
        setupSupviews()
        subscribeToViewModel()
    }
    
    // MARK: - Setup
    
    private func setupSupviews() {
        // Tableview
        view.addSubview(tableView)
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        let expenseCellNib = UINib(nibName: ExpenseTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(expenseCellNib, forCellReuseIdentifier: ExpenseTableViewCell.reuseIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Loading indicator
        view.addSubview(activityIndicatorView)
        view.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor).isActive = true
        
        // Empty State
        view.addSubview(emptyStateContainer)
        view.pinEdges(to: emptyStateContainer)
    }
    
    private func subscribeToViewModel() {
        // Expenses
        viewModel.expenses
            .catchErrorJustReturn([])
            .bind(to: tableView.rx.items(
                cellIdentifier: ExpenseTableViewCell.reuseIdentifier,
                cellType: ExpenseTableViewCell.self)) { (row, element, cell) in
                    cell.setup(with: element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Expense.self)
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: viewModel.didSelectExpense)
            .disposed(by: disposeBag)
        
        // Loading indicator
        viewModel.showLoadingIndicator
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Empty State
        viewModel.showEmptyStateWithMessage
            .drive(onNext: { [weak self] emptyStateMessage in
                self?.emptyStateContainer.isHidden = emptyStateMessage == nil
                self?.emptyStateLabel.text = emptyStateMessage
            }).disposed(by: disposeBag)
        
        // Present Expense Detail
        viewModel.presentExpenseDetail
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = ExpenseDetailViewController.init(viewModel: $0)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Hierarchy
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        return tableView
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView.init(style: .gray)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        return activityView
    }()
    
    lazy var emptyStateLabel = UILabel.make(Font.bodyPlaceholder, textColor: Font.Color.placeholder)
    
    lazy var emptyStateContainer: UIView = {
        let view = UIView.make()
        view.addSubview(emptyStateLabel)
        view.leadingAnchor.constraint(equalTo: emptyStateLabel.leadingAnchor, constant: -16).isActive = true
        view.trailingAnchor.constraint(equalTo: emptyStateLabel.trailingAnchor, constant: 16).isActive = true
        view.centerYAnchor.constraint(equalTo: emptyStateLabel.centerYAnchor).isActive = true
        emptyStateLabel.textAlignment = .center
        return view
    }()
}

// MARK: - TableView Delegate

extension ExpensesTableViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard readyToMeassureDistanceToBottom else { return }
        
        let distanceToBottom = scrollView.contentSize.height - (scrollView.bounds.height + scrollView.contentOffset.y  - view.safeAreaInsets.bottom)
        let isCloseToBottom = Int(distanceToBottom) < closeToBottomThreathold
        viewModel.didScrollCloseToBottom(isCloseToBottom)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        readyToMeassureDistanceToBottom = true
    }
}
