//
//  Stat.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-07.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation


enum Stat:String {
    
    case price = "price"
    case volume = "volume"
    case change = "change"
    case changePercent = "changepercent"
    case open = "open"
    case close = "close"
    case previousClose = "previousclose"
    case previousVolume = "previousvolume"
    case high = "high"
    case low = "low"
    case marketCap = "marketcap"
    case avgTotalVolume = "avgtotalvolume"
    case week52High = "week52high"
    case week52Low = "week52low"
    case ytdChange = "ytdchange"
    case peRatio = "peratio"
    
    static let all = [
        price, volume, change, changePercent,
        open, close, previousClose, previousVolume,
        high, low, marketCap, avgTotalVolume,
        week52High, week52Low, ytdChange, peRatio
    ]
    
    var searchable:String {
        return self.rawValue
    }
    
}

extension Stat:Fuseable {
    var properties: [FuseProperty] {
        return [
            FuseProperty(name: rawValue, weight: 1.0),
            //FuseProperty(name: "searchable", weight: 1.0)
        ]
    }
    
    
}

//enum _Stat {
//
//}
//
//struct Stat:Comparable, Equatable {
//
//    var key:String
//
//    static func < (lhs: Stat, rhs: Stat) -> Bool {
//        return lhs.key < rhs.key
//    }
//
//}
//
//extension Stat:Fuseable {
//    var properties: [FuseProperty] {
//        return [
//            FuseProperty(name: key, weight: 1.0),
//        ]
//    }
//}
//
//let all_stats = [
//    Stat(key: "price"),
//    Stat(key: "change"),
//    Stat(key: "dividend"),
//    Stat(key: "dividendYield"),
//    Stat(key: "employee"),
//    Stat(key: "marketcap"),
//    Stat(key: "week52change"),
//    Stat(key: "week52high"),
//    Stat(key: "week52low"),
//    Stat(key: "peRatio"),
//    Stat(key: "beta"),
//    Stat(key: "volume")
//]
