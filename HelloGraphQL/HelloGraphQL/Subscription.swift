//
//  Subscription.swift
//  HelloGraphQL
//
//  Created by Cartagena (Contractor) Angela on 26/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation

struct PostAddedSubscriptionData: Decodable {
    struct PostAdded: Decodable {
        let text: String
        let author: String
    }
    
    let postAdded: PostAdded
}

struct EmptyStruct: Decodable { }

enum Subscription: GraphQLSubscription {
    case postAdded(messageHandler: (Result<PostAddedSubscriptionData, HelloGraphQLError>) -> Void)
    
    var identifier: String {
        switch self {
        case .postAdded: return "postAdded"
        }
    }
    
    func handle(message: Data) throws {
        let subscriptionIdentifier = try identifier(from: message)
        switch self {
        case .postAdded(let handler):
            guard subscriptionIdentifier == self.identifier else { return }
            let decoded = try JSONDecoder().decode(MessageResponse<PostAddedSubscriptionData>.self, from: message)
            handler(.success(decoded.payload.data))
        }
    }
    
    private func identifier(from message: Data) throws -> String? {
        let decodedContainer = try JSONDecoder().decode(MessageResponse<EmptyStruct>.self, from: message)
        return decodedContainer.id
    }
    
    func handle(error: Error) {
        switch self {
        case .postAdded(let handler):
            handler(.failure(.decoding(error)))
        }
    }
}

extension Subscription: Equatable {
    static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
