//
//  Component.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-03.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

enum ComponentType {
    case digit
    case operation
    case symbol
    case stat
    case space
    
    var styleAttributes:[NSAttributedString.Key: Any]? {
        switch self {
        case .operation:
            return [
                NSAttributedString.Key.foregroundColor: UIColor.systemPink,
                NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 24, weight: .regular)
            ]
        case .symbol:
            return [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 24, weight: .regular)
            ]
        case .stat:
            return [
                NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
                NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
            ]
        default:
            return [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 24, weight: .regular)
            ]
        }
    }
    
}
struct Component {
    var string:String
    let type:ComponentType
    var lastFragment:String?
    
    init(string:String, type:ComponentType) {
        self.string = string
        self.type = type
        self.lastFragment = string
    }
    
    mutating func addString(_ str:String) {
        self.string += str
        self.lastFragment = str
    }
    
    mutating func remove() -> Bool {
        
        
        if type == .operation {
            return true
        }
        
        if string.count <= 1 {
            return true
        }
        
        self.string = "\(self.string.dropLast(1))"
        return false
    
    }
    
    var stringRepresentable:String {
        return string
    }
}
