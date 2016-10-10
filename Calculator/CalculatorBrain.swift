//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mehul Gupta on 10/8/16.
//  Copyright © 2016 Mehul Gupta. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator = 0.0
    private var currentOperation = String()
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private enum OperationEnum {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinartOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String, OperationEnum> = [
        "π" : OperationEnum.Constant(M_PI),
        "e" : OperationEnum.Constant(M_E),
        "√" : OperationEnum.UnaryOperation(sqrt),
        "cos" : OperationEnum.UnaryOperation(cos),
        "±" : OperationEnum.UnaryOperation({ -$0 }),
        "×" : OperationEnum.BinartOperation({ $0 * $1 }),
        "÷" : OperationEnum.BinartOperation({ $0 / $1 }),
        "+" : OperationEnum.BinartOperation({ $0 + $1 }),
        "−" : OperationEnum.BinartOperation({ $0 - $1 }),
        "=" : OperationEnum.Equals
    ]
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        
        if let op = operations[symbol]{
            switch op {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinartOperation(let function):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    private struct pendingBinaryOperationInfo{
    var binaryOperation: ((Double, Double) -> Double)
    var firstOperand: Double
    }
    
    var result: Double{
        get{ return accumulator}
    }
    
    private var isSymbol = false
    
    func setCurrentOperation(value: String){
        
        var value = value
        if value == "."{ value = "0." }
        
        if let op = operations[value]{
            isSymbol = true
            switch op {
            case .Constant(_):
                currentOperation = value
                historicalValue = currentOperation
            case .UnaryOperation(_):
                currentOperation = value + currentOperation
                historicalValue = currentOperation
            case .BinartOperation(_):
                currentOperation = currentOperation + value
                isSymbol = false
            case .Equals:
                currentOperation = currentOperation + value + String(accumulator)
                historicalValue = currentOperation
            }
        }else if !isSymbol{
            currentOperation = currentOperation + value
        }else{
            currentOperation = value
            isSymbol = false
        }
    }
    
    var currentOperationResult: String{
        get{
            return currentOperation
        }
    }
    
    private var historicalValue = String()

    var historicalOperationResult: String{
        get{
            return historicalValue
        }
    }
    
    private var internalProgram = [AnyObject]()
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram as AnyObject
        }
        set{
            clear()
            if let arrayOfOperations = newValue as? [AnyObject] {
                for op in arrayOfOperations {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    }else if let symbol = op as? String {
                        performOperation(symbol: symbol)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
}
