//
//  String+Extension.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 26/12/21.
//

import Foundation

extension String {
    
    func addParenthesis() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func addBrackets() -> String {
        return "(\(self))"
    }
}
