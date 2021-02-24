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
        setupFilterControl()
    }
    
    private func setupFilterControl() {
        filterControll.selectedSegmentIndex = TradeDataProvider.shared.showFavourites ? 1 : 0
        let font28 = UIFont(name: "Roboto-Bold", size: 28.0)!
        let font18 = UIFont(name: "Roboto-Bold", size: 18.0)!
        filterControll.setTitleTextAttributes([.foregroundColor: UIColor.textColor, .font: font28], for: .selected)
        filterControll.setTitleTextAttributes([.foregroundColor: UIColor.grayColor, .font: font18], for: .normal)
        filterControll.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        filterControll.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        filterControll.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    @IBAction func selectFilter(_ sender: UISegmentedControl) {
        TradeDataProvider.shared.showFavourites = sender.selectedSegmentIndex == 1
        (parentViewController as? ListViewController)?.updateUI()
    }
}
