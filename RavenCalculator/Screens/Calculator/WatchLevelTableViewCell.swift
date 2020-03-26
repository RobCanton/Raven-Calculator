//
//  WatchLevelTableViewCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-16.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit


class WatchLevelTableViewCell: UITableViewCell {
    var segmentedControl:UISegmentedControl!
    
    weak var delegate:ItemDetailsEditorDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        segmentedControl = UISegmentedControl(items: [
            "None", "In App Only", "Every 15 Minutes"
        ])
        
        addSubview(segmentedControl)
        segmentedControl.constraintToSuperview(12, 16, 12, 16, ignoreSafeArea: true)
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        
    }
    
    func setWatchLevel(_ watchLevel:ItemWatchLevel) {
        segmentedControl.selectedSegmentIndex = watchLevel.rawValue
    }
    
    @objc func segmentedControlDidChange() {
        delegate?.segmentedControlDidChange(segmentedControl.selectedSegmentIndex)
    }
    
}
