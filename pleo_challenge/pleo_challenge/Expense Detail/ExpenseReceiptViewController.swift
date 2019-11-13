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
    
    private func subscribeToViewModel() {
        viewModel.presentViewController
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.present($0, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        viewModel.receiptImages
            .drive(onNext: { [weak self] receipts in
                self?.updateReceiptsStackContent(with: receipts)
            }).disposed(by: disposeBag)
        
        // Input to View Model
        photoButton.rx.tap.bind(to: viewModel.addPhotoPressed).disposed(by: disposeBag)
    }
    
    // MARK: - View hierarchy
    
    private lazy var mainStackView = UIStackView.make([titleLabel, receiptsStackView, photoButtonContainer], spacing: 16)
    
    private lazy var titleLabel = UILabel.make(Font.title, text: "Receipt")
    
    private lazy var receiptsStackView = UIStackView.make([], spacing: 4)
    
    private func updateReceiptsStackContent(with receipts: [String]) {
        receiptsStackView.subviews.forEach { $0.removeFromSuperview() }
        if receipts.isEmpty {
            receiptsStackView.addArrangedSubview(UILabel.make(Font.bodyPlaceholder, textColor: Font.Color.placeholder, text: "No receipts added"))
        } else {
            receipts.forEach { receipt in
                receiptsStackView.addArrangedSubview(UILabel.make(Font.body, text: receipt))
            }
        }
    }
    
    private lazy var photoButton = RoundFlatButton.make(title: "Add image", color: .pleoBlue)
    
    /// This view is needed to be able to freely place `saveButton` inside `mainStackView`
    private lazy var photoButtonContainer: UIView = {
        let view = UIView.make()
        view.addSubview(photoButton)
        view.topAnchor.constraint(equalTo: photoButton.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: photoButton.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: photoButton.leadingAnchor).isActive = true
        return view
    }()
    
}
