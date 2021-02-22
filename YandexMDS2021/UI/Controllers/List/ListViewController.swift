//
//  ListViewController.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 16.02.2021.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!
    
    private var tradeStocks: [TradeStock]!
    private var tickers: [Ticker]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        addSearchbar()
        setupTableView(listTableView)
        setupWebSocket()
        TradeDataProvider.shared.getSymbols() { [weak self] in
            self?.updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func updateUI() {
        tickers = TradeDataProvider.shared.getSymbols()
//        tradeStocks = TradeDataProvider.shared.getTradeStock()
        listTableView.reloadData()
    }
    
    private func setupWebSocket() {
        WSManager.shared.delegate = self
        WSManager.shared.connect()
    }
    
    func addSearchbar() {
        let searchResultsController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = searchResultsController
        let searchBar = searchController.searchBar
        searchBar.tintColor = .textColor
        searchBar.barTintColor = .textColor
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .textColor
            textField.leftView?.tintColor = .textColor
            textField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker",
                                                                 attributes: [.foregroundColor: UIColor.textColor])
            if let backgroundView = textField.subviews.first {
//                backgroundView.backgroundColor = .white
                backgroundView.layer.borderWidth = 1
                backgroundView.layer.borderColor = UIColor.textColor.cgColor
                backgroundView.layer.cornerRadius = min(textField.bounds.width, textField.bounds.height) / 2
                backgroundView.clipsToBounds = true
            }
        }
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.searchController = searchController
    }
    
    deinit {
        WSManager.shared.disconnect()
    }
}

extension ListViewController: WSManagerDelegate {
    func didReceive(_ manager: WSManager, receivedData data: Data?) {
        TradeDataProvider.shared.saveTradeStock(data)
//        updateUI()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 56
        tableView.register(UINib(nibName: ListStockTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ListStockTableCell.reuseIdentifier)
        tableView.register(UINib(nibName: ListHeaderTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ListHeaderTableCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height / 3, right: 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListHeaderTableCell.reuseIdentifier) as! ListHeaderTableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListStockTableCell.reuseIdentifier, for: indexPath) as! ListStockTableCell
        cell.setupCell(for: tickers[indexPath.row])
        return cell
    }
}

extension ListViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}
