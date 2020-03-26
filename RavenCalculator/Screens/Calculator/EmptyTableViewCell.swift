//
//  EmptyTableViewCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-14.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class EmptyTableViewCell:UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(hex: "161617")
        self.separatorInset = .zero
        self.selectionStyle = .none
        
    }
    
}
