//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.

import Foundation
import Apollo

enum HelloApolloError: Error {
    case networking(Error)
    case noData
}

extension HelloApollo.Post {
    init?(apiPost: PostQuery.Data.Post?) {
        guard let post = apiPost,
            let text = post.text,
            let author = post.author else { return nil }
        self.text = text
        self.author = author
    }
    
    init?(subscriptionPost: PostAddedSubscription.Data.PostAdded?) {
        guard let post = subscriptionPost,
            let text = post.text,
            let author = post.author else { return nil }
            self.text = text
            self.author = author
    }
}

protocol PostActions {
    func fetchPosts(completion: @escaping(Result<[HelloApollo.Post], HelloApolloError>) -> Void)
    func subsribeNewPosts(eventHandler: @escaping(Result<HelloApollo.Post, HelloApolloError>) -> Void)
}

class PostService: PostActions {
    private var subscription: Cancellable?
    
    deinit {
        subscription?.cancel()
    }
    
    func fetchPosts(completion: @escaping(Result<[HelloApollo.Post], HelloApolloError>) -> Void) {
        Network.shared.apollo.fetch(query: PostQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                let posts: [HelloApollo.Post]? = graphQLResult.data?.posts?.reversed().compactMap { HelloApollo.Post(apiPost: $0)}
                completion(.success( posts ?? []))
                print("Success! Result: \(graphQLResult)")
            case .failure(let error):
                print("Failure! Error: \(error)")
                completion(.failure(.networking(error)))
            }
        }
    }
    
    func subsribeNewPosts(eventHandler: @escaping(Result<HelloApollo.Post, HelloApolloError>) -> Void) {
        subscription = Network.shared.apollo.subscribe(subscription: PostAddedSubscription()) { result in
              switch result {
              case .success(let graphQLResult):
                print("Success! Result: \(graphQLResult)")
                guard let post = HelloApollo.Post(subscriptionPost: graphQLResult.data?.postAdded) else {
                    eventHandler(.failure(.noData))
                    return
                }
                eventHandler(.success(post))
              case .failure(let error):
                print("Failure! Error: \(error)")
                eventHandler(.failure(.noData))
              }
        }
    }
}
