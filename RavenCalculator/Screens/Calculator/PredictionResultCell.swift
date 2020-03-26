//
//  PredictionResultCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-02.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class PredictionResultCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(hex: "1D1D1E")
        
        titleLabel = UILabel()
        titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .medium)//.systemFont(ofSize: 18.0, weight: .medium)
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(nil, 16, nil, nil, ignoreSafeArea: true)
        titleLabel.constraintToCenter(axis: [.y])
        
        subtitleLabel = UILabel()
        subtitleLabel.font = .monospacedSystemFont(ofSize: 12, weight: .regular)//.systemFont(ofSize: 12.0, weight: .regular)
        subtitleLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        subtitleLabel.textAlignment = .left
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selected {
//            contentView.backgroundColor = UIColor.secondarySystemFill
//        } else {
//            contentView.backgroundColor = UIColor.secondarySystemGroupedBackground
//        }
//    }
//
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        if highlighted {
//            contentView.backgroundColor = UIColor.secondarySystemFill
//        } else {
//            contentView.backgroundColor = UIColor.secondarySystemGroupedBackground
//
//        }
//    }
}
