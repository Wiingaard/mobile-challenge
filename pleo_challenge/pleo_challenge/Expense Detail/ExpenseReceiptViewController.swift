//
//  ExpenseReceiptViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

class ExpenseReceiptViewController: UIViewController {
    
    // MARK: - Init
    
    private let viewModel: ExpenseReceiptViewModel
    
    init(viewModel: ExpenseReceiptViewModel) {
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
        
    }
    
    // MARK: - View hierarchy
    
    private lazy var mainStackView = UIStackView.make([titleLabel, UIView.make(height: 60, color: .systemRed), photoButton], spacing: 16)
    
    private lazy var titleLabel = UILabel.make(Font.title, text: "Receipt")
    private lazy var photoButton = RoundFlatButton.make(title: "Take Photo", color: .pleoBlue)
    
}
