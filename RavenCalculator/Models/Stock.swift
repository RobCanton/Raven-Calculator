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
        var price: Double? // latestPrice
        var volume:Double? // latestVolume
        var change:Double? // change
        var changePercent:Double? // changePercent
        var open:Double? // open
        var close:Double? // close
        var previousClose:Double? // previousClose
        var previousVolume:Double? // previousVolume
        var high:Double? // high
        var low:Double? // low
        var marketCap:Double? // marketCap
        var avgTotalVolume:Double? // avgTotalVolume
        var week52High:Double? // week52High
        var week52Low:Double? // week52Low
        var ytdChange:Double? // ytdChange
        var peRatio:Double? // peRatio
        
        
        static func parse(from dict:[String:Any]) -> Quote? {
            print("Dict: \(dict)")
            
            let price = dict["latestPrice"] as? Double
            let volume = dict["latestVolume"] as? Double
            let change = dict["change"] as? Double
            let changePercent = dict["changePercent"] as? Double
            let open = dict["open"] as? Double
            let close = dict["close"] as? Double
            let previousClose = dict["previousClose"] as? Double
            let previousVolume = dict["previousVolume"] as? Double
            let high = dict["high"] as? Double
            let low = dict["low"] as? Double
            let marketCap = dict["marketCap"] as? Double
            let avgTotalVolume = dict["avgTotalVolume"] as? Double
            let week52High = dict["week52High"] as? Double
            let week52Low = dict["week52Low"] as? Double
            let ytdChange = dict["ytdChange"] as? Double
            let peRatio = dict["peRatio"] as? Double
                
            return Quote(price: price, volume: volume, change: change, changePercent: changePercent, open: open, close: close, previousClose: previousClose, previousVolume: previousVolume, high: high, low: low, marketCap: marketCap, avgTotalVolume: avgTotalVolume, week52High: week52High, week52Low: week52Low, ytdChange: ytdChange, peRatio: peRatio)
            
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


