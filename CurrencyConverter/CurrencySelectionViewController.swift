//
//  CurrencySelectionViewController.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 26.07.2022.
//

import UIKit

final class CurrencySelectionViewController: UIViewController {
    
    private let tableView = UITableView()
    private let currencyArray = ["RUB", "USD", "EUR"]
    private let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let navItem = UINavigationItem(title: "Выбрать валюту")
        navBar.barTintColor = .white
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.trailing.leading.bottom.equalToSuperview()
        }
    }
}

extension CurrencySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = currencyArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
