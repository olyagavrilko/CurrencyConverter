//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 04.07.2022.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    enum Consts {
        static let spacing: CGFloat = 12
        static let characterLimit = 10
        static let buttonWidth: CGFloat = (UIScreen.main.bounds.width - Consts.spacing * 5) / 4
    }
    
    private let viewModel: MainViewModel

    private let inputStackView = UIStackView()
    private let keyboardStackView = UIStackView()
    
    private let fromTextField = UITextField()
    private let toTextField = UITextField()
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func update(text: String) {
        fromTextField.text = text
    }
    
//    MARK: - Private
    
    private func setupViews() {
        view.backgroundColor = .black
        setupKeyboardStackView()
        setupInputStackView()
    }
    
    private func setupKeyboardStackView() {
        keyboardStackView.axis = .vertical
        keyboardStackView.spacing = Consts.spacing
        
        var buttonsHorizontalStackView = createAndSetupHStackView(into: keyboardStackView)
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "C", style: .light(fontSize: 35)))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀄬", style: .light(fontSize: 30)))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀘾", style: .light(fontSize: 28)))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅿", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = createAndSetupHStackView(into: keyboardStackView)
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "7", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "8", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "9", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅾", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = createAndSetupHStackView(into: keyboardStackView)
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "4", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "5", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "6", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅽", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = createAndSetupHStackView(into: keyboardStackView)
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "1", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "2", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "3", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀅼", style: .orange(fontSize: 30)))
        
        buttonsHorizontalStackView = createAndSetupHStackView(into: keyboardStackView)
        createAndSetupDoubleButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "0", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: ",", style: .dark))
        createAndSetupButton(into: buttonsHorizontalStackView, with: ButtonViewModel(title: "􀆀", style: .orange(fontSize: 30)))
        
        view.addSubview(keyboardStackView)
        keyboardStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Consts.spacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Consts.spacing)
        }
    }
    
    private func setupInputStackView() {
        inputStackView.axis = .vertical
        inputStackView.distribution = .fill
        
        fromLabel.text = "USD"
        fromLabel.textColor = .gray
        fromLabel.font = .systemFont(ofSize: 18)
        fromLabel.textAlignment = .right
        fromLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        inputStackView.addArrangedSubview(fromLabel)
        
        fromTextField.text = "0"
        fromTextField.textColor = .white
        fromTextField.font = .systemFont(ofSize: 65)
        fromTextField.adjustsFontSizeToFitWidth = true
        fromTextField.minimumFontSize = 40
        fromTextField.textAlignment = .right
        fromTextField.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        inputStackView.addArrangedSubview(fromTextField)
        
        toLabel.text = "RUB"
        toLabel.textColor = .gray
        toLabel.font = .systemFont(ofSize: 18)
        toLabel.textAlignment = .right
        toLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        inputStackView.addArrangedSubview(toLabel)
        
        toTextField.text = "0"
        toTextField.textColor = .white
        toTextField.font = .systemFont(ofSize: 50)
        toTextField.adjustsFontSizeToFitWidth = true
        toTextField.minimumFontSize = 40
        toTextField.textAlignment = .right
        toTextField.snp.makeConstraints {
            $0.height.equalTo(55)
        }
        inputStackView.addArrangedSubview(toTextField)
        
        view.addSubview(inputStackView)
        inputStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Consts.spacing)
            $0.bottom.equalTo(keyboardStackView.snp.top).offset(-16)
        }
    }
    
    private func createAndSetupButton(into stackView: UIStackView, with model: ButtonViewModel) {
        let button = createButton(with: model)
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints {
            $0.width.equalTo(Consts.buttonWidth)
        }
    }
    
    private func createAndSetupDoubleButton(into stackView: UIStackView, with model: ButtonViewModel) {
        let doubleButton = UIButton()
        doubleButton.clipsToBounds = true
        let button = createButton(with: model)
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
    
    private func createButton(with model: ButtonViewModel) -> UIButton {
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
    
    private func createAndSetupHStackView(into stackView: UIStackView) -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = Consts.spacing
        stackView.addArrangedSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.height.equalTo(Consts.buttonWidth)
        }
        return hStackView
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let value = sender.title(for: .normal) else {
            return
        }
        viewModel.buttonTapped(with: value)
    }
}
