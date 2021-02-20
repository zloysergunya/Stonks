//
//  SearchViewController.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 20.02.2021.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    
    private var filteredStocks: [TradeStock]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView(searchTableView)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ListStockTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ListStockTableCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListStockTableCell.reuseIdentifier, for: indexPath) as! ListStockTableCell
        cell.setupCell(for: filteredStocks[indexPath.row])
        return cell
    }
}
