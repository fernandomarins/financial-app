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
    var monthInfos: [MonthInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfos()
    }
    
    private func setupMonthInfos() {
        if let monthInfos = timeSeries?.getMonthInfos() {
            self.monthInfos = monthInfos
        }
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
        
        cell.configure(with: monthInfo, index: index)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo, index: Int) {
        
        monthLabel.text = monthInfo.date.MMYYFormat
        
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1 {
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
        
    }
    
}
