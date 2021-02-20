//
//  TradeDataProvider.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import RealmSwift

class TradeDataProvider {
    private var realm = try! Realm()
    var showStocks = true
    static var shared = TradeDataProvider()
    private init(){}
    
    func saveTradeStock(_ data: Data?) {
        if let json = data?.json as? [String:Any],
           let data = json ["data"] as? [[String:Any]] {
            data.forEach { dict in
                try! realm.write {
                    realm.add(TradeStock(dict), update: .modified)
                }
            }
        }
    }
    
    func getTradeStock() -> [TradeStock] {
        return Array(realm.objects(TradeStock.self))
    }
    
    func search(with text: String) -> [TradeStock] {
        return Array(realm.objects(TradeStock.self).filter("symbol CONTAINS[cd] %@", text))
    }
}
