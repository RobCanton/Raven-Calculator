//
//  EvaluationView.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-07.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit
import GradientLoadingBar
import GradientProgressBar

class EvaluationView: UIView {
    
    private var valueLabel:UILabel!
    private var loadingBar:GradientActivityIndicatorView!
    static let loadingBarHeight:CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        valueLabel = UILabel()
        valueLabel.font = UIFont.monospacedSystemFont(ofSize: 22, weight: .medium)
        valueLabel.textColor = UIColor.systemPink
        addSubview(valueLabel)
        valueLabel.constraintToSuperview(8, 12, 8, 12, ignoreSafeArea: false)
        valueLabel.textAlignment = .right
        valueLabel.alpha = 0.0
        
        loadingBar = GradientActivityIndicatorView()
        loadingBar.gradientColors = [
            UIColor.systemBlue, UIColor.systemPink, UIColor.systemPink
        ]
        loadingBar.progressAnimationDuration = 1.0
        loadingBar.fadeIn()
        loadingBar.fadeOut()
        

        
        addSubview(loadingBar)
        loadingBar.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        loadingBar.constraintHeight(to: EvaluationView.loadingBarHeight)
 
        
//        loadingBar = GradientProgressBar()
//        addSubview(loadingBar)
//        loadingBar.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
//        loadingBar.constraintHeight(to: 4)
//
//        loadingBar.gradientColors = [
//            UIColor.systemBlue, UIColor.systemPink//, UIColor.systemPink, UIColor.systemPink,
//        ]
//
//        self.layoutIfNeeded()
//        loadingBar.progress = 0
//        loadingBar.
        
    }
    
    func startSolving() {
        valueLabel.alpha = 0.0
        loadingBar.fadeIn(duration: 0.3)
        
        //loadingBar.setProgress(5.0, animated: true)
    }
    
    func setEvaluation(_ evaluation: Evaluation) {
        valueLabel.text = "\(evaluation.result)"
        loadingBar.fadeOut(duration: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.valueLabel.alpha = 1.0
        }, completion: nil)
        
    }
    
}
