//
//  Equation.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-03.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

func parseComponents(from text:String) -> [Component] {
    var components = [Component]()
    
    
    
    var addTrailingSpace = false
    if text.last == " " {
        addTrailingSpace = true
    }
    
    
    let delimiterSet = ["*", "/", "+", "-", "(", ")", " "]//CharacterSet(charactersIn: "*/+-() ")
    let tokens = text.split {
        delimiterSet.contains(String($0))
    }
    
    var delimiters = [(String, Int)]()
    
    var count = 0
    text.forEach { c in
        //print("c: \(c)")
        if delimiterSet.contains(String(c)) {
            print("contains delim: \(c)")
            delimiters.append((String(c), count))
        }
        
        count += 1
    }
//    text.unicodeScalars.forEach({ scalar in
//
//        if delimiterSet.contains(scalar) {
//            delimiters.append("\(scalar)")
//        }
//    })
    
    
    var cap = 0
    for i in 0..<tokens.count {
        let token = String(tokens[i])
        
       
        let component = Component(string: String(token), type: .symbol)
        components.append(component)
        cap += token.count
        
        //print("cap: \(cap) | \(deli)")
        if delimiters.count > 0 {
            
            var delimiter = delimiters.first
            
            
            while (delimiter?.1 == cap) {
                let _ = delimiters.removeFirst()
                let operation = Component(string: delimiter!.0, type: .operation)
                components.append(operation)
                cap += delimiter!.0.count
                delimiter = delimiters.first
            }
//            if delimiter.1 == cap {
//                let _ = delimiters.removeFirst()
//                let operation = Component(string: delimiter.0, type: .operation)
//                components.append(operation)
//                cap += delimiter.0.count
//
//            }
            //print("cap: \(cap) | \(delimiter.1)")
        }
        
//        if i < delimiters.count {
//
//            print("delim: \(delimiters[i])")
//            let operation = Component(string: delimiters[i].0, type: .operation)
//            components.append(operation)
//            cap +=
//        }
        /*
        let spaceSeparatedTokens = token.split(separator: " ")
        for tokenFrag in spaceSeparatedTokens {
            let component = Component(string: String(tokenFrag), type: .symbol)
            components.append(component)
            
            let spaceComponent = Component(string: " ", type: .space)
            components.append(spaceComponent)
        }
        */
//        if i < operations.count {
//            let operation = Component(string: operations[i], type: .operation)
//            components.append(operation)
//        }
    }
    
//    let diff = delimiters.count - tokens.count
//    if diff > 0 {
//        for i in delimiters.count-diff..<delimiters.count {
//            let operation = Component(string: delimiters[i], type: .operation)
//            components.append(operation)
//        }
//    }
    //print("Operations: \(operations)")
    
//    if text.last == " " {
//        components.append(Component(string: " ", type: .space))
//    }
    
    var string = ""
    for component in components {
        string += "[\(component.string)] + "
    }
    print(string)
    
    return components
}

