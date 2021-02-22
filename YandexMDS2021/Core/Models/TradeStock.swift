//
//  TradeStock.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import RealmSwift

class TradeStock: Object, Decodable {
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    @objc dynamic var symbol = String()
    @objc dynamic var lastPrice = Double()
    @objc dynamic var volume = Double()
    var imageView: UIImageView?
    var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case lastPrice = "lastPrice"
        case volume = "volume"
    }
    
    required convenience init(_ dictionary: [String:Any]) {
        self.init()
        symbol = dictionary["s"] as! String
        lastPrice = dictionary["p"] as? Double ?? 0.0
        volume = dictionary["v"] as? Double ?? 0.0
    }
}
