//
//  PredictionsTableCell.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-02.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class PredictionsTableCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    var results = [Symbol]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        contentView.layer.borderWidth = 2.0
        
        tableView = UITableView(frame: .zero, style: .plain)
        contentView.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(PredictionResultCell.self, forCellReuseIdentifier: "predictionCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "predictionCell", for: indexPath) as! PredictionResultCell
        let result = results[indexPath.row]
        cell.titleLabel?.text = result.symbol
        cell.subtitleLabel?.text = result.securityName
        return cell
    }
}
