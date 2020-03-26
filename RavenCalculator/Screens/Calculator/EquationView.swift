//
//  TextViewCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-02.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit



class Test:UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print("action: \(action.description)")
        return true
    }
}

class EquationView:UIView, UITextViewDelegate {
    var textView:UITextView!
    let customView = UIView()
    
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
        //selectionStyle = .none
        //self.isUserInteractionEnabled = false
        //backgroundColor = UIColor.named(.background)
//        /contentView.backgroundColor = UIColor.named(.background)
        self.backgroundColor = UIColor.secondarySystemGroupedBackground
        textView = UITextView()
        textView.isSelectable = true
        textView.backgroundColor = UIColor.clear
        addSubview(textView)
        textView.constraintToSuperview(8, 12, 8, 12, ignoreSafeArea: true)
        textView.isScrollEnabled = false
        textView.textColor = UIColor.label//(hex: "95DFFF")
        textView.keyboardType = .asciiCapable
        textView.autocorrectionType = .no
        textView.font = UIFont.monospacedSystemFont(ofSize: 22, weight: .regular)//.systemFont(ofSize: 24, weight: .regular)
        textView.autocapitalizationType = .allCharacters
        textView.tintColor = UIColor.label
        textView.returnKeyType = .done
        
        divider = UIView()
        addSubview(divider)
        divider.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        divider.isHidden = true
        
    }
    
    func startEditing() {
        textView.inputView = customView
        textView.becomeFirstResponder()
    }
    
    func updateSyntax(for components:[Component]) {
        //let text = textView.attributedText.string
//        /print("Components: \(components)")
        let attributedText = NSMutableAttributedString()
        
        for component in components {
            
            attributedText.append(NSAttributedString(string: component.string, attributes: component.type.styleAttributes))

        }
        
        textView.attributedText = attributedText
    }
    
}

