//
//  CurrencyRateView.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 25.07.2022.
//

import UIKit
import SnapKit

final class CurrencyRateView: UIView {
    
    struct Config {
        let initialCurrency: String
        let targetCurrency: String
        let exchangeRate: Double
        let updateDate: String
    }
    
    let updateDateLabel = UILabel()
    let rateLabel = UILabel()
        
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        updateDateLabel.textColor = .white
        updateDateLabel.textAlignment = .center
        addSubview(updateDateLabel)
        updateDateLabel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        
        rateLabel.textColor = .white
        rateLabel.textAlignment = .center
        addSubview(rateLabel)
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(updateDateLabel.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
        }
    }
    
    func update(with config: Config) {
        updateDateLabel.text = "\(config.updateDate)"
        rateLabel.text = "1 \(config.initialCurrency) = \(config.exchangeRate) \(config.targetCurrency)"
    }
}
