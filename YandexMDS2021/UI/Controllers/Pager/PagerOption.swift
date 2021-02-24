//
//  PagerOption.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 23.02.2021.
//

import Swift_PageMenu

struct PagerOption: PageMenuOptions {
    var menuItemSize: PageMenuItemSize {
        .sizeToFit(minWidth: 60, height: 40)
    }
    
    var font: UIFont = UIFont(name: "Roboto-Regular", size: 14)!
    var menuItemMargin: CGFloat = 20
    var menuTitleColor: UIColor = .grayColor
    var menuTitleSelectedColor: UIColor = .textColor
    var menuCursor: PageMenuCursor {
        .underline(barColor: .textColor, height: 2)
    }
    var tabMenuBackgroundColor: UIColor = .backgroundColor
}
