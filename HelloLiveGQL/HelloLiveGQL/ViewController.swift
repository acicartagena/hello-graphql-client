//  Copyright © 2020 Cartagena (Contractor) Angela. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.estimatedRowHeight = 100.0
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    lazy var viewModel: ViewModel = {
       let viewModel = ViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.start()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier) as! PostCell
        let item = viewModel.items[indexPath.row]
        cell.setup(with: item)
        return cell
    }
}

extension ViewController: ViewModelDelegate {
    func reload() {
        tableView.reloadData()
    }
}
