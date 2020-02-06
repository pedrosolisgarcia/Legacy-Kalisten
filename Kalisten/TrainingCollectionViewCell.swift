//
//  TrainingCollectionViewCell.swift
//  Kalisten
//
//  Created by Pedro Solís García on 06/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class TrainingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.lightGrey : UIColor.estonianBlue
        }
    }
}
