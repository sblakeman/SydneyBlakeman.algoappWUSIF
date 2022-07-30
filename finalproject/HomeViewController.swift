//
//  HomeViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit

struct Strategy {
    let title: String
    let trend: Trend
    
    enum Trend: String {
        case up = "arrow.up"
        case down = "arrow.down"
        case neutral = "circle.and.line.horizontal"
    }
}

class HomeViewController: UIViewController {
    
    private let strategies: [Strategy] = [
        .init(title: "Title A", trend: .up),
        .init(title: "Title B", trend: .down),
        .init(title: "Title C", trend: .up),
        .init(title: "Title D", trend: .neutral),
        .init(title: "Title E", trend: .down)
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strategies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                return cell
            }()
            
        cell.textLabel?.text = strategies[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: strategies[indexPath.row].trend.rawValue)
        return cell
    }
    
    
}
