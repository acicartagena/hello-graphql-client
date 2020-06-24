//
//  PostAddedResponse.swift
//  HelloLiveGQL
//
//  Created by Cartagena (Contractor) Angela on 24/6/20.
//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.
//

import Foundation

struct PostAddedResponse: Decodable {
    struct Payload: Decodable {
        struct Data: Decodable {
            struct PostAdded: Decodable {
                let text: String
                let author: String
            }
            
            let postAdded: PostAdded
        }
        
        let data: Data
    }
    
    let type: String
    let id: String
    let payload: Payload
}
