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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView(listTableView)
        setupWebSocket()
        updateUI()
    }
    
    private func setupWebSocket() {
        WSManager.shared.delegate = self
        WSManager.shared.connect()
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"AAPL\"}")
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"GOOGL\"}")
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"AMZN\"}")
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"BAC\"}")
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"MSFT\"}")
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"TSLA\"}")
        WSManager.shared.send(message: "{\"type\":\"subscribe\",\"symbol\":\"MA\"}")
    }
    
    private func updateUI() {
        tradeStocks = TradeDataProvider.shared.getTradeStock()
        listTableView.reloadData()
    }
    
    deinit {
        WSManager.shared.disconnect()
    }
}

extension ListViewController: WSManagerDelegate {
    func didReceive(_ manager: WSManager, receivedData data: Data?) {
        TradeDataProvider.shared.saveTradeStock(data)
        updateUI()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 56
        tableView.register(UINib(nibName: ListStockTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ListStockTableCell.reuseIdentifier)
        tableView.register(UINib(nibName: SearchBarTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: SearchBarTableCell.reuseIdentifier)
        tableView.register(UINib(nibName: ListHeaderTableCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ListHeaderTableCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height / 3, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableCell.reuseIdentifier) as! SearchBarTableCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListHeaderTableCell.reuseIdentifier) as! ListHeaderTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : (tradeStocks?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListStockTableCell.reuseIdentifier, for: indexPath) as! ListStockTableCell
        cell.setupCell(for: tradeStocks[indexPath.row])
        return cell
    }
    
}
