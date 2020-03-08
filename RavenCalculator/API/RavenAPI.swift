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
    
    
    
    func getData(for equation:Equation, completion: @escaping ((_ response:EquationDataResponse?, _ error:Error?)->())) {
        
        let symbolComponents = equation.components.filter { component in
            return component.type == .symbol
        }
        
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
