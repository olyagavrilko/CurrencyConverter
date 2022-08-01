//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 05.07.2022.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func updateView(with config: MainViewController.Config)
    func showAlertToSetRateManually()
}

final class MainViewModel {
    
    weak var delegate: MainViewModelDelegate?
    
    var isLoading = false
    
    private let router: MainRouter
    private let networkService: NetworkService
    private let storage: Storage
    
    private var exchangeRate: Double = 1 {
        didSet { storage.exchangeRate = exchangeRate }
    }
    private var lastUpdateDate: String? {
        didSet { storage.lastUpdateDate = lastUpdateDate }
    }
    private var rateSetManually = false {
        didSet { storage.rateSetManually = rateSetManually }
    }
    private var initialCurrency = "" {
        didSet { storage.initialCurrency = initialCurrency }
    }
    private var targetCurrency = "" {
        didSet { storage.targetCurrency = targetCurrency }
    }
    private var currentState: State = .initial
    
    init(router: MainRouter, networkService: NetworkService, storage: Storage) {
        self.router = router
        self.networkService = networkService
        self.storage = storage
    }
    
    func viewDidLoad() {
        lastUpdateDate = storage.lastUpdateDate
        rateSetManually = storage.rateSetManually
        initialCurrency = storage.initialCurrency
        targetCurrency = storage.targetCurrency
        
        if let exchangeRate = storage.exchangeRate {
            self.exchangeRate = exchangeRate
            updateView()
            if !rateSetManually {
                fetchCurrencyRateAndUpdateView()
            }
        } else {
            rateSetManually = true
            updateView()
            fetchCurrencyRateAndUpdateView()
        }
    }
    
    func saveRateButtonTapped(_ manualRate: String) {
        
        guard let rate = try? Formatter.formatToDouble(manualRate) else {
            return
        }
        
        exchangeRate = rate
        rateSetManually = true
        updateView()
    }
    
    func refreshButtonTapped() {
        fetchCurrencyRateAndUpdateView()
    }
    
    func makeOutputText(using state: State) throws -> String {
        switch state {
        case .initial:
            return .zero
        case .firstInput(let value):
            return try Formatter.formattedOutput(value)
        case .operation(let value, _):
            return try Formatter.formattedOutput(value)
        case .secondInput(_, let second, _):
            return try Formatter.formattedOutput(second)
        case .secondOperation(_, let second, _, _):
            return try Formatter.formattedOutput(second)
        case .thirdInput(_, _, let third, _, _):
            return try Formatter.formattedOutput(third)
        case .finish(let value, _, _):
            return try Formatter.formattedOutput(value)
        case .error:
            return AppConsts.error
        }
    }
}

// MARK: - Private

extension MainViewModel {
    
    private func fetchCurrencyRateAndUpdateView() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        networkService.fetchCurrencyRate(initial: initialCurrency, target: targetCurrency) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let rate):
                self.lastUpdateDate = rate.date
                self.exchangeRate = rate.value
                self.rateSetManually = false
                self.updateView()
            case .failure:
                self.updateView()
            }
            self.isLoading = false
        }
    }
    
    private func convert(unconverted: String, exchangeRate: Double) throws -> String {
        let number = try Formatter.formatToDouble(unconverted)
        let result = try Formatter.formatToString(number * exchangeRate)
        return try Formatter.formatToDecimalStyle(result)
    }
    
    private func makeAction(using value: String) -> Action {
        if "0123456789".contains(value) {
            return Action.number(value)
        } else if "􀅿􀅾􀅼􀅽".contains(value) {
            if value == "􀅼" {
                return Action.operation(.add)
            } else if value == "􀅽" {
                return Action.operation(.subtract)
            } else if value == "􀅾" {
                return Action.operation(.multiply)
            } else if value == "􀅿" {
                return Action.operation(.divide)
            }
        } else if value == "," {
            return Action.comma
        } else if value == "􀆀" {
            return Action.equal
        } else if value == "C" {
            return Action.cancel
        } else if value == "􀘾" {
            return Action.percent
        }
        return Action.cancel
    }
    
    private func makeViewConfig() -> MainViewController.Config {
        var initialInput: String
        var targetInput: String
        
        do {
            initialInput = try makeOutputText(using: currentState)
            targetInput = try convert(unconverted: initialInput, exchangeRate: exchangeRate)
        } catch {
            initialInput = AppConsts.error
            targetInput = AppConsts.error
        }
        
        return MainViewController.Config(
            rateViewConfig: CurrencyRateView.Config(
                initialCurrency: initialCurrency,
                targetCurrency: targetCurrency,
                exchangeRate: exchangeRate,
                title: rateSetManually ? "Курс установлен вручную" : lastUpdateDate ?? "",
                action: rateViewTapped),
            initialInputViewConfig: InputView.Config(
                currency: initialCurrency,
                input: initialInput,
                tapAction: initialInputTapped),
            targetInputViewConfig: InputView.Config(
                currency: targetCurrency,
                input: targetInput,
                tapAction: targetInputTapped),
            keyboardViewConfig: KeyboardView.Config(
                action: keyboardButtonTapped))
    }
    
    private func updateView() {
        delegate?.updateView(with: makeViewConfig())
    }
    
    private func keyboardButtonTapped(_ title: String) {
        if title == "􀄬" {
            switchCurrency()
            fetchCurrencyRateAndUpdateView()
        } else {
            let action = makeAction(using: title)
            do {
                currentState = try StateMachine.reduce(state: currentState, action: action)
            } catch {
                currentState = State.error
            }
            updateView()
        }
    }
    
    private func switchCurrency() {
        let tmp = initialCurrency
        initialCurrency = targetCurrency
        targetCurrency = tmp
    }
    
    private func rateViewTapped() {
        delegate?.showAlertToSetRateManually()
    }
    
    private func initialInputTapped() {
        router.openCurrencySelection { selectedCurrency in
            if self.targetCurrency == selectedCurrency {
                self.switchCurrency()
            } else {
                self.initialCurrency = selectedCurrency
            }
            self.fetchCurrencyRateAndUpdateView()
        }
    }
    
    private func targetInputTapped() {
        router.openCurrencySelection { selectedCurrency in
            if self.initialCurrency == selectedCurrency {
                self.switchCurrency()
            } else {
                self.targetCurrency = selectedCurrency
            }
            self.fetchCurrencyRateAndUpdateView()
        }
    }
}
