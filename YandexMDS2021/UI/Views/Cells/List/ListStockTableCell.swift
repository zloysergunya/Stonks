//
//  ListStockTableCell.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import UIKit

class ListStockTableCell: UITableViewCell {
    @IBOutlet weak var stockImageView: UIImageView!
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var difPriceLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    static let reuseIdentifier = "ListStockTableCell"
    
    func setupCell(for stock: TradeStock) {
        stockNameLabel.text = stock.symbol
        lastPriceLabel.text = "$\(stock.lastPrice)"
        difPriceLabel.text = "$\(stock.volume)"
        
        if let url = URL(string: "https://finnhub.io/api/logo?symbol=\(stock.symbol)") {
            stockImageView.downloaded(from: url)
        }
    }
}
