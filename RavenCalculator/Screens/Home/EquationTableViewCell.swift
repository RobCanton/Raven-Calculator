//
//  EquationTableViewCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-12.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class EquationTableViewCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var equationLabel:UILabel!
    var evaluationLabel:UILabel!
    var tagsView:TagsView!
    var stackView:UIStackView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        stackView = UIStackView()
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: true)
        stackView.spacing = 10
        
        titleLabel = UILabel()
        stackView.addArrangedSubview(titleLabel)
        titleLabel.text = "mediumrisk"
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .light)
        titleLabel.textColor = UIColor.secondaryLabel
        
       
        
        evaluationLabel = UILabel()
        //stackView.addArrangedSubview(evaluationLabel)
        evaluationLabel.text = "317.85"
        evaluationLabel.font = UIFont.monospacedSystemFont(ofSize: 26, weight: .bold)
        evaluationLabel.textColor = UIColor.label
        evaluationLabel.numberOfLines = 0
        evaluationLabel.textAlignment = .left
        
        equationLabel = UILabel()
        stackView.addArrangedSubview(equationLabel)
        equationLabel.text = "NFLX:volume * 25 + 9.99"
        equationLabel.font = UIFont.monospacedSystemFont(ofSize: 16.0, weight: .regular)
        equationLabel.numberOfLines = 2
        
        tagsView = TagsView()
        tagsView.isUserInteractionEnabled = false
        
    }
    
    func setItem(_ item:Item) {
        
        
        
        let equation = item.equation
        let attributedText = NSMutableAttributedString()
        for component in equation.components {
            attributedText.append(NSAttributedString(string: component.string,
                                                     attributes: component.type.lightStyleAttributes))
        }
        equationLabel.attributedText = attributedText
        
        if let evaluation = item.evaluation {
            evaluationLabel.text = "\(evaluation.result)"
            stackView.insertArrangedSubview(evaluationLabel, at: 0)
        } else {
            evaluationLabel.removeFromSuperview()
        }
        
        if let name = item.details.name, !name.isEmpty {
            titleLabel.text = name
            stackView.insertArrangedSubview(titleLabel, at: 0)
        } else {
            titleLabel.removeFromSuperview()
        }
        
        
        if item.details.tags.count > 0 {
            tagsView.setTags(item.details.tags)
            stackView.addArrangedSubview(tagsView)
        } else {
            tagsView.removeFromSuperview()
        }
    }
    
    
    
    
}
