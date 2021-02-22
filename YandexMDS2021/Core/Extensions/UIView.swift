//
//  UIView.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 22.02.2021.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        for responder in sequence(first: self, next: { $0.next }) {
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
