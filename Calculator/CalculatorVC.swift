//
//  CalculatorVC.swift
//  Calculator
//
//  Created by Mehul Gupta on 10/8/16.
//  Copyright © 2016 Mehul Gupta. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {

    @IBOutlet private weak var historyLabel: UILabel!
    @IBOutlet private weak var currentOperationLabel: UILabel!
    @IBOutlet private weak var displayLabel: UILabel!
    private var userIsInputting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if historyLabel.text! == "History"{
            historyLabel.text! = ""
        }
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    private var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func remove() {
        if savedProgram != nil {
            brain.program  = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        if userIsInputting{
            displayLabel.text! = displayLabel.text! + sender.currentTitle!
        }else{
            if sender.currentTitle! == "."{
                    displayLabel.text = "0."
            }else{
                displayLabel.text = sender.currentTitle
            }
        }
        userIsInputting = true
        
        brain.setCurrentOperation(value: sender.currentTitle!)
        currentOperationLabel!.text = brain.currentOperationResult
    }

    private var displayValue: Double{
        get{
            if displayLabel.text! == "."{
                return 0.0
            }
            return Double(displayLabel.text!)! }
        set{ displayLabel.text = String(newValue) }
    }
    
    private var displayCurrentOperationValue: String{
        get{ return currentOperationLabel.text! }
        set{ currentOperationLabel.text = newValue }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func touchOperator(_ sender: UIButton) {
        if userIsInputting{
            brain.setOperand(operand: displayValue)
            userIsInputting = false
        }
        if let mathamaticalOperator = sender.currentTitle{
            brain.performOperation(symbol: mathamaticalOperator)
        }
        displayValue = brain.result
        
        brain.setCurrentOperation(value: sender.currentTitle!)
        displayCurrentOperationValue = brain.currentOperationResult
        
        historyLabel.text! = brain.historicalOperationResult
        
    }
}

