//
//  Equation.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-03.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

protocol EquationDelegate:class {
    func equationDidUpdate(_ components:[Component])
}

public struct Equation {
    
    
    weak var delegate:EquationDelegate?
    struct Evaluable {
        let string:String
        
    }
    
    var components:[Component] {
        didSet {
            delegate?.equationDidUpdate(self.components)
        }
    }
    
    var cursor = (0,0)
    
    func components(ofType type:ComponentType) -> [Component] {
        return components.filter {
            return $0.type == type
        }
    }
    
    init() {
        components = []
    }
    
    var stringRepresentation:String {
        var string = ""
        for i in 0..<components.count {
            let component = components[i]
            var str = component.string
            
            if component.type == .symbol {
                var nextComponentIsStat = false
                
                if i + 1 < components.count {
                    nextComponentIsStat = components[i+1].type == .stat
                }
                
                if !nextComponentIsStat {
                    str += ":price"
                }
            }
            
            string += str
            
        }
        return string
    }
    
    func componentIndex(at position:Int) -> Int? {
        var totalLength = 0
        for i in 0..<components.count {
            let component = components[i]
            totalLength += component.string.count
            if totalLength >= position {
                return i
            }
            
        }
        return nil
    }
    
    mutating func insertComponent(_ component:Component, at index:Int) {
        self.components.insert(component, at: index)
    }
    
    mutating func insertComponents(_ components:[Component], at index:Int) {
        self.components.insert(contentsOf: components, at: index)
    }
    
    mutating func removeComponent(at index:Int) {
        self.components.remove(at: index)
    }
    
    
    func printAll() {
        var string = ""
        for component in components {
            string += "[\(component.string)] + "
        }
        print(string)
    }
    
    mutating func process(text:String) {
        print("Text: [\(text)]")
        var _components = [Component]()
        
        let delimiterSet = ["*", "/", "+", "-", "(", ")", " "]//CharacterSet(charactersIn: "*/+-() ")
        let tokens = text.split {
            delimiterSet.contains(String($0))
        }
        
        var delimiters = [(String, Int)]()
        
        var count = 0
        text.forEach { c in
            if delimiterSet.contains(String(c)) {
                delimiters.append((String(c), count))
            }
            
            count += 1
        }
        
        print("Delimiters: \(delimiters)")
        
        var cap = 0
        for i in 0..<tokens.count {
            let token = String(tokens[i])

            if token.contains(":") {
                let split = token.split(separator: ":")
                if split.count == 2 {
                    let fragment = String(split[0])
                    if fragment.isAlphabetic {
                        let symbol = Component(string: fragment, type: .symbol)
                        _components.append(symbol)
                        cap += symbol.string.count
                    } else {
                        let unknown = Component(string: fragment, type: .unknown)
                        _components.append(unknown)
                        cap += unknown.string.count
                    }
                    
                    let stat = Component(string: ":\(String(split[1]))", type: .stat)
                    _components.append(stat)
                    cap += stat.string.count
                } else if split.count == 1 {
                    let fragment = String(split[0])
                    if fragment.isAlphabetic {
                        let symbol = Component(string: fragment, type: .symbol)
                        _components.append(symbol)
                        cap += symbol.string.count
                    } else {
                        let unknown = Component(string: fragment, type: .unknown)
                        _components.append(unknown)
                        cap += unknown.string.count
                    }
                    
                    
                    let stat = Component(string: ":", type: .stat)
                    _components.append(stat)
                    cap += stat.string.count
                } else {
                    let unknown = Component(string: token, type: .unknown)
                    _components.append(unknown)
                    cap += unknown.string.count
                }
            } else {
                var type:ComponentType
                if token.isAlphabetic {
                    type = .symbol
                } else if token.isNumeric {
                    type = .digit
                } else {
                    type = .unknown
                }
                
                let component = Component(string: String(token), type: type)
                _components.append(component)
                cap += component.string.count
            }
            
            
            if delimiters.count > 0 {
                
                var delimiter = delimiters.first
                
                while (delimiter?.1 == cap) {
                    let _ = delimiters.removeFirst()
                    let operation = Component(string: delimiter!.0, type: .operation)
                    _components.append(operation)
                    cap += delimiter!.0.count
                    delimiter = delimiters.first
                }
            }
        }
        
        /*if tokens.count == 0 {
            for delimiter in delimiters {
                let operation = Component(string: delimiter.0, type: .operation)
                _components.append(operation)
            }
        }*/
        
        printAll()
        self.components = _components
    }
    
}


