//
//  PageViewController.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 23.02.2021.
//

import UIKit
import Swift_PageMenu

class PageViewController: PageMenuController {
    
    var ticker: Ticker!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setupNavBar()
    }
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        
        let tickerLabel = UILabel()
        tickerLabel.text = ticker.displaySymbol
        tickerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
        tickerLabel.textColor = .textColor
        stackView.addArrangedSubview(tickerLabel)
        
        let companyLabel = UILabel()
        companyLabel.text = ticker.tickerDescription
        companyLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        companyLabel.textColor = .textColor
        stackView.addArrangedSubview(companyLabel)
        navigationItem.titleView = stackView
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: ticker.isFavourite ? "star.fill" : "star"),
                                          style: .done, target: self, action: #selector(addToFavourite))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc func addToFavourite() {
        TradeDataProvider.shared.addToFavourite(ticker: ticker)
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: ticker.isFavourite ? "star.fill" : "star")
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension PageViewController: PageMenuControllerDataSource {
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
        return [ChartViewController(nibName: "ChartViewController", bundle: nil),
                SummaryViewController(nibName: "SummaryViewController", bundle: nil),
                NewsViewController(nibName: "NewsViewController", bundle: nil)]
    }
    
    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return ["Charts", "Summary","News"]
    }
    
    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
    
    
}
