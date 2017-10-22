//
//  ExercisesTableViewCell.swift
//  Kalisten
//
//  Created by Pedro Solís García on 21/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ExercisesTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var tarjetLabel: MarqueeLabel!
    @IBOutlet var pqLabel: MarqueeLabel!
    @IBOutlet var levelLabel: MarqueeLabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            self.contentView.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
            self.nameLabel.textColor = UIColor.white
            self.tarjetLabel.textColor = UIColor.white
            self.pqLabel.textColor = UIColor.white
            self.levelLabel.textColor = UIColor.white
        }
        else {
            self.nameLabel.textColor = UIColor.black
            self.tarjetLabel.textColor = UIColor.black
            self.pqLabel.textColor = UIColor.black
            self.levelLabel.textColor = UIColor.black

        }
    }
}
