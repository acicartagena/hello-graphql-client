//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.

import Foundation

protocol ViewModelDelegate: AnyObject {
    func reload()
}

class ViewModel {
    weak var delegate: ViewModelDelegate?
 
    var items: [PostCellViewModel] = []
    private let actions: PostActions
    
    init(actions: PostActions = PostService()) {
        self.actions = actions
    }
    
    func start() {
        actions.fetchPosts { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.items = posts.map { PostCellViewModel(post: $0) }
                self.delegate?.reload()
            case .failure(let error):
                print(error)
            }
        }
        
        actions.subsribeNewPosts { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let post):
                self.items.insert(PostCellViewModel(post: post), at: 0)
                self.delegate?.reload()
            case .failure(let error):
                print(error)
            }
        }
    }
}
