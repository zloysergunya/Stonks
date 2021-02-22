//
//  SearchViewController.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 20.02.2021.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    
    private var filteredStocks: [Ticker]!
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView(searchTableView)
    }
    
    private func search(with text: String) {
        print(text)
        filteredStocks = TradeDataProvider.shared.search(with: text)
        searchTableView.reloadData()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        isSearching = searchText.count > 0
        search(with: searchText)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 50
        tableView.register(UINib(nibName: ListStockTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ListStockTableCell.reuseIdentifier)
        tableView.register(UINib(nibName: SuggestionsCollectionTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: SuggestionsCollectionTableCell.reuseIdentifier)
        tableView.register(UINib(nibName: SearchHeaderTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: SearchHeaderTableCell.reuseIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHeaderTableCell.reuseIdentifier) as! SearchHeaderTableCell
        cell.setupCell(for: section, isSearching: isSearching)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? (filteredStocks?.count ?? 0) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListStockTableCell.reuseIdentifier, for: indexPath) as! ListStockTableCell
            cell.setupCell(for: filteredStocks[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionsCollectionTableCell.reuseIdentifier, for: indexPath) as! SuggestionsCollectionTableCell
            cell.setupCell()
            return cell
        }
    }
}
