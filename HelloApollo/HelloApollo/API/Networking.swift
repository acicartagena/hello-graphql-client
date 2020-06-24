//
//  Networking.swift
//  HelloApollo
//
//  Created by Cartagena (Contractor) Angela on 23/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation
import Apollo
import ApolloWebSocket

class Network {
    static let shared = Network()
    
    // Configure the network transport to use the singleton as the delegate.
    private lazy var networkTransport: SplitNetworkTransport = {
        let http = HTTPNetworkTransport(url: URL(string: "http://localhost:4000/graphql")!)
        let sockets = WebSocketTransport(request: URLRequest(url: URL(string:"ws://localhost:4000/graphql")!))
        let transport = SplitNetworkTransport(httpNetworkTransport: http, webSocketNetworkTransport: sockets)
        http.delegate = self
        return transport
    }()
    
    private(set) lazy var apollo = ApolloClient(networkTransport: networkTransport)
    
}

extension Network: HTTPNetworkTransportDelegate {
    
}
