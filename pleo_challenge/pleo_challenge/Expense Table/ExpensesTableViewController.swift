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
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(tableView)
        view.pinEdges(to: tableView)
        
        let expenseCellNib = UINib(nibName: ExpenseTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(expenseCellNib, forCellReuseIdentifier: ExpenseTableViewCell.reuseIdentifier)
                
        viewModel.expenses.asObservable()
            .bind(to: tableView.rx.items(
                cellIdentifier: ExpenseTableViewCell.reuseIdentifier,
                cellType: ExpenseTableViewCell.self)) { (row, element, cell) in
                    cell.setup(with: element)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Hierarchy
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        return tableView
    }()
    
}
