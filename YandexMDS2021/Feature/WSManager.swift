//
//  WSManager.swift
//  YandexMDS2021
//
//  Created by Sergey Kotov on 16.02.2021.
//

import Foundation

protocol WSManagerDelegate: class {
    func didReceive(_ manager: WSManager, receivedData data: Data?)
}

class WSManager {
    
    public static let shared = WSManager()
    private init(){}
    
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://ws.finnhub.io?token=c0plj0748v6rvej4ou50")!)
    private var timer: Timer?
    private var receivedData: Data?
    var timeInterval: TimeInterval = 2
    weak var delegate: WSManagerDelegate?
    
    func connect() {
        webSocketTask.resume()
        setupTimeInterval()
        ping()
        subscribe()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
        timer?.invalidate()
    }
    
    private func subscribe() {
        ["AAPL", "GOOGL", "AMZN", "BAC", "MSFT", "TSLA", "MA", "BINANCE:BTCUSDT", "BINANCE:ETHUSDT", "IC MARKETS:1"].forEach {
            send(message: "{\"type\":\"subscribe\",\"symbol\":\"\($0)\"}")
        }
    }
    
    private func setupTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(receiveData),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket - не удалось отправить сообщение: \(error)")
            }
        }
    }
    
    func ping() {
        webSocketTask.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
                    self.ping()
                }
            }
        }
    }
    
    @objc func receiveData() {
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
//                    print(text)
                    self.receivedData = text.data(using: .utf8)
                case .data(let data):
                    self.receivedData = data
                default:
                    break
                }
            case .failure(let error):
                print("WebSocket - ошибка получения данных: \(error)")
            }
            DispatchQueue.main.async {
                self.delegate?.didReceive(self, receivedData: self.receivedData)
            }
        }
    }
}
