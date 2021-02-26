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
    
    func addToFavourite(ticker: Ticker) {
        try! realm.write {
            ticker.isFavourite = !ticker.isFavourite
        }
    }
    
    func search(with text: String) -> [Ticker] {
        return Array(realm.objects(Ticker.self)
                        .filter("symbol CONTAINS[cd] %@ OR tickerDescription CONTAINS[cd] %@", text, text)
                        .sorted(byKeyPath: "symbol", ascending: true))
    }
}

// MARK: - symbols
extension TradeDataProvider {
    func getSymbols(complition: @escaping () -> ()) {
        let params = ["exchange":"US",
//                      "mic":"XNGS"
                      "mic":"XASE"
        ]
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
}

// MARK: - data from websocket
extension TradeDataProvider {
    func saveTradeStock(_ data: Data?) {
        if let json = data?.json as? [String:Any],
           let data = json ["data"] as? [[String:Any]] {
            data.forEach { dict in
                if let symbol = dict["s"] as? String,
                   let lastPrice = dict["p"] as? Double,
                   let ticker = realm.objects(Ticker.self).filter("symbol == %@", symbol).first {
                    try! realm.write {
                        ticker.lastPrice = lastPrice
                    }
                }
            }
        }
    }
}

// MARK: - quotes
extension TradeDataProvider {
    func getQuote(symbol: String, complition: @escaping () -> ()) {
        let params = ["symbol": symbol]
        HTTPManager(endPoint: "/quote", params: params) { [weak self] data, status in
            self?.saveQuote(symbol, data)
            complition()
        }
    }
    
    func getQuotes(complition: @escaping () -> ()) {
        for (index, element) in getSymbols().prefix(50).enumerated() {
            let params = ["symbol": element.symbol]
            HTTPManager(endPoint: "/quote", params: params) { [weak self] data, status in
                self?.saveQuote(element.symbol, data)
                if index == 49 { complition() }
            }
        }
    }
    
    private func saveQuote(_ symbol: String, _ data: Data?) {
        if let lastPrice = (data?.json as? [String:Any])?["c"] as? Double,
           let previosLastPrice = (data?.json as? [String:Any])?["pc"] as? Double,
            let ticker = realm.objects(Ticker.self).filter("symbol == %@", symbol).first {
            try! realm.write {
                ticker.lastPrice = lastPrice
                ticker.difPrice = (lastPrice - previosLastPrice).rounded(toPlaces: 2)
            }
        }
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - candles
extension TradeDataProvider {
    func getCandles(for symbol: String, periodName: String? = "D", complition: @escaping (_ data: [Double]?) -> ()) {
        var resolution = "5"
        var from = Int()
        switch periodName {
        case "D":
            from = Int(Date().add(.day, value: -1)!.timeIntervalSince1970)
        case "W":
            from = Int(Date().add(.day, value: -7)!.timeIntervalSince1970)
        case "M":
            resolution = "15"
            from = Int(Date().add(.day, value: -30)!.timeIntervalSince1970)
        case "6M":
            resolution = "D"
            from = Int(Date().add(.day, value: -180)!.timeIntervalSince1970)
        case "1Y":
            resolution = "30"
            from = Int(Date().add(.day, value: -365)!.timeIntervalSince1970)
        default:
            resolution = "M"
            from = 0
        }
        
        let params = ["symbol": symbol,
                      "resolution": resolution,
                      "from": "\(from)",
                      "to": "\(Int(Date().timeIntervalSince1970))"] as [String:Any]
        HTTPManager(endPoint: "/stock/candle", params: params) { data, status in
            let candles = (data?.json as? [String:Any])?["c"] as? [Double]
            complition(candles)
        }
    }
}

extension Date {
    func add(_ unit: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: unit, value: value, to: self)
    }
}
