//
//  RavenAccessoryView.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class RavenAccessoryView:UIView {
    
    var stackView:UIStackView!
    
    var operationsView:OperationsAccessoryView!
    var predictionsView:PredictionsAccessoryView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(named: "KeyboardBackground")
        stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.constraintToSuperview()
        
        operationsView = OperationsAccessoryView()
        stackView.addArrangedSubview(operationsView)
        
        predictionsView = PredictionsAccessoryView()
        //stackView.addArrangedSubview(predictionsView)

        //stackView.addArrangedSubview(statsView)
        
        
    }
    
    func setPredictionSymbols(_ symbols:[Symbol]) {
        predictionsView.symbols = symbols
        predictionsView.collectionView.reloadData()
        
        if symbols.isEmpty {
            predictionsView.removeFromSuperview()
        } else {
            stackView.addArrangedSubview(predictionsView)
        }
    }
    
   
}
