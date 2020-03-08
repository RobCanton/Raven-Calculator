//
//  Stock.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-06.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

struct Stock {
    var symbol:String
    var quote:Quote
    
    
    struct Quote {
        var price: Double
        var volume:Double
        var change:Double
        var peRatio:Double
        
        
        static func parse(from dict:[String:Any]) -> Quote? {
            print("dict: \(dict)")
            if let price = dict["latestPrice"] as? Double,
                let volume = dict["volume"] as? Double,
                let change = dict["change"] as? Double,
                let peRatio = dict["peRatio"] as? Double {
                
                return Quote(price: price,
                             volume: volume,
                             change: change,
                             peRatio: peRatio)
            }
            return nil
        }
    }
    
    static func parse(from dict:[String:Any], withKey key:String) -> Stock? {
        if let quoteDict = dict["quote"] as? [String:Any],
            let quote = Quote.parse(from: quoteDict) {
            return Stock(symbol: key, quote: quote)
        }
        return nil
    }
    
    
    
    
    
}


