//
//  Array+Extensions.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-05.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
