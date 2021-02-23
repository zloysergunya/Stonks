//
//  TradeDataProvider.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import RealmSwift

class TradeDataProvider {
    private var realm = try! Realm()
    var showFavourites = false
    static var shared = TradeDataProvider()
    private init(){}
    
    func getSymbols(complition: @escaping () -> ()) {
        let params = ["exchange":"US",
                      "mic":"XNGS"]
        HTTPManager(endPoint: "/stock/symbol", params: params) { [weak self] data, status in
            self?.saveSymbols(data)
            complition()
        }
    }
    
    private func saveSymbols(_ data: Data?) {
        if let symbols = data?.json as? [[String:Any]] {
            symbols.forEach { symbol in
                try! realm.write {
                    realm.add(Ticker(symbol), update: .modified)
                }
            }
        }
    }
    
    func getSymbols() -> [Ticker] {
        var array = realm.objects(Ticker.self).sorted(byKeyPath: "symbol", ascending: true)
        if showFavourites {
            array = array.filter("isFavourite == %@", showFavourites)
        }
        return Array(array)
    }
    
    func getSymbolsList() -> [String] {
        return realm.objects(Ticker.self).sorted(byKeyPath: "symbol", ascending: true).compactMap({ $0.symbol })
    }
    
    func addToFavourite(ticker: Ticker) {
        try! realm.write {
            ticker.isFavourite = !ticker.isFavourite
        }
    }
    
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
    
    func search(with text: String) -> [Ticker] {
        return Array(realm.objects(Ticker.self)
                        .filter("symbol CONTAINS[cd] %@ OR tickerDescription CONTAINS[cd] %@", text, text)
                        .sorted(byKeyPath: "symbol", ascending: true))
    }
}
