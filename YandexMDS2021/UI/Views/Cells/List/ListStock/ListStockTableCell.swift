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
    @IBOutlet weak var favouriteButton: UIButton!
    
    static let reuseIdentifier = "ListStockTableCell"
    private var ticker: Ticker!
    
    func setupCell(for ticker: Ticker) {
        self.ticker = ticker
        stockNameLabel.text = ticker.displaySymbol
        companyNameLabel.text = ticker.tickerDescription
        favouriteButton.tintColor = ticker.isFavourite ? .orange : .lightGray
        
        stockImageView.layer.masksToBounds = true
        stockImageView.layer.cornerRadius = 12
        DispatchQueue.main.async {
            self.stockImageView?.downloaded(from: "https://finnhub.io/api/logo?symbol=\(ticker.symbol)")
        }
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        TradeDataProvider.shared.addToFavourite(ticker: ticker)
        favouriteButton.tintColor = ticker.isFavourite ? .orange : .lightGray
    }
}
