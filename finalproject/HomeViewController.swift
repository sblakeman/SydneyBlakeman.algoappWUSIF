//
//  HomeViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit


class HomeViewController: UIViewController {
    
    private var strategies: [Strategy] {
        if let data = UserDefaults.standard.data(forKey: "Strategies") {
            if let decoded = try? JSONDecoder().decode([Strategy].self, from: data) {
                return decoded
            }
        }
        return []
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HTableViewCell.nib(), forCellReuseIdentifier: HTableViewCell.identifier)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strategies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  mainView = UIStoryboard(name:"Main", bundle: nil)
        let vc : MoreViewController = mainView.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        vc.strategy = strategies[indexPath.row]

        self.present(vc, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HTableViewCell.identifier, for: indexPath) as! HTableViewCell
        cell.configure(title: strategies[indexPath.row].title, imageName: strategies[indexPath.row].trend.rawValue)

        return cell
    }
    
    
}
