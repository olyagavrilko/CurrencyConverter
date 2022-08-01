//
//  CurrencyRateView.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 25.07.2022.
//

import SnapKit

final class CurrencyRateView: UIView {
    
    struct Config {
        let initialCurrency: String
        let targetCurrency: String
        let exchangeRate: Double
        let title: String
        let action: () -> Void
    }
    
    private var action: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let rateLabel = UILabel()
        
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with config: Config) {
        titleLabel.text = config.title
        rateLabel.text = "1 \(config.initialCurrency) = \(config.exchangeRate) \(config.targetCurrency)"
        action = config.action
    }
}

// MARK: - Private

extension CurrencyRateView {
    
    private func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        
        rateLabel.textColor = .white
        rateLabel.textAlignment = .center
        addSubview(rateLabel)
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
        }
    }
    
    @objc private func viewTapped() {
        action?()
    }
}
