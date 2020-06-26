//
//  SubscriptionRequest.swift
//  HelloGraphQL
//
//  Created by Cartagena (Contractor) Angela on 26/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation

struct MessageRequest: Encodable, GQLMessage {
    struct QueryPayload: Codable {
        let query: String?
    }
    
    let id: String?
    let type: GQLMessageTypes
    let payload: QueryPayload
}

extension MessageRequest {
    init(id: String?, type: GQLMessageTypes, query: String?) {
        self.id = id
        self.type = type
        self.payload = QueryPayload(query: query)
    }
}

struct MessageResponse<T: Decodable>: Decodable, GQLMessage {
    struct ResponsePayload<T: Decodable>: Decodable {
        let data: T
    }

    let id: String?
    let type: GQLMessageTypes
    let payload: ResponsePayload<T>
}

enum GQLMessageTypes: String, Codable {
    case connectionInit = "connection_init"
    case connectionAck = "connection_ack"
    case connectionError = "connection_error"
    case connectionKeepAlive = "ka"
    case connectionTerminate = "connection_terminate"
    case start = "start"
    case data = "data"
    case error = "error"
    case complete = "complete"
    case stop = "stop"
}

protocol GQLMessage {
    associatedtype Payload
    var id: String? { get }
    var type: GQLMessageTypes { get }
    var payload: Payload { get }
}
