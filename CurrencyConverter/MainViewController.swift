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

    private let inputStackView = UIStackView()
    private let keyboardStackView = UIStackView()
    
    private let fromTextField = UITextField()
    private let toTextField = UITextField()
    private var fromLabel = UILabel()
    private var toLabel = UILabel()
    
    var rateView = CurrencyRateView()
    
//    let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction))
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func update(original: String, converted: String) {
        fromTextField.text = original
        toTextField.text = converted
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
    
    @objc func checkActionTextField(textField: UITextField) {
        print("checkActionTextField")
        let selectCurrency = CurrencySelectionViewController()
        showDetailViewController(selectCurrency, sender: self)
    }
    
    @objc func checkActionView(_ sender: UITapGestureRecognizer? = nil) {
        print("checkActionView")
        showAlertWithTextField()
    }
    
    func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Add new tag", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                // operations
                print("Text==>" + text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Tag"
//        }
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    MARK: - Private
    
    private func setupViews() {
        view.backgroundColor = .black
        rateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkActionView(_:))))
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
        
//        fromLabel.text = "USD"
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
        fromTextField.isUserInteractionEnabled = true
        fromTextField.addTarget(self, action: #selector(checkActionTextField), for: .touchDown)
        fromTextField.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        inputStackView.addArrangedSubview(fromTextField)
        
//        toLabel.text = "RUB"
        toLabel.textColor = .gray
        toLabel.font = .systemFont(ofSize: 18)
        toLabel.textAlignment = .right
        toLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        inputStackView.addArrangedSubview(toLabel)
        
// TODO: .touchDown, плохо работает, при долгом нажатии появляется курсор и клавиатура
        toTextField.text = "0"
        toTextField.textColor = .white
        toTextField.font = .systemFont(ofSize: 50)
        toTextField.adjustsFontSizeToFitWidth = true
        toTextField.minimumFontSize = 40
        toTextField.textAlignment = .right
        toTextField.isUserInteractionEnabled = true
        toTextField.addTarget(self, action: #selector(checkActionTextField), for: .touchDown)
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
