//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 29.07.2022.
//

import Foundation

final class NetworkService {
    
    enum Failure: Error {
        case `default`
    }
    
    func fetchCurrencyRate(initial: String, target: String, completion: @escaping (Result<CurrencyRate, Failure>) -> Void) {
        
        let initialLow = initial.lowercased()
        let targetLow = target.lowercased()
        
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(initialLow)/\(targetLow).json")
        else {
            completion(.failure(.default))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []),
                  let dict = json as? [String: Any],
                  let value = dict[targetLow] as? Double,
                  let date = dict["date"] as? String
            else {
                DispatchQueue.main.async {
                    completion(.failure(.default))
                }
                return
            }
            
            let currencyRate = CurrencyRate(value: value, date: date)
            
            DispatchQueue.main.async {
                completion(.success(currencyRate))
            }
        }.resume()
    }
}
