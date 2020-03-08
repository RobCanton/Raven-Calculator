//
//  OperationsAccessoryView.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

enum Operation {
    case multiply, divide, add, subtract, decimal, evaluate, keyboard
    
    var icon:UIImage? {
        switch self {
        case .multiply:
            return UIImage(systemName: "multiply")
        case .divide:
            return UIImage(systemName: "divide")
        case .add:
            return UIImage(systemName: "plus")
        case .subtract:
            return UIImage(systemName: "minus")
        case .decimal:
            return nil//UIImage(systemName: "")
        case .evaluate:
            return UIImage(systemName: "equal")
        case .keyboard:
            return UIImage(systemName: "keyboard")
        }
    }
    
    var textRepresentable:String {
        switch self {
        case .multiply:
            return "*"
        case .divide:
            return "/"
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .decimal:
            return "."
        case .evaluate:
            return "="
        case .keyboard:
            return ""
        }
    }
}

protocol OperationsAccessoryDelegate:class {
    func operationsAccessory(didSelect operation:Operation)
}

class OperationsAccessoryView:UIView {
    
    var contentView:UIView!
    var stackView:UIStackView!
    
    weak var delegate:OperationsAccessoryDelegate?
    
    let operations:[Operation] = [
        .multiply,
        .divide,
        .add,
        .subtract,
        .decimal,
        .keyboard
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        constraintHeight(to: 44)

        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.constraintToSuperview()
        
        for i in 0..<operations.count {
            let operation = operations[i]
            let button = UIButton(type: .custom)
            button.setImage(operation.icon, for: .normal)
            button.tintColor = UIColor.label
            button.tag = i
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        }
        
    
    }
    
    @objc func handleButton(_ button:UIButton) {
        delegate?.operationsAccessory(didSelect: operations[button.tag])
    }
}
