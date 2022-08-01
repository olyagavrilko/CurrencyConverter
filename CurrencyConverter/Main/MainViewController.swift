//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 04.07.2022.
//

import SnapKit

final class MainViewController: UIViewController {
    
    struct Config {
        let rateViewConfig: CurrencyRateView.Config
        let initialInputViewConfig: InputView.Config
        let targetInputViewConfig: InputView.Config
        let keyboardViewConfig: KeyboardView.Config
    }
    
    private let viewModel: MainViewModel
    
    private let rateView = CurrencyRateView()
    private let initialInputView = InputView(size: .normal)
    private let targetInputView = InputView(size: .small)
    private let keyboardView = KeyboardView()
        
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
        viewModel.viewDidLoad()
    }
}

extension MainViewController: MainViewModelDelegate {
    
    func updateView(with config: Config) {
        rateView.update(with: config.rateViewConfig)
        initialInputView.update(with: config.initialInputViewConfig)
        targetInputView.update(with: config.targetInputViewConfig)
        keyboardView.update(with: config.keyboardViewConfig)
    }
    
    func showAlertToSetRateManually() {
        let alertController = UIAlertController(title: "Установить свой курс", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first, let text = textField.text {
                self?.viewModel.saveRateButtonTapped(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addTextField { textField in
            textField.keyboardType = .decimalPad
            textField.delegate = self
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return false
        }
        
        if string.contains(String.comma) && (text.contains(String.comma) || text.isEmpty) {
            return false
        }
        
        return true
    }
}

// MARK: - Private

extension MainViewController {
    
    private func setupViews() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped))
        navigationItem.titleView = rateView
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(AppConsts.keyboardSpacing)
        }
        
        stackView.addArrangedSubview(initialInputView)
        stackView.addArrangedSubview(targetInputView)
        stackView.setCustomSpacing(AppConsts.keyboardSpacing, after: targetInputView)
        stackView.addArrangedSubview(keyboardView)
    }
    
    @objc private func refreshButtonTapped() {
        viewModel.refreshButtonTapped()
    }
}

//    @objc private func fromTextFieldTapped(sender: UITapGestureRecognizer) {
//        viewModel.fromTextFieldTapped()
////        showDetailViewController(selectCurrency, sender: self)
//    }
//
//    @objc private func toTextFieldTapped(sender: UITapGestureRecognizer) {
//        viewModel.toTextFieldTapped()
//    }
//
//    @objc private func rateViewTapped(_ sender: UITapGestureRecognizer? = nil) {
//        showAlertWithTextField()
//    }
//
