//
//  SuggestionsCollectionTableCell.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 22.02.2021.
//

import UIKit

class SuggestionsCollectionTableCell: UITableViewCell {
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    
    static let reuseIdentifier = "SuggestionsCollectionTableCell"
    
    func setupCell() {
        setupCollectionView(suggestionsCollectionView)
        suggestionsCollectionView.reloadData()
        suggestionsCollectionView.layoutSubviews()
    }
}

extension SuggestionsCollectionTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: SuggestionCollectionCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: SuggestionCollectionCell.reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionCell.reuseIdentifier, for: indexPath) as! SuggestionCollectionCell
        cell.setupCell(indexPath)
        return cell
    }
}

extension SuggestionsCollectionTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 102, height: collectionView.bounds.height / 3)
    }
}
