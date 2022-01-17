//
//  DCAServices.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 17/01/22.
//

import Foundation

struct DCAServices {
    
    func calculate(asset: Asset, initialInvestmentAmout: Double, monthlyDolarCostAveragingAmount: Double, initialDateOfInvesmentIndex: Int) -> DCAResult {
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmout: initialInvestmentAmout, monthlyDolarCostAveragingAmount: monthlyDolarCostAveragingAmount, initialDateOfInvesmentIndex: initialDateOfInvesmentIndex)
        
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset, initialInvestmentAmout: initialInvestmentAmout, monthlyDolarCostAveragingAmount: monthlyDolarCostAveragingAmount, initialDateOfInvesmentIndex: initialDateOfInvesmentIndex)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain  = currentValue - investmentAmount
        
        let yield = gain / investmentAmount
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gainAmount: gain,
                     yield: yield,
                     annualReturn: 0.0,
                     isProfitable: isProfitable)
    }
    
    private func getInvestmentAmount(initialInvestmentAmout: Double,
                                     monthlyDolarCostAveragingAmount: Double,
                                     initialDateOfInvesmentIndex: Int) -> Double {
        var totalAmount = Double()
        totalAmount += initialInvestmentAmout
        
        let dollarCostAveringAmount = initialDateOfInvesmentIndex.doubleValue * monthlyDolarCostAveragingAmount
        totalAmount += dollarCostAveringAmount
        
        return totalAmount
    }
    
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    private func getNumberOfShares(asset: Asset, initialInvestmentAmout: Double, monthlyDolarCostAveragingAmount: Double, initialDateOfInvesmentIndex: Int) -> Double {
        
        var totalShare = Double()
        
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateOfInvesmentIndex].adjustedOpen
        
        let initialInvestmentShare = initialInvestmentAmout / initialInvestmentOpenPrice
        totalShare += initialInvestmentShare
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateOfInvesmentIndex).forEach { monthInfo in
            let dcaInvestmentShare = monthlyDolarCostAveragingAmount / monthInfo.adjustedOpen
            
            totalShare += dcaInvestmentShare
        }
        
        return totalShare
    }
    
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gainAmount: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
}
