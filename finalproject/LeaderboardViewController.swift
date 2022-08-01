//
//  LeaderboardViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit

struct top{
    let growth: String
    let pic = "circle"
}

class LeaderboardViewController: UIViewController {
    
    private let topusers: [top] = [
        .init(growth: "4"),
        .init(growth: "1"),
        .init(growth: "5"),
        .init(growth: "2"),
        .init(growth: "4"),
        .init(growth: "2"),
        .init(growth: "3")
    ]

    @IBOutlet weak var leaderboard: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboard.register(LTableViewCell.nib(), forCellReuseIdentifier: LTableViewCell.identifier)
        leaderboard.dataSource = self
        leaderboard.delegate = self
        // Do any additional setup after loading the view.
    }
    


}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topusers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  mainView = UIStoryboard(name:"Main", bundle: nil)
        let vc : TopMoreViewController = mainView.instantiateViewController(withIdentifier: "TopMoreViewController") as! TopMoreViewController

        self.present(vc, animated: true, completion:nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: LTableViewCell.identifier, for: indexPath) as! LTableViewCell
            cell.configure(thescore: "#" + String(indexPath.row + 1), title: "Growth: " + topusers[indexPath.row].growth, imageName: topusers[indexPath.row].pic)
        
        return cell
        
     
    }
    
}
