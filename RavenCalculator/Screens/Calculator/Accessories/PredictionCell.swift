//
//  PredictionCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit


class PredictionCell:UICollectionViewCell {
    
    var stackView:UIStackView!
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    var containerView:UIView!
    var blurView:UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        containerView = UIView()
        addSubview(containerView)
        containerView.constraintToSuperview(5, 5, 5, 5, ignoreSafeArea: true)
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        containerView.addSubview(blurView)
        blurView.constraintToSuperview()
        blurView.isHidden = true
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        containerView.addSubview(stackView)
        stackView.constraintToSuperview(5, 5, 5, 5, ignoreSafeArea: true)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        subtitleLabel.textAlignment = .center
        stackView.addArrangedSubview(subtitleLabel)
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                blurView.isHidden = false
            } else {
                blurView.isHidden = true
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                blurView.isHidden = false
            } else {
                blurView.isHidden = true
            }
        }
    }
    
    
}

class DividerCell:UICollectionViewCell {
    var divider:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        divider = UIView()
        addSubview(divider)
        divider.constraintToCenter(axis: [.x, .y])
        divider.constraintHeight(to: 26)
        divider.constraintWidth(to: 1)
        divider.backgroundColor = UIColor.label.withAlphaComponent(0.12)
        divider.layer.cornerRadius = 1/2
        divider.clipsToBounds = true
    }
}
