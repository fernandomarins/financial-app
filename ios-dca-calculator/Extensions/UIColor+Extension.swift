//
//  UIColor+Extension.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 17/01/22.
//

import Foundation
import UIKit

extension UIColor {
    
    // red fae2e1
    // green b0f1dd
    
    static let themeRedShare = UIColor("fae2e1")
    static let themeGreenShare = UIColor("b0f1dd")
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}
