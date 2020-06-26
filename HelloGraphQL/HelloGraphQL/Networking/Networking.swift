//
//  Networking.swift
//  HelloGraphQL
//
//  Created by Cartagena (Contractor) Angela on 25/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation
import Starscream

class Networking {
    
    private let socket: WebSocket
    private var isConnected = false
    private var writeQueue: [Data] = []
    
    private var subscriptions: [Subscription] = []
    
    init(socket url: URL = URL(string: "ws://localhost:4000/graphql")!) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.setValue("graphql-ws", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func subscribe(to subscription: Subscription, with graphQL: String) {
        let request = MessageRequest(id: subscription.identifier, type: .start, query: graphQL)
        subscriptions.append(subscription)
        send(request: request)
    }
    
    func unsubscribe(from subscription: Subscription) {
        let request = MessageRequest(id: subscription.identifier, type: .stop, query: nil)
        subscriptions.removeAll { $0 == subscription }
        send(request: request)
    }
    
    private func send(request: MessageRequest) {
        do {
            let data = try JSONEncoder().encode(request)
            guard isConnected else {
                writeQueue.append(data)
                return
            }
            socket.write(data: data)
        } catch let error {
            print(error)
        }
    }
    
    private func processReceived(text: String) {
        guard let obj = text.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
        
        for subscription in subscriptions {
            do {
                try subscription.handle(message: obj)
            } catch let error {
                subscription.handle(error: error)
            }
        }
    }
}

extension Networking: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket connected with headers: \(headers)")
            
            if !writeQueue.isEmpty {
                for data in writeQueue {
                    socket.write(data: data)
                }
                writeQueue.removeAll()
            }
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("received text: \(string)")
            processReceived(text: string)
        case .binary(let data):
            print("received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print("error \(String(describing: error))")
        }
    }
}
