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
        
        stockImageView.layer.masksToBounds = true
        stockImageView.layer.cornerRadius = 12
        
        if let url = URL(string: "https://s3.polygon.io/logos/\(stock.symbol.lowercased())/logo.png"), stockImageView.image == nil {
            stockImageView.downloaded(from: url)
        }
    }
}
