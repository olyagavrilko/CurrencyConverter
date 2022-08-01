//
//  InputView.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 31.07.2022.
//

import UIKit

final class InputView: UIStackView {
    
    enum Size {
        case normal
        case small
        
        var fontSize: CGFloat {
            switch self {
            case .normal:
                return 65
            case .small:
                return 50
            }
        }
        
        var height: CGFloat {
            switch self {
            case .normal:
                return 70
            case .small:
                return 55
            }
        }
    }
    
    struct Config {
        let currency: String
        let input: String
        let tapAction: () -> Void
    }

    private var tapAction: (() -> Void)?
    
    private let currencyLabel = UILabel()
    private let inputLabel = UILabel()
    
    init(size: Size) {
        super.init(frame: .zero)
        setupViews(with: size)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with config: Config) {
        currencyLabel.text = config.currency
        inputLabel.text = config.input
        tapAction = config.tapAction
    }
}

// MARK: - Private

extension InputView {
    
    private func setupViews(with size: Size) {
        axis = .vertical
        distribution = .fill
        layoutMargins = UIEdgeInsets(top: 0, left: AppConsts.keyboardSpacing, bottom: 0, right: AppConsts.keyboardSpacing)
        isLayoutMarginsRelativeArrangement = true
        
        currencyLabel.textColor = .gray
        currencyLabel.font = .systemFont(ofSize: 18)
        currencyLabel.textAlignment = .right
        currencyLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        addArrangedSubview(currencyLabel)
        
        inputLabel.textColor = .white
        inputLabel.font = .systemFont(ofSize: size.fontSize)
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.minimumScaleFactor = 40
        inputLabel.textAlignment = .right
        inputLabel.isUserInteractionEnabled = true
        inputLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        inputLabel.tintColor = .clear
        inputLabel.snp.makeConstraints {
            $0.height.equalTo(size.height)
        }
        addArrangedSubview(inputLabel)
    }
    
    @objc private func labelTapped() {
        tapAction?()
    }
}
