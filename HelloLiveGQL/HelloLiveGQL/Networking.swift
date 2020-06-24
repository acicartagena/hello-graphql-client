//
//  Networking.swift
//  HelloLiveGQL
//
//  Created by Cartagena (Contractor) Angela on 24/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation
import LiveGQL

class Networking {
    
    let gql = LiveGQL(socket: "ws://localhost:4000/graphql")
    
    struct Subscription {
        enum SubscriptionType {
            case postAdded(eventHandler: (Result<PostAddedResponse, HelloLiveGQLError>) -> Void)
            
            var identifier: String {
                switch self {
                case .postAdded: return "PostAdded"
                }
            }
        }
        
        var identifier: String { type.identifier }
        let type: SubscriptionType
        let graphQL: String
        
        static func postAdded(graphQL: String, eventHandler: @escaping (Result<PostAddedResponse, HelloLiveGQLError>) -> Void) -> Subscription {
            return Subscription(graphQL: graphQL, type: .postAdded(eventHandler: eventHandler))
        }
        
        init(graphQL: String, type: SubscriptionType) {
            self.graphQL = graphQL
            self.type = type
        }
    }

    // this can be an array in the future to keep track of multiple subscriptions
   private var subscription: Subscription?
    
    init() {
        gql.delegate = self
        gql.initServer(connectionParams: nil, reconnect: true)
    }
    
    
    func subscribe(to subscription: Subscription) {
        self.subscription = subscription
        gql.subscribe(graphql: subscription.graphQL , variables: nil, operationName: nil, identifier: subscription.identifier)
    }
    
    func unsubscribe() {
        guard let subscription = subscription else { return }
        gql.unsubscribe(subscribtion: subscription.identifier)
    }
}

extension Networking: LiveGQLDelegate {
    func receivedRawMessage(text: String) {
        print("PostService: receivedRawMessage: text: \(text)")
        guard let obj = text.data(using: String.Encoding.utf8, allowLossyConversion: false),
            let postAddedSubscription = subscription,
            case let .postAdded(eventHandler) = postAddedSubscription.type else { return }
        do {
            let decoded = try JSONDecoder().decode(PostAddedResponse.self, from: obj)
            eventHandler(.success(decoded))
        } catch let error {
            eventHandler(.failure(.decoding(error)))
        }
        
    }
}
