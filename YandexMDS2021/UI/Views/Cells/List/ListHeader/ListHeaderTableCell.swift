//
//  ListHeaderTableCell.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import UIKit

class ListHeaderTableCell: UITableViewCell {
    @IBOutlet weak var filterControll: UISegmentedControl!
    
    static let reuseIdentifier = "ListHeaderTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterControll.selectedSegmentIndex = TradeDataProvider.shared.showFavourites ? 1 : 0
        filterControll.customize()
    }
    
    @IBAction func selectFilter(_ sender: UISegmentedControl) {
        TradeDataProvider.shared.showFavourites = sender.selectedSegmentIndex == 1
        (parentViewController as? ListViewController)?.updateUI()
    }
}
