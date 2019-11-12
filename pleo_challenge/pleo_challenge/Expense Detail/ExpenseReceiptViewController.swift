//
//  ExpenseReceiptViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseReceiptViewController: UIViewController {
    
    // MARK: - Init
    
    private let viewModel: ExpenseReceiptViewModel
    private let disposeBag = DisposeBag()
    
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
    
    private let presenter = PublishSubject<UIViewController>()
    
    lazy var imageHelper = ImageHelper(presenter: presenter)
    
    private func subscribeToViewModel() {
        presenter
            .subscribe(onNext: { [weak self] in
                self?.present($0, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        photoButton.rx.tap
            .flatMap { [weak self] in
                self?.imageHelper.getImage() ?? .empty()
        }
        .subscribe(onNext: { image in
            print(image)
        })
            .disposed(by: disposeBag)
    }
    
    // MARK: - View hierarchy
    
    private lazy var mainStackView = UIStackView.make([titleLabel, UIView.make(height: 60, color: .systemRed), photoButton], spacing: 16)
    
    private lazy var titleLabel = UILabel.make(Font.title, text: "Receipt")
    private lazy var photoButton = RoundFlatButton.make(title: "Add image", color: .pleoBlue)
    
}
