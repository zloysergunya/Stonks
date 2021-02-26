//
//  Ticker.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 22.02.2021.
//

import RealmSwift

class Ticker: Object, Decodable {
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    
    @objc dynamic var symbol = String()
    @objc dynamic var currency: String?
    @objc dynamic var tickerDescription: String?
    @objc dynamic var displaySymbol: String?
    @objc dynamic var isFavourite = false
    @objc dynamic var lastPrice = Double()
    @objc dynamic var difPrice = Double()
    
    enum CodingKeys: String, CodingKey {
        case currency
        case tickerDescription
        case displaySymbol
        case symbol
    }
    
    required convenience init(_ dict: [String:Any]) {
        self.init()
        symbol = dict["symbol"] as! String
        currency = dict["currency"] as? String
        tickerDescription = dict["description"] as? String
        displaySymbol = dict["displaySymbol"] as? String
    }
}
