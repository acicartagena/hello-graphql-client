//
//  Networking.swift
//  HelloGraphQL
//
//  Created by Cartagena (Contractor) Angela on 25/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation
import Starscream

struct SubscriptionMessage: Codable {
    struct Payload: Codable {
        let query: String?
        static let empty: Payload = Payload(query: nil)
    }
    
    let id: String?
    let type: String?
    let payload: Payload
    
}

struct Subscription {
    enum SubscriptionType {
        case postAdded(eventHandler: (Result<PostAddedResponse, HelloGraphQLError>) -> Void)
        
        var identifier: String {
            switch self {
            case .postAdded: return "PostAdded"
            }
        }
    }
    
    var identifier: String { type.identifier }
    let type: SubscriptionType
    let graphQL: String
    
    static func postAdded(graphQL: String, eventHandler: @escaping (Result<PostAddedResponse, HelloGraphQLError>) -> Void) -> Subscription {
        return Subscription(graphQL: graphQL, type: .postAdded(eventHandler: eventHandler))
    }
    
    init(graphQL: String, type: SubscriptionType) {
        self.graphQL = graphQL
        self.type = type
    }
    
    func message(for type: String) -> SubscriptionMessage {
        let payload = SubscriptionMessage.Payload(query: graphQL)
        return SubscriptionMessage(id: identifier, type: type, payload: payload)
    }
}

class Networking {
    
    private let socket: WebSocket // is it only 1 socket?
    
    private var isConnected = false
    
    private var subscription: Subscription?
    
    private var writeQueue: [Data] = []
    
    init(socket url: URL = URL(string: "ws://localhost:4000/graphql")!) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.setValue("graphql-ws", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func subscribe(to subscription: Subscription) {
        let message = subscription.message(for: "start")
        self.subscription = subscription
        do {
            let data = try JSONEncoder().encode(message)
            guard isConnected else {
                writeQueue.append(data)
                return
            }
            socket.write(data: data)
            
        } catch let error {
            print(error)
        }
    }
    
    func unsubscribe() {
        guard let subscription = subscription else { return }
        let message = SubscriptionMessage(id: subscription.identifier, type: "stop", payload: SubscriptionMessage.Payload.empty)
        self.subscription = subscription
        do {
            let data = try JSONEncoder().encode(message)
            guard isConnected else {
                writeQueue.append(data)
                return
            }
            socket.write(data: data)
        } catch let error {
            print(error)
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
            guard let obj = string.data(using: String.Encoding.utf8, allowLossyConversion: false),
                let postAddedSubscription = subscription,
                case let .postAdded(eventHandler) = postAddedSubscription.type else { return }
            do {
                let decoded = try JSONDecoder().decode(PostAddedResponse.self, from: obj)
                eventHandler(.success(decoded))
            } catch let error {
                eventHandler(.failure(.decoding(error)))
            }
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
