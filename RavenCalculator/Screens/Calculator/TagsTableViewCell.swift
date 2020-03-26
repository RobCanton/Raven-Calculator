//
//  TagTableViewCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-13.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit




protocol ItemDetailsEditorDelegate:class {
    func textDidChange(_ property:ItemDetails.Property, _ text:String?)
    func segmentedControlDidChange(_ selectedIndex:Int)
}

class NameTableViewCell:UITableViewCell, UITextFieldDelegate {
    var textField:UITextField!
    
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
        self.backgroundColor = UIColor(hex: "1D1D1E")
        
        textField = UITextField()
        contentView.addSubview(textField)
        textField.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: true)
        textField.font = UIFont.monospacedSystemFont(ofSize: 16.0, weight: .regular)
        textField.placeholder = "Name"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        delegate?.textDidChange(.name, textField.text)
    }

}


class TagsTableViewCell:UITableViewCell, UITextFieldDelegate {
    var textField:UITextField!
    
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
        self.backgroundColor = UIColor(hex: "1D1D1E")
        
        textField = UITextField()
        contentView.addSubview(textField)
        textField.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: true)
        textField.font = UIFont.monospacedSystemFont(ofSize: 16.0, weight: .regular)
        textField.placeholder = "Tags (comma separated)"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        delegate?.textDidChange(.tags, textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isBackspace {
            return true
        }
        
        if string == " " {
            return false
        }
        
        if string == "," {
            textField.text! += ", "
            return false
        }
        
        if string.isAlphanumeric {
            return true
        }
        
        
        
        return false
    }
}
