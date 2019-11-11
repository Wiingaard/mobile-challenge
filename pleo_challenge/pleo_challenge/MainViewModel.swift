//
//  MainViewModel.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

class MainViewModel {
    
    func initialViewController() -> UIViewController {
        makeExpensesTableViewController()
    }
    
    func makeExpensesTableViewController() -> UIViewController {
        let vm = ExpensesTableViewModel()
        let vc = ExpensesTableViewController.init(viewModel: vm)
        return vc.inNavigationController()
    }
    
}
