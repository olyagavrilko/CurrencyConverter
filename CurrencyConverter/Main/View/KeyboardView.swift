//
//  KeyboardView.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 31.07.2022.
//

import UIKit

final class KeyboardView: UIStackView {
    
    typealias Action = (String) -> Void
    
    enum Consts {
        static let buttonWidth: CGFloat = (UIScreen.main.bounds.width - AppConsts.keyboardSpacing * 5) / 4
    }
    
    struct Config {
        let action: Action
    }
    
    private var action: Action?
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with config: Config) {
        action = config.action
    }
}

// MARK: - Private

extension KeyboardView {
    
    private func setupViews() {
        axis = .vertical
        spacing = AppConsts.keyboardSpacing
        layoutMargins = UIEdgeInsets(top: 0, left: AppConsts.keyboardSpacing, bottom: 0, right: AppConsts.keyboardSpacing)
        isLayoutMarginsRelativeArrangement = true
        
        var buttonsHorizontalStackView = setupHStackView()
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "C", style: .light(fontSize: 35)))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀄬", style: .light(fontSize: 30)))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀘾", style: .light(fontSize: 28)))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅿", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = setupHStackView()
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "7", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "8", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "9", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅾", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = setupHStackView()
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "4", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "5", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "6", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅽", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = setupHStackView()
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "1", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "2", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "3", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅼", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = setupHStackView()
        setupDoubleButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "0", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: ",", style: .dark))
        setupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀆀", style: .orange(fontSize: 30)))
    }
    
    private func setupButton(into stackView: UIStackView, with model: ButtonViewModel) {
        let button = makeButton(with: model)
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints {
            $0.width.equalTo(Consts.buttonWidth)
        }
    }
    
    private func setupDoubleButton(into stackView: UIStackView, with model: ButtonViewModel) {
        let doubleButton = UIButton()
        doubleButton.clipsToBounds = true
        let button = makeButton(with: model)
        button.setBackgroundImage(UIImage(color: .clear), for: .normal)
        button.isUserInteractionEnabled = false
        doubleButton.addSubview(button)
        button.snp.makeConstraints {
            $0.width.equalTo(Consts.buttonWidth)
            $0.left.top.bottom.equalToSuperview()
        }
        doubleButton.layer.cornerRadius = Consts.buttonWidth / 2
        doubleButton.backgroundColor = model.normalColor
        doubleButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        doubleButton.setTitle(model.title, for: .normal)
        doubleButton.setBackgroundImage(UIImage(color: model.highlightedColor), for: .highlighted)
        doubleButton.setBackgroundImage(UIImage(color: model.normalColor), for: .normal)
        doubleButton.setTitleColor(.clear, for: .normal)
        stackView.addArrangedSubview(doubleButton)
    }
    
    private func makeButton(with model: ButtonViewModel) -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = Consts.buttonWidth / 2
        button.titleLabel?.font = UIFont(name: model.font, size: model.fontSize)
        button.setTitleColor(model.titleColor, for: .normal)
        button.setTitle(model.title, for: .normal)
        button.setBackgroundImage(UIImage(color: model.highlightedColor), for: .highlighted)
        button.setBackgroundImage(UIImage(color: model.normalColor), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    private func setupHStackView() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = AppConsts.keyboardSpacing
        addArrangedSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.height.equalTo(Consts.buttonWidth)
        }
        return hStackView
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let value = sender.title(for: .normal) else {
            return
        }
        action?(value)
    }
}
