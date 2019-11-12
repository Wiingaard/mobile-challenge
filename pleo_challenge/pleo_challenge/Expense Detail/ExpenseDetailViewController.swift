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
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        setupSupviews()
        subscribeToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupSupviews() {
        view.addSubview(nameLabel)
        view.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        view.addSubview(activityIndicatorView)
        view.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor).isActive = true
        
    }
    
    private func subscribeToViewModel() {
        viewModel.loadingExpense
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.userName
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - View hierarchy
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
}
