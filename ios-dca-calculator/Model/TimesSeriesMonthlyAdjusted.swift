//
//  TimesSeriesMonthlyAdjusted.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 25/12/21.
//

import Foundation

struct TimeSeriesMonthlyAdjusted: Decodable {
    let meta: Meta
    // this constant will display data out of order, that's why we will create some manipulations to sort data
    let timeSeries: [String: OHLC]
    
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries  = "Monthly Adjusted Time Series"
    }
    
    func getMonthInfos() -> [MonthInfo] {
        var monthInfos: [MonthInfo] = []
        // sorting data
        let sortedTimeSeries = timeSeries.sorted(by: { $0.key > $1.key })
        
        // here we are applying some methods
        sortedTimeSeries.forEach { dateString, ohlc in
            // converting string to date
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let date = df.date(from: dateString)
            let monthInfo = MonthInfo(date: date!, adjustedOpen: getAdjustedOpen(ohlc: ohlc), adjustedClose: Double(ohlc.adjustedClose)!)
            monthInfos.append(monthInfo)
        }
        
        return monthInfos
    }
    
    // this method calculates the adjusted open
    private func getAdjustedOpen(ohlc: OHLC) -> Double {
        return Double(ohlc.open)! * (Double(ohlc.adjustedClose)! / Double(ohlc.close)!)
    }
}

// this struct was created to sort data
struct MonthInfo: Decodable {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct Meta: Decodable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

// open high low close
struct OHLC: Decodable {
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
