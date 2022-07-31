//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 29.07.2022.
//

import Foundation

final class NetworkService {
    
    func fetchCurrencyRate(initial: String, target: String, completion: @escaping (String, Double) -> Void) {
        
        let initialLow = initial.lowercased()
        let targetLow = target.lowercased()
        
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(initialLow)/\(targetLow).json")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            let dict = json as! [String: Any]
            let date = dict["date"] as! String
            let value = dict[targetLow] as! Double
            
            DispatchQueue.main.async {
                completion(date, value)
            }
        }
        
        task.resume()
    }
}
