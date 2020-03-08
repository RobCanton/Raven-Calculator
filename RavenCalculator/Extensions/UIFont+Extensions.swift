//
//  UIFont+Extensions.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    
    static func customFont(ofSize size:CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "RobotoMono-Regular", size: size)!
        default:
            return UIFont(name: "RobotoMono-Regular", size: size)!
        }
    }
}
