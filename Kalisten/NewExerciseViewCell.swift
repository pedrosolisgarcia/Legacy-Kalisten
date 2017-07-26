//
//  NewExerciseViewCell.swift
//  Kalisten
//
//  Created by Pedro Solís García on 18/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class NewExerciseViewCell: UITableViewCell {

    var difficulties = [String]()
    var difficulty = 0

    @IBOutlet weak var pickDifficulty: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        difficulties = ["0","1","2","3","4","5","6","7","8","9","10"]
        pickDifficulty.delegate = self
        pickDifficulty.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NewExerciseViewCell : UIPickerViewDataSource , UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficulties.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let diffLabel = UILabel()
        var diffData: String!
        
        diffData = difficulties[row]
        diffLabel.textAlignment = .center
        let myDiff = NSAttributedString(string: diffData, attributes: [NSFontAttributeName:UIFont(name: "AvenirNextCondensed-Medium", size: 29)!])
        diffLabel.attributedText = myDiff
        
        return diffLabel
    }
    
    //Sets the space between elements by changing the row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        difficulty = Int(difficulties[row])!
    }
}
