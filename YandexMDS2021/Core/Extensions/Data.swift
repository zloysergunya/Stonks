//
//  Data.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 19.02.2021.
//

import Foundation

extension Data {
    var json: Any? {
        get {
            let serialize: Any?
            do {
                serialize = try JSONSerialization.jsonObject(with: self, options: [])
            }
            catch {
                return nil
            }
            return serialize
        }
    }
}
