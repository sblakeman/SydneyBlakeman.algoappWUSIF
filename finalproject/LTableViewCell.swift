//
//  LTableViewCell.swift
//  finalproject
//
//  Created by Sydney Blakeman on 7/30/22.
//

import UIKit

class LTableViewCell: UITableViewCell {

     static let identifier = "LTableViewCell"
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var growth: UILabel!
    static func nib() -> UINib {
        return UINib(nibName: "LTableViewCell", bundle: nil)
    }
    public func configure(thescore: String, title: String, imageName: String ){
        score.text = thescore
        growth.text = title
        pic.image = UIImage(systemName: imageName)
        
        
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
