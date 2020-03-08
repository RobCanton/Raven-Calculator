//
//  UITextView+Extensions.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-01.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit


extension UITextView {
    /// Returns the current word that the cursor is at.
    
    
    func getRange(from position: UITextPosition, offset: Int, direction: UITextLayoutDirection = .right) -> UITextRange? {
        guard let newPosition = self.position(from: position, offset: offset) else { return nil }
        return self.textRange(from: newPosition, to: position)
        
        
    }
    
    var currentWordRange:UITextRange? {
        guard let cursorRange = self.selectedTextRange else { return nil }
        

        var wordStartPosition: UITextPosition = self.beginningOfDocument
        var wordEndPosition: UITextPosition = self.endOfDocument

        var position = cursorRange.start

        while let range = getRange(from: position, offset: -1), let text = self.text(in: range) {
            if text == " " || text == "\n" {
                wordStartPosition = range.end
                break
            }
            position = range.start
        }

        position = cursorRange.start

        while let range = getRange(from: position, offset: 1), let text = self.text(in: range) {
            if text == " " || text == "\n" {
                wordEndPosition = range.start
                break
            }
            position = range.end
        }

        guard let wordRange = self.textRange(from: wordStartPosition, to: wordEndPosition) else { return nil }

        return wordRange
    }
}
