//
//  TopMoreViewController.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit
import SwiftUI

class TopMoreViewController: UIViewController {
    
    var topstrategy: topStrategy!
    
    @IBOutlet weak var peratio: UIImageView!
    
    @IBOutlet weak var pbvratio: UIImageView!
    
    @IBOutlet weak var dtoeratio: UIImageView!
    
    @IBOutlet weak var psratio: UIImageView!
    
    @IBOutlet weak var roeratio: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setimages()

        // Do any additional setup after loading the view.
    }
    func setimages (){
        if topstrategy!.peRatio == true{
            peratio.image = UIImage(systemName: "checkmark")
            peratio.tintColor = .green
            
        }
        else{
            peratio.image = UIImage(systemName: "x.square")
            peratio.tintColor = .red
        
            
        }
        if topstrategy!.pBvRatio == true{
            pbvratio.image = UIImage(systemName: "checkmark")
            pbvratio.tintColor = .green
           
            
        }
        else{
            pbvratio.image = UIImage(systemName:  "x.square")
            pbvratio.tintColor = .red
           
        }
        if topstrategy!.deRatio == true{
            dtoeratio.image = UIImage(systemName: "checkmark")
            dtoeratio.tintColor = .green
        
            
        }
        else{
            dtoeratio.image = UIImage(systemName: "x.square")
            dtoeratio.tintColor = .red
            
        }
        if topstrategy!.pricesalesratio == true{
            psratio.image = UIImage(systemName: "checkmark")
            psratio.tintColor = .green
           
            
        }
        else{
            psratio.image = UIImage(systemName: "x.square")
            psratio.tintColor = .red
            
        }
        if topstrategy!.roeRatio == true{
            roeratio.image = UIImage(systemName: "checkmark")
            roeratio.tintColor = .green
        
            
        }
        else{
            roeratio.image = UIImage(systemName:"x.square")
            roeratio.tintColor = .red
            
        }
    }
    @IBOutlet weak var growth: UILabel!{
        didSet{
            growth.text = String(topstrategy!.growth) + "%"
        }
    }
    
    @IBOutlet weak var initial: UILabel!{
        didSet{
            initial.text = String(topstrategy!.startAmount)
        }
    }
    
    @IBOutlet weak var newprice: UILabel!{
        didSet{
            newprice.text = String(topstrategy!.newAmount)
        }
    }
    
    @IBOutlet weak var label1: UILabel!{
        didSet{
            label1.text = String(topstrategy!.companies[0])
        }
    }
    
    @IBOutlet weak var label2: UILabel!{
        didSet{
            label2.text = String(topstrategy!.companies[1])
        }
    }
    
    @IBOutlet weak var label3: UILabel!{
        didSet{
            label3.text = String(topstrategy!.companies[2])
        }
    }
    @IBOutlet weak var label4: UILabel!{
        didSet{
            label4.text = String(topstrategy!.companies[3])
        }
    }
    
    @IBOutlet weak var label5: UILabel!{
        didSet{
            label5.text = String(topstrategy!.companies[4])
        }
    }
    @IBOutlet weak var label6: UILabel!{
        didSet{
            label6.text = String(topstrategy!.companies[5])
        }
    }
    @IBOutlet weak var stratName: UILabel!{
        didSet{
            stratName.text = String(topstrategy!.title)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
