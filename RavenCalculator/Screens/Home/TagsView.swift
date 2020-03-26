//
//  TagsView.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-13.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class TagsView:UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView:UICollectionView!
    
    var tags:[String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.constraintHeight(to: 32)
        
        backgroundColor = UIColor.clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 100, height: 100)
        layout.estimatedItemSize = CGSize(width: 72, height: 24)
        layout.minimumLineSpacing = 8.0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.constraintToSuperview()
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count// + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCollectionViewCell
        if false {//indexPath.row == 0 {
            cell.textLabel.text = "3 alerts"
            cell.bubbleView.backgroundColor = UIColor.systemBlue
        } else {
            cell.textLabel.text = tags[indexPath.row]
            cell.bubbleView.backgroundColor = UIColor.systemPink
        }
        
        
        return cell
    }
    
    func setTags(_ tags:[String]) {
        self.tags = tags
        self.collectionView.reloadData()
    }
}

class TagCollectionViewCell:UICollectionViewCell {
    
    var textLabel:UILabel!
    var bubbleView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        bubbleView = UIView()
        contentView.addSubview(bubbleView)
        bubbleView.constraintToSuperview()
        
        textLabel = UILabel()
        bubbleView.addSubview(textLabel)
        textLabel.constraintToSuperview(4, 8, 4, 8, ignoreSafeArea: true)
        textLabel.text = "Tech"
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textLabel.textAlignment = .center
        
        bubbleView.backgroundColor = UIColor.systemPink
        bubbleView.layer.cornerRadius = 4
        bubbleView.clipsToBounds = true
        bubbleView.layer.masksToBounds = true
        
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}
