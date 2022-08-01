//
//  Storage.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 31.07.2022.
//

import Foundation

final class Storage {
    
    private enum Keys {
        static let exchangeRate = "exchangeRate"
        static let lastUpdateDate = "lastUpdateDate"
        static let rateSetManually = "rateSetManually"
        static let initialCurrency = "initialCurrency"
        static let targetCurrency = "targetCurrency"
    }
    
    private let userDefaults = UserDefaults.standard
    
    var exchangeRate: Double? {
        get {
            userDefaults.double(forKey: Keys.exchangeRate)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.exchangeRate)
        }
    }
    
    var lastUpdateDate: String? {
        get {
            userDefaults.string(forKey: Keys.lastUpdateDate)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.lastUpdateDate)
        }
    }
    
    var rateSetManually: Bool {
        get {
            userDefaults.bool(forKey: Keys.rateSetManually)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.rateSetManually)
        }
    }
    
    var initialCurrency: String {
        get {
            userDefaults.string(forKey: Keys.initialCurrency) ?? "USD"
        }
        set {
            userDefaults.set(newValue, forKey: Keys.initialCurrency)
        }
    }
    
    var targetCurrency: String {
        get {
            userDefaults.string(forKey: Keys.targetCurrency) ?? "RUB"
        }
        set {
            userDefaults.set(newValue, forKey: Keys.targetCurrency)
        }
    }
}
