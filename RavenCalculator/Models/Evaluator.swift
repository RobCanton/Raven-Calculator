//
//  Solve.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-07.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import Expression

protocol EvaluatorDelegate: class {
    func evaluatorDidStart()
    func evaluatorDidComplete(withResult result: Evaluation)
    func evaluatorDidFail(withError error:Error)
}

class Evaluator {
    let equation:Equation
    
    weak var delegate:EvaluatorDelegate?
    
    init (equation: Equation, delegate: EvaluatorDelegate?=nil) {
        self.equation = equation
        self.delegate = delegate
    }
    
    func solve() {
        fetchRequirements()
    }
    
    private func fetchRequirements() {
        delegate?.evaluatorDidStart()
        
        RavenAPI.shared.getData(for: equation) { response, error in
            if error != nil {
                self.delegate?.evaluatorDidFail(withError: error!)
                return
            }
            
            self.calculate(equationData: response!)
        }
    }
    
    private func calculate( equationData: EquationDataResponse) {
        
        var vars = [Expression.Symbol: Expression.SymbolEvaluator]()
        
        let statComponents = equation.components(ofType: .stat)
        
        var statTypes = [Stat: Bool]()
        
        for component in statComponents {
            let statStrClean = component.string.replacingOccurrences(of: ":", with: "").lowercased()
            if let stat = Stat(rawValue: statStrClean) {
                statTypes[stat] = true
            }
        }
        
        var unavailableStats = [Stat]()
        var variableValues = [String:Double]()
        
        for stock in equationData.stocks {
            for (type, _) in statTypes {
                let key = "\(stock.symbol)_\(type.rawValue)"
                switch type {
                case .volume:
                    if stock.quote.volume == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.volume
                case .change:
                    if stock.quote.change == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.change
                case .changePercent:
                    if stock.quote.changePercent == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.changePercent
                case .open:
                    if stock.quote.open == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.open
                case .close:
                    if stock.quote.close == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.close
                case .previousClose:
                    if stock.quote.previousClose == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.previousClose
                case .previousVolume:
                    if stock.quote.previousVolume == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.previousVolume
                case .high:
                    if stock.quote.high == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.high
                case .low:
                    if stock.quote.low == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.low
                case .marketCap:
                    if stock.quote.marketCap == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.marketCap
                case .avgTotalVolume:
                    if stock.quote.avgTotalVolume == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.avgTotalVolume
                case .week52High:
                    if stock.quote.week52High == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.week52High
                case .week52Low:
                    if stock.quote.week52Low == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.week52Low
                case .ytdChange:
                    if stock.quote.ytdChange == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.ytdChange
                case .peRatio:
                    if stock.quote.peRatio == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.peRatio
                default:
                    if stock.quote.price == nil {
                        unavailableStats.append(type)
                    }
                    variableValues[key] = stock.quote.price
                }
            }
        }
        
        print("unavailableStats: \(unavailableStats)")
        
        if unavailableStats.count > 0 {
            let error = NSError(domain: "", code: 0, userInfo: [:])
            self.delegate?.evaluatorDidFail(withError: error as Error)
            return
        }
        
        for stock in equationData.stocks {
            for (type, _) in statTypes {
                let key = "\(stock.symbol)_\(type.rawValue)"
                vars[.variable("\(stock.symbol)_\(type.rawValue)")] = { _ in
                    return variableValues[key] ?? 0
                }
            }
        }
        
        
        let expressionString = equation.stringRepresentation.replacingOccurrences(of: ":", with: "_")
        
        print("expressionString: \(expressionString)")
        let expression = Expression(expressionString, symbols: vars)
        
        do {
            let result = try expression.evaluate()
            let evaluation = Evaluation(result: result)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...3.0), execute: {
                self.delegate?.evaluatorDidComplete(withResult: evaluation)
            })
            
        } catch {
            print("Error: \(error.localizedDescription)")
            self.delegate?.evaluatorDidFail(withError: error)
        }
        
    }
    
}
