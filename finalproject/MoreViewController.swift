//
//  ViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit

class MoreViewController: UIViewController {
    
    var strategy: Strategy!
    
    @IBOutlet weak var strattitle: UILabel! {
        didSet {
            strattitle.text = strategy.title
        }
    }
    
    @IBOutlet weak var peratio: UILabel! {
        didSet {
            if let amount = strategy.peRatio  {
                peratio.text = String(amount)
            } else {
                peratio.text = "-"
            }
        }
    }
    
    @IBOutlet weak var pbvratio: UILabel! {
        didSet {
            if let amount = strategy.pBvRatio  {
                pbvratio.text = String(amount)
            } else {
                pbvratio.text = "-"
            }
        }
    }
    
    @IBOutlet weak var debttoeqratio: UILabel! {
        didSet {
            if let amount = strategy.deRatio  {
                debttoeqratio.text = String(amount)
            } else {
                debttoeqratio.text = "-"
            }
        }
    }
    
    
    @IBOutlet weak var pricesalesratio: UILabel! {
        didSet {
            if let amount = strategy.pricesalesratio  {
                pricesalesratio.text = String(amount)
            } else {
                pricesalesratio.text = "-"
            }
        }
    }
    
    @IBOutlet weak var roe: UILabel! {
        didSet {
            if let amount = strategy.roeRatio  {
                roe.text = String(amount)
            } else {
                roe.text = "-"
            }
        }
    }
    
 
    
    @IBOutlet weak var initialprice: UILabel! {
        didSet {
            initialprice.text = "$" + String(strategy.startAmount)
        }
    }
    @IBOutlet weak var label1: UILabel! {
        didSet {
            label1.text = strategy.selectedTickers[0]
        }
    }
    
    @IBOutlet weak var label2: UILabel! {
        didSet {
            label2.text = strategy.selectedTickers[1]
        }
    }
    
    @IBOutlet weak var label3: UILabel! {
        didSet {
            label3.text = strategy.selectedTickers[2]
        }
    }
    @IBOutlet weak var label4: UILabel! {
        didSet {
            label4.text = strategy.selectedTickers[3]
        }
    }
    
    @IBOutlet weak var label5: UILabel! {
        didSet {
            label5.text = strategy.selectedTickers[4]
        }
    }
    
    @IBOutlet weak var label6: UILabel! {
        didSet {
            label6.text = strategy.selectedTickers[5]
        }
    }
    
    var charts: [ChartData?] = .init(repeating: nil, count: 6)
    var totalGrowth = 0.0
    var currentPrice = 0.0
    
    @IBOutlet weak var growthLabel: UILabel! {
        didSet {
            growthLabel.text = totalGrowth.formatted(.currency(code: "USD"))
        }
    }
    
    @IBOutlet weak var currentPriceLabel: UILabel! {
        didSet {
            currentPriceLabel.text = currentPrice.formatted(.currency(code: "USD"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, ticker) in strategy.selectedTickers.enumerated() {
            getCharData(ticker: ticker) { data in
                self.charts[index] = data
            }
        }
                
        for (outerIndex, chart) in charts.enumerated() {
            if let chart = chart {
                let index = chart.timestamp.firstIndex(of: chart.timestamp.min { date_1, date_2 in
                    abs(date_1 - strategy.startTime.timeIntervalSince1970) < abs(date_2 - strategy.startTime.timeIntervalSince1970)
                }!)!
                let growth = (chart.open.last! - chart.open[index]) / chart.open[index] * strategy.startAmount / 6
                totalGrowth += growth
                
//                print(strategy.selectedTickers[outerIndex], "starts: ", chart.open[index])
//                print(strategy.selectedTickers[outerIndex], "ends: ", chart.open.last!)
            }
        }
        
        currentPrice = strategy.startAmount + totalGrowth
        
        growthLabel.text = totalGrowth.formatted(.currency(code: "USD"))
        currentPriceLabel.text = currentPrice.formatted(.currency(code: "USD"))
    }
}