func parse(_ text:String) -> [Component] {
    
    let tokens = text.split(separator: " ")
    var addTrailingSpace = false
    if text.last == " " {
        addTrailingSpace = true
    }
    
    
    
    var components = [Component]()
    for i in 0..<tokens.count {
        let token = tokens[i]
        let str = String(token)
        if str.isOperation {
            let component = Component(string: str, type: .operation)
            components.append(component)
        } else if str.isAlphanumericAndAllowables {
            if str.contains(":") {
                let fragments = str.split(separator: ":")
                if fragments.count == 2 {
                    let leadingFragment = String(fragments[0])
                    let trailingFragment = String(fragments[1])
                    if leadingFragment.isAlphabetic {
                        let component = Component(string: leadingFragment, type: .symbol)
                        components.append(component)
                    } else {
                        let component = Component(string: leadingFragment, type: .unknown)
                        components.append(component)
                    }
                    
                    if trailingFragment.isAlphanumeric {
                        let component = Component(string: ":\(trailingFragment)", type: .stat)
                        components.append(component)
                    } else {
                        let component = Component(string: ":\(trailingFragment)", type: .unknown)
                        components.append(component)
                    }
                    
                } else if fragments.count == 1 {
                    if str.hasPrefix(":") {
                        let statComponent = Component(string: ":", type: .stat)
                        components.append(statComponent)
                        
                        let component = Component(string: String(fragments[0]), type: .stat)
                        components.append(component)
                    } else if str.hasSuffix(":") {
                        let component = Component(string: String(fragments[0]), type: .symbol)
                        components.append(component)
                        
                        let statComponent = Component(string: ":", type: .stat)
                        components.append(statComponent)
                        
                    } else {
                        let component = Component(string: str, type: .unknown)
                        components.append(component)
                    }
                    
                }
            } else {
                let component = Component(string: str, type: .symbol)
                           components.append(component)
            }

        } else if str.isNumeric {
            let component = Component(string: str, type: .digit)
            components.append(component)
        } else {
            let component = Component(string: str, type: .unknown)
            components.append(component)
        }
        
        if i < tokens.count - 1 {
            components.append(Component(string: " ", type: .space))
        }
    }
    
    if addTrailingSpace {
        components.append(Component(string: " ", type: .space))
    }
    
    var string = ""
    for component in components {
        string += "[\(component.string)] + "
    }
    print(string)
    
    return components
}


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
    
    mutating func addComponent(_ string:String, type: ComponentType, at point:(Int, Int)?=nil) -> [Component] {
        
        if let point = point {
            
            let activeComponent = components[point.0]
            var nextComponent:Component?
            if point.0 + 1 < components.count {
                nextComponent = components[point.0 + 1]
            }
            
            
            
            if type == .space {
                
                
                
                if point.1 >= activeComponent.length {
                    print("Add trailing space")
                    let component = Component(string: string, type: type)
                    components.insert(component, at: point.0 + 1)
                    return [component]
                } else {
                    print("Insert space & split")
                    let activeString = activeComponent.string
                    
                    let leadingStart = activeString.startIndex
                    let leadingEnd = activeString.index(leadingStart, offsetBy: point.1)
                    let leadingFragment = String(activeString[leadingStart..<leadingEnd])
                    
                    let trailingEnd = activeString.endIndex
                    let trailingFragment = String(activeString[leadingEnd..<trailingEnd])
                    
                    let leadingComponent = Component(string: leadingFragment, type: activeComponent.type)
                    
                    let trailingComponent = Component(string: trailingFragment, type: activeComponent.type)
                    
                    let component = Component(string: string, type: type)
                    
                    let _ = components.remove(at: point.0)
                    
                    components.insert(contentsOf: [
                        leadingComponent,
                        component,
                        trailingComponent
                    ], at: point.0)
                    
                    return [
                        
                        component
                        
                    ]
                }
                
            } else if type == .operation {
                var _components = [Component]()
                if activeComponent.type == .space {
                    
                    let component = Component(string: string, type: type)
                    let trailingComponent = Component(string: " ", type: .space)
                    
                    if nextComponent != nil {
                        
                        components.insert(contentsOf: [
                            component,
                            trailingComponent
                        ], at: point.0 + 1)
                        
                    } else {
                        
                        components.append(contentsOf: [
                            component,
                            trailingComponent
                        ])
                    }
                    
                    _components.append(component)
                    _components.append(trailingComponent)
                    
                    
                } else {
                    let leadingComponent = Component(string: " ", type: .space)
                    let component = Component(string: string, type: type)
                    let trailingComponent = Component(string: " ", type: .space)
                    
                    if nextComponent != nil {
                        components.insert(contentsOf: [
                            leadingComponent,
                            component,
                            trailingComponent
                        ], at: point.0 + 1)
                    } else {
                        components.append(contentsOf: [
                            leadingComponent,
                            component,
                            trailingComponent
                        ])
                    }
                    
                    _components.append(leadingComponent)
                    _components.append(component)
                    _components.append(trailingComponent)
                }
                
                return _components
            } else if type == .symbol {
                
                if activeComponent.type == .space {
                    if let nextComponent = nextComponent, nextComponent.type != .space {
                        components[point.0 + 1].addString(string, at: 0)
                        return [components[point.0 + 1]]
                    } else {
                        let component = Component(string: string, type: type)
                        components.insert(component, at: point.0 + 1)
                        return [component]
                    }
                } else {
                    components[point.0].addString(string, at: point.1)
                    return [components[point.0]]
                }
                /*
                if let nextComponent = nextComponent, activeComponent.type == .space {
                    if nextComponent.type == .space {
                        let component = Component(string: string, type: type)
                        components.insert(component, at: point.0 + 1)
                        return [component]
                    } else {
                        components[point.0 + 1].addString(string, at: 0)
                        return [components[point.0 + 1]]
                    }
                    
                } else {
                    if activeComponent.type == .space {
                        
                        let component = Component(string: string, type: type)
                        components.insert(component, at: point.0 + 1)
                        return [component]
                    } else {
                        components[point.0].addString(string, at: point.1)
                        return [components[point.0]]
                    }
                }*/
                
                
                
            }
            
            return []
            
        } else {
            print("Add space")
            let component = Component(string: string, type: type)
            components.append(component)
            return [component]
        }
        
//
//        if let last = components.last,
//            last.type == type {
//            components[components.count-1].addString(string)
//            return components[components.count-1]
//        } else {
//            let component = Component(string: string, type: type)
//            components.append(component)
//            return component
//        }
        
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
    
    func componentPoint(for index:Int) -> (Int, Int)? {
        var totalLength = 0
        for i in 0..<components.count {
            let component = components[i]
            let prevLength = totalLength
            totalLength += component.length
            
            if totalLength >= index {
                
                return (i, index - prevLength)
            }
        }
        
        return nil
    }
    
    mutating func process(text:String, cursor:Int) -> [Component] {
        
        
        let activeComponentPoint = componentPoint(for: cursor)

        var addedComponents = [Component]()
        
        if text == " " {
            let component = addComponent(text, type: .space, at: activeComponentPoint)
            addedComponents.append(contentsOf: component)
        } else if text.isAlphabetic {
            
            
            let component = addComponent(text, type: .symbol, at: activeComponentPoint)
            addedComponents.append(contentsOf: component)
            
        } else if text.isOperation {
            let component = addComponent(text, type: .operation, at: activeComponentPoint)
            addedComponents.append(contentsOf: component)
            
        }
        
        /*
        
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
        */
        return addedComponents
    }
}


