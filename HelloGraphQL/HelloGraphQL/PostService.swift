//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.

import Foundation

enum HelloGraphQLError: Error {
    case networking(Error)
    case noData
    case decoding(Error)
}

extension Post {
    init(response: PostAddedResponse) {
        text = response.payload.data.postAdded.text
        author = response.payload.data.postAdded.author
    }
}

protocol PostActions {
    func fetchPosts(completion: @escaping(Result<[Post], HelloGraphQLError>) -> Void)
    func subsribeNewPosts(eventHandler: @escaping(Result<Post, HelloGraphQLError>) -> Void)
}

class PostService: PostActions {
    
    let networking = Networking()
    
    deinit {
        networking.unsubscribe()
    }
    
    func fetchPosts(completion: @escaping(Result<[Post], HelloGraphQLError>) -> Void) {
        completion(.success([]))
    }
    
    func subsribeNewPosts(eventHandler: @escaping(Result<Post, HelloGraphQLError>) -> Void) {
        let graphQL = """
                subscription PostAdded {
                    postAdded {
                        text
                        author
                    }
                }
                """
        let eventHandler: (Result<PostAddedResponse, HelloGraphQLError>) -> Void =  { result in
                   switch result {
                   case .success(let response):
                       eventHandler(.success(Post(response: response)))
                   case .failure(let error):
                       eventHandler(.failure(error))
                   }
               }
        let subscription = Subscription(graphQL: graphQL, type: .postAdded(eventHandler: eventHandler))
        
        networking.subscribe(to: subscription)
    }
}
