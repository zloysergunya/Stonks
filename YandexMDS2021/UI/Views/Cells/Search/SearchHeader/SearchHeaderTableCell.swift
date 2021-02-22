//
//  SearchHeaderTableCell.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 22.02.2021.
//

import UIKit

class SearchHeaderTableCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    static let reuseIdentifier = "SearchHeaderTableCell"
    private let headerNames = ["Stocks",
                               "Popular requests",
                               "You’ve searched for this"]
    
    func setupCell(for section: Int, isSearching: Bool) {
        if isSearching {
            headerLabel.text = headerNames[section]
            showMoreButton.isHidden = false
        } else {
            headerLabel.text = headerNames[section + 1]
            showMoreButton.isHidden = true
        }
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        
    }
}
