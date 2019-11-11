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
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(testButton)
        view.centerXAnchor.constraint(equalTo: testButton.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: testButton.centerYAnchor).isActive = true
        
        testButton.rx.tap
            .bind(to: viewModel.didScrollToBottom)
            .disposed(by: disposeBag)
        
        viewModel.expenses
            .do(onNext: { print("Expenses: \($0.count)") })
            .drive()
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Hierarchy
    
    lazy var testButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Test", for: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
}
