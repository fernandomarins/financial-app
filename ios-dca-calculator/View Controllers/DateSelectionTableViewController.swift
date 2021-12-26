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
        
        let monthInfo = monthInfos[indexPath.row]
        
        cell.configure(with: monthInfo)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo) {
        backgroundColor = .red
    }
    
}
