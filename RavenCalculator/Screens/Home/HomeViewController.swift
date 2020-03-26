//
//  HomeViewController.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-11.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController:UITableViewController {
    
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.secondarySystemGroupedBackground
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        //navigationController?.navigationBar.barTintColor = UIColor.systemPink
        //navigationController?.navigationBar.backgroundColor = UIColor.systemPink
        navigationItem.title = "Watchlist"
        
        //navigationItem.searchController = searchController
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(EquationTableViewCell.self, forCellReuseIdentifier: "equationCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.backgroundColor = UIColor.secondarySystemGroupedBackground
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newEquation))
        
        equationsUpdated()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(equationsUpdated),
                                               name: Notification.Name("itemsUpdated"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func equationsUpdated() {
        self.tableView.reloadData()
    }
    
    @objc func newEquation() {
        let equationVC = EquationViewController()
        let nav = UINavigationController(rootViewController: equationVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemManager.shared.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equationCell", for: indexPath) as! EquationTableViewCell
        cell.setItem(ItemManager.shared.items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = ItemManager.shared.items[indexPath.row]
        let equationVC = EquationViewController(item: item)
        let nav = UINavigationController(rootViewController: equationVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movingItem = ItemManager.shared.items.remove(at: sourceIndexPath.row)
        ItemManager.shared.items.insert(movingItem, at: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ItemManager.shared.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}


extension HomeViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
