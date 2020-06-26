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

enum Subscription: Equatable {
    case postAdded(messageHandler: (Result<PostAddedSubscriptionData, HelloGraphQLError>) -> Void)
    
    var identifier: String {
        switch self {
        case .postAdded: return "postAdded"
        }
    }
    
    static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func handle(message: Data) throws {
        switch self {
        case .postAdded(let handler):
            let decoded = try JSONDecoder().decode(PostAddedSubscriptionData.self, from: message)
            handler(.success(decoded))
        }
    }
    
    func handle(error: Error) {
        switch self {
        case .postAdded(let handler):
            handler(.failure(.decoding(error)))
        }
    }
}
