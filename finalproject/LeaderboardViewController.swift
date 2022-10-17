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
    
    private let topusers: [topStrategy] = [
        .init(title: "The Best Strat", startAmount: 10000, growth: 6, newAmount: 10600, pic: "img1.png", peRatio: true, pBvRatio: true, deRatio: true, pricesalesratio: false, roeRatio: false, companies: ["APPL","MSFT", "GOOG", "AMZN", "CVX", "HD"]),
        .init(title: "Top Strat", startAmount: 1000, growth: 5, newAmount: 1050, pic: "img2.png", peRatio: true, pBvRatio: true, deRatio: true, pricesalesratio: false, roeRatio: false, companies: ["APPL","NESN.SW", "JPM", "005930.KS", "CVX", "HD"]),

            .init(title: "Best Strat", startAmount: 10000, growth: 4.9, newAmount: 10490, pic: "img3.png", peRatio: true, pBvRatio: false, deRatio: false, pricesalesratio: false, roeRatio: false, companies: ["ORCL", "AZN", "OR.PA", "PRX.AS", "MCD", "VZ"]),
        .init(title: "My Strat", startAmount: 1000, growth: 4.8, newAmount: 1048, pic: "img4.png", peRatio: false, pBvRatio: true, deRatio: false, pricesalesratio: false, roeRatio: true, companies: ["ADBE", "ABT", "CSCO", "NVS", "CRM", "TMUS"]),
        .init(title: "COOL Strat", startAmount: 1000, growth: 4.7, newAmount: 1047, pic: "img5.png", peRatio: false, pBvRatio: true, deRatio: false, pricesalesratio: false, roeRatio: true, companies: ["INTC", "LIN", "MS", "RMS.PA", "601288.SS", "3690.HK"]),
        .init(title: "Another Strat", startAmount: 10000, growth: 4.5, newAmount: 10450, pic: "img6.png", peRatio: true, pBvRatio: true, deRatio: false, pricesalesratio: false, roeRatio: true, companies: ["RMS.PA", "601288.SS", "3690.HK", "UNP", "RTX", "HKD"]),
        .init(title: "My Strat!", startAmount: 10000, growth: 4.3, newAmount: 10430, pic: "img7.png", peRatio: true, pBvRatio: true, deRatio: false, pricesalesratio: true, roeRatio: true, companies: ["NVO", "BABA", "ABBV", "PEP", "COST", "TMO"]),
        .init(title: "Algo!", startAmount: 1000, growth: 4.2, newAmount: 1042, pic: "img8.png", peRatio: true, pBvRatio: true, deRatio: true, pricesalesratio: true, roeRatio: true, companies: ["300750.SZ", "SHEL", "ADBE", "ABT", "CSCO", "NVS"]),
        .init(title: "The algo!", startAmount: 1000, growth: 4.0, newAmount: 1040, pic: "img9.png", peRatio: true, pBvRatio: true, deRatio: true, pricesalesratio: false, roeRatio: true, companies: ["CMCSA", "WFC", "TXN", "601939.SS", "BMY", "AMD"]),
        .init(title: "Best algo", startAmount: 1000, growth: 3.8, newAmount: 1038, pic: "img10.png", peRatio: true, pBvRatio: true, deRatio: false, pricesalesratio: false, roeRatio: true, companies: ["RMS.PA", "601288.SS", "3690.HK", "UNP", "RTX", "AAPL"])
        
        
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
        vc.topstrategy = topusers[indexPath.row]
        self.present(vc, animated: true, completion:nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: LTableViewCell.identifier, for: indexPath) as! LTableViewCell
            cell.configure(thescore: "#" + String(indexPath.row + 1), title: "Growth: " + String(topusers[indexPath.row].growth) + "%", imageName: topusers[indexPath.row].pic)
        
        return cell
        
     
    }
    
}
