//
//  AddViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

//this file for dates 
import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var startingamount: UISegmentedControl!
    
    @IBOutlet weak var peratio: UITextField!
    @IBOutlet weak var peswitch: UISwitch!
    
    @IBOutlet weak var pbvratio: UITextField!
    @IBOutlet weak var pbvswitch: UISwitch!
    
    @IBOutlet weak var debttoeqratio: UITextField!
    @IBOutlet weak var debttoeqswitch: UISwitch!
    
    @IBOutlet weak var currratio: UITextField!
    @IBOutlet weak var currswitch: UISwitch!
    
    @IBOutlet weak var roe: UITextField!
    @IBOutlet weak var roeswitch: UISwitch!
    


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func peSwitchAction(_ sender: Any) {
        peratio.isUserInteractionEnabled = peswitch.isOn
        peratio.text = peswitch.isOn ? peratio.text : ""
    }

    @IBAction func pbvSwitchAction(_ sender: Any) {
        pbvratio.isUserInteractionEnabled = pbvswitch.isOn
        pbvratio.text = pbvswitch.isOn ? pbvratio.text : ""
    }

    @IBAction func debttoeqSwitchAction(_ sender: Any) {
        debttoeqratio.isUserInteractionEnabled = debttoeqswitch.isOn
        debttoeqratio.text = debttoeqswitch.isOn ? debttoeqratio.text : ""
    }

    @IBAction func currSwitchAction(_ sender: Any) {
        currratio.isUserInteractionEnabled = currswitch.isOn
        currratio.text = currswitch.isOn ? currratio.text : ""
    }

    @IBAction func rowSwitchAction(_ sender: Any) {
        roe.isUserInteractionEnabled = roeswitch.isOn
        roe.text = roeswitch.isOn ? roe.text : ""
    }

    
    @IBAction func deploy(_ sender: Any) {
        let amounts: [Double] = [1000, 10000]
        let startingAmount = amounts[startingamount.selectedSegmentIndex]
        
        let peRatio: Double? = Double(peratio.text ?? "")
        let pBvRatio: Double? = Double(pbvratio.text ?? "")
        let deRatio: Double? = Double(debttoeqratio.text ?? "")
        let pricesalesratio: Double? = Double(currratio.text ?? "")
        let roeRatio: Double? = Double(roe.text ?? "")
        
        let targets: [Double?] = [
            peRatio,
            pBvRatio,
            deRatio,
            pricesalesratio,
            roeRatio
        ]
        
        var stockData: [DateComponents:[String:[Double]]]!
        
        let today = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: .now)
        // this as well
        if let data = UserDefaults.standard.data(forKey: "StockData") {
            do {
                let decoder = JSONDecoder()
                decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")
                stockData = try decoder.decode([DateComponents:[String:[Double]]].self, from: data)
            } catch {
                print(error)
            }
        } else {
            print("database not found")
            stockData = .init()
        }
        
        for stock in StockData.stocks {
            if (stockData[today] == nil){
                stockData[today] = .init()
            }
            if let _ = stockData[today]?[stock] {
                print("Today data for \(stock) found")
            } else {
                print("Getting data for \(stock) from online")
                let data = QuoteData.getExtractedData(ticker: stock)
                
                stockData[today]?[stock] = data
            }
        }
        do {
            let encoder = JSONEncoder()
            encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")
            let encoded = try encoder.encode(stockData)
            UserDefaults.standard.set(encoded, forKey: "StockData")
        } catch {
            print(error)
        }

        let normalizedData: [String:Double] = StockData.stocks
            .map{
                return ($0, QuoteData.getNormalizedData(source: stockData[today]![$0]!, targets: targets))
            }
            .reduce(into: [String:Double]()) { dict, result in
                dict[result.0] = result.1.isNaN ? .infinity : result.1
            }

        let zippedData: [(Double, String)] = Array(normalizedData.keys
            .map { (normalizedData[$0]!, String($0)) })

        let sortedData = zippedData
            .sorted(by: { a, b in a.0 < b.0 })

        let selectedStocks = sortedData[0..<6]
            .map{ $0.1 }

        print(sortedData)
        print(selectedStocks)

        var strategies: [Strategy] = []
        if let data = UserDefaults.standard.data(forKey: "Strategies") {
            if let decoded = try? JSONDecoder().decode([Strategy].self, from: data) {
                strategies = decoded
            } else {
                strategies = []
            }
        }

        let strategy = Strategy(
            id: UUID(),
            startTime: .now.addingTimeInterval(-864000),
            
            // this needs to be manipulated
            title: "Strategy \(strategies.count + 1)",
            startAmount: startingAmount,
            peRatio: peRatio,
            pBvRatio: pBvRatio,
            deRatio: deRatio,
            pricesalesratio: pricesalesratio,
            roeRatio: roeRatio,
            selectedTickers: selectedStocks
        )
        strategies.append(strategy)

        if let encoded = try? JSONEncoder().encode(strategies) {
            UserDefaults.standard.set(encoded, forKey: "Strategies")
        }
    }
}

extension Array where Element : FloatingPoint {
    func stddev() -> Element {
        let sum = self.reduce(Element.zero, +)
        let mu = sum / Element(self.count)
        let stddev2 = self.reduce(Element.zero) { $0 + ($1 - mu) * ($1 - mu) } / Element(self.count)
        return sqrt(stddev2)
    }
}
