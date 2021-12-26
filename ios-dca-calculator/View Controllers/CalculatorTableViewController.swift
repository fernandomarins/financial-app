//
//  CalculatorTableViewController.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 25/12/21.
//

import Foundation
import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDolarCostAveraging: UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    
    var asset: Asset?
    
    private var initialDateofInvesmentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        // here we are adding parenthsis around the currency name
        currencyLabels.forEach { label in
            label.text = asset?.searchResult.currency.addParenthesis()
        }
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDolarCostAveraging.addDoneButton()
        initialDateOfInvestment.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeries = timeSeriesMonthlyAdjusted
            dateSelectionTableViewController.selectedIndex = initialDateofInvesmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDidSelection(at: index)
            }
        }
    }
    
    // setting the initial date of invesment text field to the selected date from DateSelectionTableViewController
    private func handleDidSelection(at index: Int) {
        
        // poping DateSelectionTableViewController once the date is selected
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        
        navigationController?.popViewController(animated: true)
        
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() {
            initialDateofInvesmentIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestment.text = dateString
        }
    }
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestment {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMonthlyAdjusted)
    
        }
        
        return false
    }
}
