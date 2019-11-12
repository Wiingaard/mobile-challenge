//
//  ExpenseCardViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseCardViewController: UIViewController {
    
    // MARK: - Init
    
    private let viewModel: ExpenseCardViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ExpenseCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .background
        view.applyCardStyle(.default)
        
        setupSupviews()
        subscribeToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupSupviews() {
        view.addSubview(mainStackView)
        view.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: -24).isActive = true
        view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 16).isActive = true
        view.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 24).isActive = true
    }
    
    private func subscribeToViewModel() {
        viewModel.amountText.drive(amountLabel.rx.text).disposed(by: disposeBag)
        viewModel.nameText.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.dateText.drive(dateLabel.rx.text).disposed(by: disposeBag)
    }
    
    // MARK: - View hierarchy
    
    private lazy var mainStackView = UIStackView.make([titleLabel, contentStackView], spacing: 16)
    private lazy var contentStackView = UIStackView.make([nameAmountStackView, dateLabel], spacing: 8)
    private lazy var nameAmountStackView = UIStackView.make([nameLabel, amountLabel], axis: .horizontal)
    
    private lazy var titleLabel = UILabel.make(Font.title, text: "Expense")
    private lazy var nameLabel = UILabel.make(Font.body, horizontalHugging: true)
    private lazy var amountLabel = UILabel.make(Font.body)
    private lazy var dateLabel = UILabel.make(Font.bodySmall)
}
