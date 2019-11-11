//
//  ExpensesTableViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

class ExpensesTableViewController: UIViewController {
    
    // MARK: - Init
    
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
        view.backgroundColor = viewModel.backgroundColor
    }
    
    // MARK: - View Hierarchy
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
}
