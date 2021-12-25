//
//  SearchTableViewCell.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 24/12/21.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assetSymbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var assetTypeLabel: UILabel!
    
    
    func configure(with searchResult: SearchResult) {
        assetSymbolLabel.text = searchResult.symbol
        assetNameLabel.text = searchResult.name
        assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
}

