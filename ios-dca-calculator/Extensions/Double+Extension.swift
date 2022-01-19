//
//  Double+Extension.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 17/01/22.
//

import Foundation

extension Double {
    var stringValue: String {
        String(describing: self)
    }
    
    var twoDecimalPlaceString: String {
        String(format: "%.2f", self)
    }
    
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency        
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
    
    var percentageFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
    
    func toCurrencyFormat(hasDollarSymbol: Bool = true, hasDecimalPlaces: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if hasDollarSymbol == false {
            formatter.currencySymbol = ""
        }
        
        if hasDecimalPlaces == false {
            formatter.maximumFractionDigits = 0
        }
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
}
