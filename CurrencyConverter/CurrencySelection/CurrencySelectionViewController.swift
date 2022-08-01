//
//  CurrencySelectionViewController.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 26.07.2022.
//

import UIKit

final class CurrencySelectionViewController: UIViewController {
    
    private let tableView = UITableView()
    private let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    private let viewModel: CurrencySelectionViewModel
    
    init(viewModel: CurrencySelectionViewModel) {
        self.viewModel = viewModel
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
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
        content.text = viewModel.currencies[indexPath.row].code
        content.secondaryText = viewModel.currencies[indexPath.row].description
        content.textProperties.color = .white
        cell.contentConfiguration = content
        cell.backgroundColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.currencySelected(indexPath.row)
        dismiss(animated: true)
    }
}
