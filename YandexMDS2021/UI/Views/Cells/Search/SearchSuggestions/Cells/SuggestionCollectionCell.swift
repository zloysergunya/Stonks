//
//  SuggestionCollectionCell.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 22.02.2021.
//

import UIKit

class SuggestionCollectionCell: UICollectionViewCell {
    
    var someTitles = ["заголовок","заголовок побольше","заголовок еще больше",
                      "заголовок","заголовок побольше","заголовок еще больше",
                      "заголовок","заголовок побольше","заголовок еще больше"]
    
    @IBOutlet weak var stockNameLabel: UILabel!
    
    static let reuseIdentifier = "SuggestionCollectionCell"
    
    func setupCell(_ indexPath: IndexPath) {
        stockNameLabel.text = someTitles[indexPath.row]
    }

}
