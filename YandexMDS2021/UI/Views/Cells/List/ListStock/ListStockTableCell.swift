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
    @IBOutlet weak var roundBackgroundView: RoundView!
    
    static let reuseIdentifier = "ListStockTableCell"
    private var ticker: Ticker!
    
    func setupCell(for ticker: Ticker) {
        self.ticker = ticker
        stockNameLabel.text = ticker.displaySymbol
        companyNameLabel.text = ticker.tickerDescription
        
        stockImageView.layer.masksToBounds = true
        stockImageView.layer.cornerRadius = 12
        self.stockImageView?.downloaded(from: "https://finnhub.io/api/logo?symbol=\(ticker.symbol)")
        
        setupColors()
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        TradeDataProvider.shared.addToFavourite(ticker: ticker)
        setupColors()
    }
    
    private func setupColors() {
        favouriteButton.tintColor = ticker.isFavourite ? .yellow : .lightGray
        roundBackgroundView.backgroundColor = ticker.isFavourite ? .secondBackgroundColor : .backgroundColor
        stockNameLabel.textColor = ticker.isFavourite ? .secondTextColor : .textColor
        companyNameLabel.textColor = ticker.isFavourite ? .secondTextColor : .textColor
        lastPriceLabel.textColor = ticker.isFavourite ? .secondTextColor : .textColor
    }
}
