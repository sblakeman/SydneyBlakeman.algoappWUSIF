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
    
    
    @IBOutlet weak var currentratio: UILabel! {
        didSet {
            if let amount = strategy.curRatio  {
                            currentratio.text = String(amount)
                        } else {
                            currentratio.text = "-"
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
    
    @IBOutlet weak var mingrow: UILabel! {
        didSet {
            if let amount = strategy.minRatio  {
                            mingrow.text = String(amount)
                        } else {
                            mingrow.text = "-"
                        }
        }
    }
    
    @IBOutlet weak var initialprice: UILabel! {
        didSet {
            initialprice.text = "$" + String(strategy.startAmount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
