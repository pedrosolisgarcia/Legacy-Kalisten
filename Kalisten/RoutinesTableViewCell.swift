//
//  RoutinesTableViewCell.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class RoutinesTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var familyLabel: MarqueeLabel!
    @IBOutlet var improvesLabel: MarqueeLabel!
    @IBOutlet var numDayslLabel: MarqueeLabel!
    @IBOutlet var timeLabel: MarqueeLabel!
    @IBOutlet var levelLabel: MarqueeLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
