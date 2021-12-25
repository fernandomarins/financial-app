//
//  APIServices.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 24/12/21.
//

import Foundation
import Combine

struct APIService {
    
    let keys = ["3UZU90HMJM8L4QEU", "OUX0QORU7QD68882", "3XAZDK3Q4RU2Y41E"]
    
    var apiKey: String {
        return keys.randomElement() ?? ""
    }
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url).map ({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

