//
//  AddViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

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
    
    @IBOutlet weak var mingrowth: UITextField!
    @IBOutlet weak var mingrowthswitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func deploy(_ sender: Any) {
        let amounts: [Double] = [1000, 10000]
        let startingAmount = amounts[startingamount.selectedSegmentIndex]
        
        let peRatio: Double? = Double(peratio.text ?? "")
        let pBvRatio: Double? = Double(pbvratio.text ?? "")
        let deRatio: Double? = Double(debttoeqratio.text ?? "")
        let curRatio: Double? = Double(currratio.text ?? "")
        let roeRatio: Double? = Double(roe.text ?? "")
        let minRatio: Double? = Double(mingrowth.text ?? "")
        
        var strategies: [Strategy] = []
        if let data = UserDefaults.standard.data(forKey: "Strategies") {
            if let decoded = try? JSONDecoder().decode([Strategy].self, from: data) {
                strategies = decoded
            } else {
                strategies = []
            }
        }
        
        let strategy = Strategy(
            title: "Strategy \(strategies.count + 1)",
            startAmount: startingAmount,
            peRatio: peRatio,
            pBvRatio: pBvRatio,
            deRatio: deRatio,
            curRatio: curRatio,
            roeRatio: roeRatio,
            minRatio: minRatio
        )
        strategies.append(strategy)
        
        if let encoded = try? JSONEncoder().encode(strategies) {
            UserDefaults.standard.set(encoded, forKey: "Strategies")
        }
    }
}
