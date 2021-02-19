//
//  UISegmentedControl.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import UIKit

extension UISegmentedControl {
    func customize() {
        let font28 = UIFont(name: "Roboto-Bold", size: 28.0)!
        let font18 = UIFont(name: "Roboto-Bold", size: 18.0)!
        setTitleTextAttributes([.foregroundColor: UIColor.textColor, .font: font28], for: .selected)
        setTitleTextAttributes([.foregroundColor: UIColor.lightGray, .font: font18], for: .normal)
        setBackgroundImage(UIImage(color: .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(color: .clear), for: .selected, barMetrics: .default)
    }
}
