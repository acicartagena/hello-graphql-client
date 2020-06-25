//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.

import Foundation

enum HelloGraphQLError: Error {
    case networking(Error)
    case noData
}


protocol PostActions {
    func fetchPosts(completion: @escaping(Result<[Post], HelloGraphQLError>) -> Void)
    func subsribeNewPosts(eventHandler: @escaping(Result<Post, HelloGraphQLError>) -> Void)
}

class PostService: PostActions {
    
    
    func fetchPosts(completion: @escaping(Result<[Post], HelloGraphQLError>) -> Void) {
        completion(.success([]))
    }
    
    func subsribeNewPosts(eventHandler: @escaping(Result<Post, HelloGraphQLError>) -> Void) {
    }
}
