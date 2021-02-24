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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupChart()
        setupPeriodControl()
    }
    
    private func setupChart() {
        let chart = Chart(frame: CGRect(x: chartView.bounds.minX, y: chartView.bounds.minY,
                                        width: chartView.frame.width, height: chartView.frame.height))
        chart.delegate = self
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, 3.1, 10, 8])
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
    
    private var infoView = RoundView()
    private func addInfoView(x: CGFloat, y: Double, value: Double) {
        infoView.removeFromSuperview()
        infoView = RoundView()
        let view = infoView
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
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                addInfoView(x: left, y: x, value: value)
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
//        return
        infoView.removeFromSuperview()
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        infoView.removeFromSuperview()
    }
}
