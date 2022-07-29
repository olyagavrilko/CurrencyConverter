//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 04.07.2022.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController, MainViewModelDelegate {
    
    enum Consts {
        static let spacing: CGFloat = 12
        static let characterLimit = 10
        static let buttonWidth: CGFloat = (UIScreen.main.bounds.width - Consts.spacing * 5) / 4
    }
    
    private let viewModel: MainViewModel
    
    var rateView = CurrencyRateView()
    
    private let fromInputLabel = UILabel()
    private let toInputLabel = UILabel()
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    
    private let fromTextView = UIView()
    
    private let inputStackView = UIStackView()
    private let keyboardStackView = UIStackView()
        
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
    
    func updateInput(original: String, converted: String) {
        fromInputLabel.text = original
        toInputLabel.text = converted
    }
    
    func updateRateViewWithManualRate(initial: String, target: String, rate: Double) {
        rateView.update(with: CurrencyRateView.Config(
            initialCurrency: initial,
            targetCurrency: target,
            exchangeRate: rate,
            updateDate: "Курс установлен вручную"))
    }
    
    func switchCurrencyPair(initial: String, target: String, rate: Double, updateDate: String) {
        fromLabel.text = initial
        toLabel.text = target
        
        rateView.update(with: CurrencyRateView.Config(
            initialCurrency: initial,
            targetCurrency: target,
            exchangeRate: rate,
            updateDate: updateDate))
    }
    
    func setNewInitialCurrency(_ selectedCurrency: String, targetCurrency: String) {
        fromLabel.text = selectedCurrency
        
        rateView.update(with: CurrencyRateView.Config(
            initialCurrency: selectedCurrency,
            targetCurrency: targetCurrency,
            exchangeRate: 44,
            updateDate: "updateDate"))
    }
    
    func setNewTargetCurrency(initialCurrency: String, _ selectedCurrency: String) {
        toLabel.text = selectedCurrency
        
        rateView.update(with: CurrencyRateView.Config(
            initialCurrency: initialCurrency,
            targetCurrency: selectedCurrency,
            exchangeRate: 1 / 44,
            updateDate: "updateDate"))
    }
    
    @objc private func fromTextFieldTapped(sender: UITapGestureRecognizer) {
        viewModel.fromTextFieldTapped()
//        showDetailViewController(selectCurrency, sender: self)
    }
    
    @objc private func toTextFieldTapped(sender: UITapGestureRecognizer) {
        viewModel.toTextFieldTapped()
    }
    
    @objc private func rateViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        showAlertWithTextField()
    }
    
    @objc private func refreshButtonTapped() {
        print("refreshButtonTapped")
    }
// TODO: зачем тут self.viewModel
    private func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Установить свой курс", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.viewModel.setManualCurrencyRate(text)
                print("Text==>" + text)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in }
        alertController.addTextField { textField in
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    MARK: - Private
    
    private func setupViews() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped))
        
        rateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateViewTapped(_:))))
        rateView.isUserInteractionEnabled = true
        navigationItem.titleView = rateView
        
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
        
        fromLabel.textColor = .gray
        fromLabel.font = .systemFont(ofSize: 18)
        fromLabel.textAlignment = .right
        fromLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        inputStackView.addArrangedSubview(fromLabel)
        
        fromInputLabel.text = "0"
        fromInputLabel.textColor = .white
        fromInputLabel.font = .systemFont(ofSize: 65)
        fromInputLabel.adjustsFontSizeToFitWidth = true
        fromInputLabel.minimumScaleFactor = 40
        fromInputLabel.textAlignment = .right
        fromInputLabel.isUserInteractionEnabled = true
        fromInputLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fromTextFieldTapped)))
        fromInputLabel.tintColor = .clear
        fromInputLabel.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        inputStackView.addArrangedSubview(fromInputLabel)
        
        toLabel.textColor = .gray
        toLabel.font = .systemFont(ofSize: 18)
        toLabel.textAlignment = .right
        toLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        inputStackView.addArrangedSubview(toLabel)
        
        toInputLabel.text = "0"
        toInputLabel.textColor = .white
        toInputLabel.font = .systemFont(ofSize: 50)
        toInputLabel.adjustsFontSizeToFitWidth = true
        toInputLabel.minimumScaleFactor = 40
        toInputLabel.textAlignment = .right
        toInputLabel.isUserInteractionEnabled = true
        toInputLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toTextFieldTapped)))
        toInputLabel.tintColor = .clear
        toInputLabel.snp.makeConstraints {
            $0.height.equalTo(55)
        }
        inputStackView.addArrangedSubview(toInputLabel)
        
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

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return false
        }
        
        if string.contains(",") && text.contains(",") || string.contains(",") && text.isEmpty {
            return false
        }
        return true
    }
}
