//
//  ExpenseCommentViewController.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExpenseCommentViewController: UIViewController {
    
    // MARK: - Init
    
    private let viewModel: ExpenseCommentViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ExpenseCommentViewModel) {
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
        
        view.addSubview(textViewPlaceholderLabel)
        textViewPlaceholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        textViewPlaceholderLabel.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
    }
    
    private func subscribeToViewModel() {
        viewModel.isPlaceholderHidden.drive(textViewPlaceholderLabel.rx.isHidden).disposed(by: disposeBag)
        viewModel.commentText.drive(textView.rx.text).disposed(by: disposeBag)
        viewModel.isSaveButtonEnabled.drive(saveButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.presentAlert
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.present($0, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        viewModel.didFinishEditingComment
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(false)
            }).disposed(by: disposeBag)
        
        // Input to View Model
        textView.rx.text.bind(to: viewModel.textDidChange).disposed(by: disposeBag)
        saveButton.rx.tap.bind(to: viewModel.savePressed).disposed(by: disposeBag)
    }
    
    // MARK: - View hierarchy
    
    private lazy var mainStackView = UIStackView.make([titleLabel, textView, saveButtonContainer], spacing: 16)
    private lazy var titleLabel = UILabel.make(Font.title, text: "Comment")
    private lazy var saveButton = RoundFlatButton.make(title: "Save", color: .pleoGreen)
    
    /// This view is needed to be able to freely place `saveButton` inside `mainStackView`
    private lazy var saveButtonContainer: UIView = {
        let view = UIView.make()
        view.addSubview(saveButton)
        view.topAnchor.constraint(equalTo: saveButton.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor).isActive = true
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView.init()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        textView.isScrollEnabled = false
        textView.font = Font.body
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private lazy var textViewPlaceholderLabel = UILabel.make(Font.bodyPlaceholder, textColor: Font.Color.placeholder, text: "Type a comment here")
}