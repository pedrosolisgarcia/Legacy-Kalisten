//
//  TrainingCollectionViewCell.swift
//  Kalisten
//
//  Created by Pedro Solís García on 06/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class TrainingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var strengthLabel: UILabel!
    @IBOutlet var conditioningLabel: UILabel!
    @IBOutlet var cardioLabel: UILabel!
    @IBOutlet var stretchingLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5) : UIColor.white
        }
    }

}
