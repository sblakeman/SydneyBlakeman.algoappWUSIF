//
//  HTableViewCell.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit

class HTableViewCell: UITableViewCell {
    static let identifier = "HTableViewCell"
    
    @IBOutlet weak var strat: UILabel!
    
    @IBOutlet weak var pic: UIImageView!
    
    static func nib() -> UINib {
        return UINib(nibName: "HTableViewCell", bundle: nil)
    }
    
    public func configure(title: String, imageName: String ){
        pic.image = UIImage(systemName: imageName)
        strat.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
