//
//  APIServices.swift
//  ios-dca-calculator
//
//  Created by Fernando Marins on 24/12/21.
//

import Foundation
import Combine

struct APIService {
    
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    let keys = ["3UZU90HMJM8L4QEU", "OUX0QORU7QD68882", "3XAZDK3Q4RU2Y41E"]
    
    var apiKey: String {
        return keys.randomElement() ?? ""
    }
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        // allowing to add a space between in the keywords
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
        }
        
        // Using the Combine framework
        return URLSession.shared.dataTaskPublisher(for: url).map ({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTimesSeriesMonthlyAdjusted(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        
        // allowing to add a space between in the keywords
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(keywords)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
        }
    
        // Using the Combine framework
        return URLSession.shared.dataTaskPublisher(for: url).map ({$0.data})
            .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    
}

