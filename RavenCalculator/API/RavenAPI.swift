//
//  RavenAPI.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-06.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import Firebase


struct EquationDataResponse {
    let stocks:[Stock]
}

class RavenAPI {

    static let shared = RavenAPI()

    private init() {
        
    }
    
    
    func enablePresenceDetection() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let presenceRef = database.child("users/connected/\(uid)")
        
        presenceRef.setValue(true)
        presenceRef.onDisconnectRemoveValue()
        
    }
    
    func disablePresenceDetection() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let presenceRef = database.child("users/connected/\(uid)")
        presenceRef.removeValue()
        presenceRef.cancelDisconnectOperations()
    }
    
    func saveItem(_ item:Item, completion: @escaping ((_ error:Error?)->())) {
        
        
        let endpoint = "addItem"
        
        let symbols = item.equation.components(ofType: .symbol).map { symbol in
            return symbol.string
        }
        
        var params = [
            "equation": [
                "text": item.equation.stringRepresentation,
                "symbols": symbols
            ],
            "details": [
                "name": item.details.name ?? "",
                "tags": item.details.tagsStr ?? ""
            ],
            "watch_level": item.details.watchLevel.rawValue
        ] as [String : Any]
        
        if !item.id.isEmpty {
            params["id"] = item.id
        }
        
        functions.httpsCallable(endpoint).call(params) { result, error in
            guard let result = result, error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(error)
                return
            }
            
            print("result: \(result)")
            completion(nil)
        }
    }
    
    func getItems(completion: @escaping ((_ items:[Item])->())) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        let itemsRef = database.child("users/items/\(uid)")
        
        
        itemsRef.observe(.value, with: { snapshot in
            var _items = [Item]()
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot,
                    var childData = childSnapshot.value as? [String:Any] else {
                    continue
                }
                childData["id"] = childSnapshot.key
                
                if let item = Item.parse(from: childData) {
                    _items.append(item)
                }
            }
            
            completion(_items)
            
        })
    }
    
    
    func getData(for equation:Equation, completion: @escaping ((_ response:EquationDataResponse?, _ error:Error?)->())) {
        
        let symbolComponents = equation.components(ofType: .symbol)
        
        let symbols = symbolComponents.map { component in
            return component.string
        }
        
        let endpoint = "symbolQuotesBatch"
        let params = [
            "symbols": symbols
        ]
        functions.httpsCallable(endpoint).call(params) { result, error in
            guard let result = result, error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = result.data as? [String:[String:Any]] else { return }
            
            var stocks = [Stock]()
            for (key, stockData) in data {
                if let stock = Stock.parse(from: stockData, withKey: key) {
                    stocks.append(stock)
                }
            }
            
            let response = EquationDataResponse(stocks: stocks)
            completion(response, error)
            return

        }
    }
    
}
