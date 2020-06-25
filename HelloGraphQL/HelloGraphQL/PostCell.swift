//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}

struct PostCellViewModel {
    private let post: Post
    
    var labelText: String {
        return "\(post.author): \(post.text)"
    }
    
    init(post: Post) {
        self.post = post
    }
}

class PostCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with viewModel: PostCellViewModel) {
        label.text = viewModel.labelText
    }

}
