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

struct Evaluation {
    let result:Double
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
        
        
        for stock in equationData.stocks {
//            for stat in Stat.all {
//                vars[.variable("\(stock.symbol)_\(stat.rawValue)")] = { _ in stock.quote.volume }
//            }
            vars[.variable("\(stock.symbol)_price")] = { _ in stock.quote.price }
            vars[.variable("\(stock.symbol)_peratio")] = { _ in stock.quote.peRatio }
            vars[.variable("\(stock.symbol)_change")] = { _ in stock.quote.change }
            vars[.variable("\(stock.symbol)_volume")] = { _ in stock.quote.volume }
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
