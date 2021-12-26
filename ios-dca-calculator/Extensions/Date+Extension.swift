//
//  Date+Extension.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 26/12/21.
//

import Foundation

extension Date {
    
    var MMYYFormat: String {
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        return df.string(from: self)
    }
    
}
