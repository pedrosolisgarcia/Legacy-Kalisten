//
//  ExerciseDetailTableViewCell.swift
//  Kalisten
//
//  Created by Pedro Solís García on 09/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ExerciseDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueText: UITextField!
    
    @IBOutlet var fieldLabel0: UILabel!
    @IBOutlet var valueText0: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
