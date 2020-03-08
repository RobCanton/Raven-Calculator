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
    case change = "change"
    case dividend = "dividend"
    case dividendYield = "dividendyield"
    case employees = "employees"
    case marketcap = "marketcap"
    case week52change = "week52change"
    case week52high = "week52high"
    case week52low = "week52low"
    case peRatio = "peratio"
    case beta = "beta"
    case volume = "volume"
    
    static let all = [
        price, change, dividend, dividendYield,
        employees, marketcap, week52change,
        week52high, week52low, peRatio, beta, volume
    ]
    
    var searchable:String {
        return self.rawValue
    }
    
    var displayName:String {
        switch self {
        case .dividendYield:
            return "dividendYield"
        case .peRatio:
            return "peRatio"
        default:
            return rawValue
        }
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
