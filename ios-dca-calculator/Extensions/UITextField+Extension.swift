//
//  UITextField+Extension.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 26/12/21.
//

import Foundation
import UIKit

extension UITextField {
    
    // adding a done button to the text field
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        
        doneToolBar.barStyle = .default
        
        // adding a flex space to make sure the button is on the right side
        let flexBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        let items = [flexBarButtonItem, doneBarButtonItem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    // method to dismiss the keyvoard when hitting the done button
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}
