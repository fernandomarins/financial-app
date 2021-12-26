//
//  DateSelectionTableViewController.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 26/12/21.
//

import Foundation
import UIKit

class DateSelectionTableViewController: UITableViewController {
    
    var timeSeries: TimeSeriesMonthlyAdjusted?
    private var monthInfos: [MonthInfo] = []
    
    var didSelectDate: ((Int) -> Void)?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfos()
        setupNavigation()
    }
    
    private func setupNavigation() {
        title = "Select Date"
    }
    
    private func setupMonthInfos() {
        monthInfos = timeSeries?.getMonthInfos() ?? []
    }
    
}

extension DateSelectionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSelectionID", for: indexPath) as! DateSelectionTableViewCell
        
        let index = indexPath.row
        let monthInfo = monthInfos[index]
        let isSelected = index == selectedIndex
        cell.configure(with: monthInfo, index: index, isSelectd: isSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo, index: Int, isSelectd: Bool) {
        
        monthLabel.text = monthInfo.date.MMYYFormat
        
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1 {
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
        
        accessoryType = isSelectd ? .checkmark : .none
        
    }
    
}
