//
//  PredictionsAccessoryView.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

protocol PredictionsAccessoryDelegate:class {
    func predictionsAccessory(didSelect symbol:Symbol)
}

class PredictionsAccessoryView:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView!
    var symbols = [Symbol]()
    
    weak var delegate:PredictionsAccessoryDelegate?
    
    static let contentHeight:CGFloat = 56

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        constraintHeight(to: PredictionsAccessoryView.contentHeight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        addSubview(collectionView)
        collectionView.constraintToSuperview()
        collectionView.register(PredictionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(DividerCell.self, forCellWithReuseIdentifier: "dividerCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < symbols.count - 1 {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dividerCell", for: indexPath) as! DividerCell
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PredictionCell
        let symbol = symbols[indexPath.section]
        
        cell.titleLabel.text = symbol.symbol
        cell.subtitleLabel.text = symbol.securityName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        delegate?.predictionsAccessory(didSelect: symbols[indexPath.section])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            let width = UIScreen.main.bounds.width / 3
            return CGSize(width: width, height: 56)
        } else {
            return CGSize(width: 1, height: 56)
        }
    }
    
    
}

