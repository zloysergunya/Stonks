//
//  HTTPManager.swift
//
//  Created by Sergey Kotov on 26.09.2020.
//

import Foundation

func HTTPManager(_ url: String = "https://finnhub.io/api/v1",
                 endPoint: String = "",
                 method: String = "GET",
                 params: [String:Any?] = [:],
                 constants: [String:Any?] = [:],
                 completion: @escaping (Data?, _ status: Int) -> Void) {
    var urn: String = ""
    var timeout = 15.0
    let body = NSMutableData()
    let values = params
    var contentType: String? = nil
    
    switch method {
    case "GET", "DELETE", "HEAD":
        if values.count > 0 {
            var toString: [String] = []
            values.forEach {
                if let v = $1 as? String {
                    toString.append("\($0)=\(v)")
                }
            }
            urn = "?" + toString.joined(separator: "&")
        }
    case "JSON":
        contentType = "application/json"
        if let json = params.jsonString() {
            body.appendString(json)
        }
    default:
        timeout = 30
        if values.count > 0 {
            let boundary = "iOS-\(UUID().uuidString)"
            contentType = "multipart/form-data; boundary=\(boundary)"
            for (key, value) in values {
                if let value = value {
                    body.appendString("--\(boundary)\r\nContent-Disposition: form-data; name=\"")
                    body.appendString("\(key)\"\r\n\r\n\(value)\r\n")
                }
            }
            body.appendString("--".appending(boundary.appending("--")))
        }
    }

    if let uri = URL(string: (url + endPoint + urn).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
        let session = URLSession.shared
        var request = URLRequest(url: uri)
        request.setValue("c0plj0748v6rvej4ou50", forHTTPHeaderField: "X-Finnhub-Token")
        request.httpMethod = method == "JSON" ? "POST" : method
        if let mime = contentType {
            request.setValue(mime, forHTTPHeaderField: "Content-Type")
            request.setValue("keep-alive", forHTTPHeaderField: "Connection")
            request.httpBody = body as Data
            request.timeoutInterval = timeout
        }

        let load = session.dataTask(with: request, completionHandler: { data, response, error in
            let status = response?.getStatus ?? 1000
            DispatchQueue.main.async{() -> Void in
                completion(data, status)
            }
        })
        load.resume()
    }
}

extension Dictionary {
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

extension URLResponse {
    var getStatus: Int? {
        get {
            if let httpResponse = self as? HTTPURLResponse {
                return httpResponse.statusCode
            }
            return nil
        }
    }
}
