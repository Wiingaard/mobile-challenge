//
//  ExpenseTableViewCell.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.applyCardStyle(.default)
        selectionStyle = .none
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if #available(iOS 13.0, *) {
            cardView.backgroundColor = highlighted ? .groupTableViewBackground : .systemBackground
        } else {
            cardView.backgroundColor = highlighted ? .white : UIColor.init(white: 0.95, alpha: 1)
        }
    }
    
    func setup(with expense: Expense) {
        nameLabel.text = expense.user.first + " " + expense.user.last
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        amountLabel.text = expense.amount.value + " " + expense.amount.currency
        amountLabel.font = .systemFont(ofSize: 15, weight: .medium)
        dateLabel.text = DateFormat.date(expense.date)
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        circleView.backgroundColor = color(for: expense.amount.currency)
    }
    
    private func color(for currency: String) -> UIColor {
        switch currency {
        case "DKK": return .pleoGreen
        case "EUR": return .pleoOrange
        case "GBP": return .pleoBlue
        default: return .pleoRed
        }
    }
}
