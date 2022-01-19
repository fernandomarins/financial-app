//
//  CalculatorTableViewController.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 25/12/21.
//

import Foundation
import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDolarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    @IBOutlet weak var dateSlider: UISlider!
    
    var asset: Asset?
    
    @Published private var initialDateofInvesmentIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDolarCostAveragingAmount: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        setupDateSlider()
        observeForm()
        resetViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInvestmentAmountTextField.becomeFirstResponder()
    }
    
    private func setupViews() {
        navigationItem.title = asset?.searchResult.symbol
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
        monthlyDolarCostAveragingTextField.addDoneButton()
        initialDateOfInvestment.delegate = self
    }
    
    private func setupDateSlider() {
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count {
            // we are subtracting one to fix the UI slider bug
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    // this method will print the row selected in DateSelectionVC
    private func observeForm() {
        $initialDateofInvesmentIndex.sink { [weak self] (index) in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            
            if let dateString = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.MMYYFormat {
                self?.initialDateOfInvestment.text = dateString
            }
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap {
            ($0.object as? UITextField)?.text
        }.sink { [weak self] text in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDolarCostAveragingTextField).compactMap {
            ($0.object as? UITextField)?.text
        }.sink { [weak self] text in
            self?.monthlyDolarCostAveragingAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDolarCostAveragingAmount, $initialDateofInvesmentIndex).sink { [weak self] initialInvestmentAmount, monthlyDolarCostAveragingAmount, initialDateofInvesmentIndex  in
            
            guard let initialInvestmentAmount = initialInvestmentAmount,
                  let monthlyDolarCostAveragingAmount = monthlyDolarCostAveragingAmount,
                  let initialDateofInvesmentIndex = initialDateofInvesmentIndex,
                  let asset = self?.asset else {
                      return
                  }
            
            let result = self?.dcaService.calculate(asset: asset, initialInvestmentAmout: initialInvestmentAmount.doubleValue, monthlyDolarCostAveragingAmount: monthlyDolarCostAveragingAmount.doubleValue, initialDateOfInvesmentIndex: initialDateofInvesmentIndex)
            
            let isProfitable = (result?.isProfitable == true)
            let gainSymbol = isProfitable ? "+" : ""
            
            self?.currentValueLabel.backgroundColor = (result?.isProfitable == true) ? .themeGreenShare : .themeRedShare
            self?.currentValueLabel.text = result?.currentValue.currencyFormat
            self?.investAmountLabel.text = result?.investmentAmount.toCurrencyFormat(hasDecimalPlaces: false)
            self?.gainLabel.text = result?.gainAmount.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false).prefix(withText: gainSymbol)
            self?.yieldLabel.text = result?.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets()
            self?.yieldLabel.textColor = isProfitable ? .systemGreen : .systemRed
            self?.annualReturnLabel.text = result?.annualReturn.percentageFormat
            self?.annualReturnLabel.textColor = isProfitable ? .systemGreen : .systemRed
            
        }.store(in: &subscribers)
        
        
        
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
    
    private func resetViews() {
        currentValueLabel.text = "0.00"
        investAmountLabel.text  = "0.00"
        gainLabel.text = "-"
        yieldLabel.text = "-"
        annualReturnLabel.text = "-"
    }
    
    @IBAction func dateSliderDidChanger(_ sender: UISlider) {
        initialDateofInvesmentIndex = Int(sender.value)
    }
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestment {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        
        return true
    }
}
