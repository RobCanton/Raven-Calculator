//
//  Easings.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-07.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

import Foundation
import UIKit


enum Easings {
    case Quad, Cubic, Quart, Quint
    
    var easeIn:UICubicTimingParameters {
        switch self {
        case .Quad:
            return parameters([0.55, 0.085, 0.68, 0.53])
        case .Cubic:
            return parameters([0.55, 0.055, 0.675, 0.19])
        case .Quart:
            return parameters([0.895, 0.03, 0.685, 0.22])
        case .Quint:
            return parameters([0.755, 0.05, 0.855, 0.06])
        }
    }
    
    var easeOut:UICubicTimingParameters {
        switch self {
        case .Quad:
            return parameters([0.25, 0.46, 0.45, 0.94])
        case .Cubic:
            return parameters([0.215, 0.61, 0.355, 1])
        case .Quart:
            return parameters([0.165, 0.84, 0.44, 1])
        case .Quint:
            return parameters([0.23, 1.0, 0.32, 1.0])
        }
    }
    
    var easeInOut:UICubicTimingParameters {
        switch self {
        case .Quad:
            return parameters([0.455, 0.03, 0.515, 0.955])
        case .Cubic:
            return parameters([0.645, 0.045, 0.355, 1])
        case .Quart:
            return parameters([0.77, 0, 0.175, 1])
        case .Quint:
            return parameters([0.86, 0, 0.07, 1.0])
        }
    }
    
    private func parameters(_ values:[CGFloat]) -> UICubicTimingParameters {
        guard values.count == 4 else { return UICubicTimingParameters(controlPoint1: .zero, controlPoint2: .zero) }
        return UICubicTimingParameters(controlPoint1: CGPoint(x: values[0], y: values[1]),
                                       controlPoint2: CGPoint(x: values[2],y: values[3]))
    }
    
}
