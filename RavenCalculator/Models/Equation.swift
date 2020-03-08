//
//  Equation.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-03.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation



struct Equation {
    
    struct Evaluable {
        let string:String
        
    }
    
    var components:[Component]
    var cursor = (0,0)
    
    init() {
        components = []
    }
    
    var stringRepresentation:String {
        var string = ""
        for component in components {
            string += component.string
        }
        return string
    }
    
    func printAll() {
        var string = ""
        for component in components {
            string += "[\(component.string)] + "
        }
        print(string)
    }
    
    mutating func addComponent(_ string:String, type: ComponentType) -> Component {
        
        if let last = components.last,
            last.type == type {
            components[components.count-1].addString(string)
            return components[components.count-1]
        } else {
            let component = Component(string: string, type: type)
            components.append(component)
            return component
        }
        
    }
    
    mutating func removeComponent(forced:Bool = false) -> Component? {
        guard components.count > 0 else { return nil }
        var component = components[components.count-1]
        
        if forced {
            
            return components.removeLast()
        }
        
        if component.remove() {
            return components.removeLast()
        } else {
            components[components.count-1] = component
            return nil
        }
    }
    
    
    mutating func process(text:String) -> [Component] {
        var addedComponents = [Component]()
        if text == " " {
            
            let space = addComponent(text, type: .space)
            addedComponents.append(space)
            
        } else if text == ":" {
            if let last = components.last, last.type == .stat {
                
            } else {
                let stat = addComponent(text, type: .stat)
                addedComponents.append(stat)
            }
        } else if text.isOperation {
            if let last = components.last {
                if last.type == .space {
                    let operation = addComponent(text, type: .operation)
                    let trailingSpace = addComponent(" ", type: .space)
                    
                    addedComponents.append(operation)
                    addedComponents.append(trailingSpace)
                } else {
                    let leadingSpace = addComponent(" ", type: .space)
                    let operation = addComponent(text, type: .operation)
                    let trailingSpace = addComponent(" ", type: .space)
                    
                    addedComponents.append(leadingSpace)
                    addedComponents.append(operation)
                    addedComponents.append(trailingSpace)
                }
            }
            
        } else if text.isAlphabetic {
            if components.last?.type == ComponentType.stat {
                let stat = addComponent(text.lowercased(), type: .stat)
                addedComponents.append(stat)
            } else {
                let symbol = addComponent(text.uppercased(), type: .symbol)
                addedComponents.append(symbol)
            }
        } else if text.isNumeric {
            if components.last?.type == ComponentType.stat {
                let stat = addComponent(text.lowercased(), type: .stat)
                addedComponents.append(stat)
            } else {
                let digit = addComponent(text, type: .digit)
                addedComponents.append(digit)
            }
        }
        
        return addedComponents
    }
}


