//
//  ChartViewController.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 23.02.2021.
//

import UIKit

class ChartViewController: UIViewController {
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var periodControl: UISegmentedControl!
    
    var ticker: Ticker!
    private var periodName: String? {
        periodControl.titleForSegment(at: periodControl.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupPeriodControl()
        updateUI()
    }
    
    private func updateUI() {
        TradeDataProvider.shared.getCandles(for: ticker.symbol, periodName: periodName) { [weak self] candles in
            if let candles = candles {
                self?.setupChart(candles)
            }
        }
    }
    
    private func setupChart(_ candles: [Double]) {
        let chart = Chart(frame: CGRect(x: chartView.bounds.minX, y: chartView.bounds.minY,
                                        width: chartView.frame.width, height: chartView.frame.height))
        chart.delegate = self
        let series = ChartSeries(candles)
        series.area = true
        series.color = .textColor
        chart.add(series)
        chartView.addSubview(chart)
    }
    
    private func setupPeriodControl() {
        let font12 = UIFont(name: "Roboto-Regular", size: 12.0)!
        periodControl.setTitleTextAttributes([.foregroundColor: UIColor.secondTextColor, .font: font12], for: .selected)
        periodControl.setBackgroundImage(UIImage(color: .textColor), for: .selected, barMetrics: .default)
        periodControl.setTitleTextAttributes([.foregroundColor: UIColor.textColor, .font: font12], for: .normal)
        periodControl.setBackgroundImage(UIImage(color: .grayColor), for: .normal, barMetrics: .default)
        periodControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    @IBAction func buyTicker(_ sender: UIButton) {
        
    }
    
    @IBAction func changePeriod(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    private var infoView = RoundView()
    private func addInfoView(x: CGFloat, y: CGFloat, value: Double) {
        infoView.removeFromSuperview()
        infoView = RoundView()
        let view = infoView
        var y = y
        if y - 100 < chartView.frame.minY {
            y = y + 120
        } else {
            y = y - 120
        }
        view.frame = CGRect(x: CGFloat(x - 50), y: CGFloat(y), width: 100, height: 70)
        view.backgroundColor = .textColor
        view.cornerRadius = 16
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        stackView.axis = .vertical
        stackView.distribution  = .fillProportionally
        stackView.alignment = .center
        
        let priceLabel = UILabel()
        priceLabel.text = "$\(value)"
        priceLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        priceLabel.textColor = .secondTextColor
        stackView.addArrangedSubview(priceLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = "3 nov 2020"
        dateLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        dateLabel.textColor = .grayColor
        stackView.addArrangedSubview(dateLabel)
        view.addSubview(stackView)
        chartView.addSubview(view)
    }
}

extension ChartViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat, y: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                addInfoView(x: left, y: y, value: value)
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        infoView.removeFromSuperview()
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        infoView.removeFromSuperview()
    }
}
