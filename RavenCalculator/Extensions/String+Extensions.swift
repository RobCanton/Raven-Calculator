//
//  String+Extensions.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    var isHashtag:Bool {
        return self.hasPrefix("#")
    }
    
    var isCashtag:Bool {
        return self.hasPrefix("$")
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9.]", options: .regularExpression) == nil
    }
    
    var isAlphanumericAndAllowables:Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9.:#]", options: .regularExpression) == nil
    }
    
    var isAlphabetic: Bool {
        return !isEmpty && range(of: "[^a-zA-Z.]", options: .regularExpression) == nil
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9.]", options: .regularExpression) == nil
    }
    
    var isOperation: Bool {
        var characterSet = CharacterSet(charactersIn: "*/+-()")
        characterSet.invert()
        return self.rangeOfCharacter(from: characterSet) == nil
    }
}


