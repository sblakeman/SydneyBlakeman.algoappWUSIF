//
//  HomeViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit
import SwiftUI


class HomeViewController: UIViewController {
    var data = LineGraphModel()
        
    private var strategies: [Strategy] {
        if let data = UserDefaults.standard.data(forKey: "Strategies") {
            if let decoded = try? JSONDecoder().decode([Strategy].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    @IBSegueAction func addGraph(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: LineGraphView().environmentObject(data))
    }
    
    
    @IBOutlet weak var graphView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HTableViewCell.nib(), forCellReuseIdentifier: HTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
                
        for strategy in strategies {
            if !data.ids.contains(where: { $0 == strategy.id }) {
                var charts: [ChartData] = []
                for ticker in strategy.selectedTickers {
                    getCharData(ticker: ticker) { data in
                        charts.append(data)
                    }
                }
                
                let minIndex = charts.first!.timestamp.firstIndex(of: charts.first!.timestamp.min { date_1, date_2 in
                    abs(date_1 - strategy.startTime.timeIntervalSince1970) < abs(date_2 - strategy.startTime.timeIntervalSince1970)
                }!)!
                
                let newChart = charts.map { chart in
                    chart.open.suffix(chart.open.count - minIndex).map { value in
                        (value - chart.open[minIndex]) / chart.open[minIndex] / 6.0
                    }
                }
                
                print(newChart)
                                
                var growthPercentage: [Double] = .init(repeating: 0.0, count: newChart.map{$0.count}.min()!)
                
                for chart in newChart {
                    for (index, value) in chart.suffix(growthPercentage.count).enumerated() {
                        growthPercentage[index] += value
                    }
                }
                
                let dates = charts.first!.timestamp.map { Date(timeIntervalSince1970: $0)}
                
         
                data.ids.append(strategy.id)
                data.data.append(zip(dates.suffix(growthPercentage.count), growthPercentage))
                data.label.append(strategy.title)
                
                print(data.data)
            }
        }
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
        let mainView = UIStoryboard(name:"Main", bundle: nil)
        let vc : MoreViewController = mainView.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        vc.strategy = strategies[indexPath.row]
        
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HTableViewCell.identifier, for: indexPath) as! HTableViewCell
        
        let strategy = strategies[indexPath.row]
        
        var charts: [ChartData] = []
        for (_, ticker) in strategy.selectedTickers.enumerated() {
            getCharData(ticker: ticker) { data in
                charts.append(data)
            }
        }
        let minIndex = charts.first!.timestamp.firstIndex(of: charts.first!.timestamp.min{ date_1, date_2 in abs(date_1 - strategy.startTime.timeIntervalSince1970) < abs(date_2 - strategy.startTime.timeIntervalSince1970)}!)!
        let percentageGrowth = charts.map { chart in
            (chart.open.last! - chart.open[minIndex]) / chart.open[minIndex]
        }.reduce(0.0, +) / 6
       

        
        if percentageGrowth > 0.0 {
            cell.configure(title: strategies[indexPath.row].title, imageName: Strategy.Trend.up.rawValue)
            cell.pic.image = cell.pic.image?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        } else if percentageGrowth < 0.0 {
            cell.configure(title: strategies[indexPath.row].title, imageName: Strategy.Trend.down.rawValue)
            cell.pic.image = cell.pic.image?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        } else {
            cell.configure(title: strategies[indexPath.row].title, imageName: Strategy.Trend.neutral.rawValue)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var strategies: [Strategy] = []
        
        if let decoded = try? JSONDecoder().decode([Strategy].self, from: UserDefaults.standard.data(forKey: "Strategies")!) {
            strategies = decoded
        }
        
        let id = strategies[indexPath.row].id
        if let dataIndex = data.ids.firstIndex(of: id)
        {
            data.ids.remove(at: dataIndex)
            data.data.remove(at: dataIndex)
            data.label.remove(at: dataIndex)
        }
        
        strategies.remove(at: indexPath.row)
        
        if let encoded = try? JSONEncoder().encode(strategies) {
            UserDefaults.standard.set(encoded, forKey: "Strategies")
        }
        
        self.tableView.reloadData()
    }
}
