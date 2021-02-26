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
    
    private var titleStatus = "Trading is closed" {
        didSet {
            title = titleStatus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleStatus = "Trading is closed"
    }
    
    private func setupUI() {
        addSearchbar()
        setupTableView(listTableView)
        if TradeDataProvider.shared.getSymbols().count == 0 {
            TradeDataProvider.shared.getSymbols() { [weak self] in
                self?.updateUI()
                self?.updateQuotes()
                self?.setupWebSocket()
            }
        } else {
            updateQuotes()
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
    
    private func updateQuotes() {
        TradeDataProvider.shared.getQuotes { [weak self] in
            self?.tickers = TradeDataProvider.shared.getSymbols()
            self?.listTableView.reloadData()
        }
    }
    
    func updateUI() {
        tickers = TradeDataProvider.shared.getSymbols()
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
                backgroundView.backgroundColor = .backgroundColor
                backgroundView.layer.borderWidth = 1
                backgroundView.layer.borderColor = UIColor.textColor.cgColor
                backgroundView.layer.cornerRadius = min(textField.bounds.width, textField.bounds.height) / 2
                backgroundView.clipsToBounds = true
            }
        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.tintColor = .textColor
        navigationItem.searchController = searchController
    }
    
    deinit {
        WSManager.shared.disconnect()
    }
}

extension ListViewController: WSManagerDelegate {
    func didReceive(_ manager: WSManager, receivedData data: Data?) {
        TradeDataProvider.shared.saveTradeStock(data)
        checkAvailabilityTrades(data: data)
        updateUI()
    }
    
    private func checkAvailabilityTrades(data: Data?) {
        if let status = (data?.json as? [String:Any])?["type"] as? String {
            if status == "ping" {
                titleStatus = "Trading is closed"
            } else {
                titleStatus = ""
            } 
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PageViewController(options: PagerOption())
        vc.ticker = tickers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}
