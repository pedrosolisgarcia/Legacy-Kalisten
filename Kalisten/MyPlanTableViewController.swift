//
//  MyPlanTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 18/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class MyPlanTableViewController: UITableViewController {
    
    @IBOutlet var trainingButton: UIButton!
    @IBOutlet var nutriGoalButton: UIButton!
    @IBOutlet var trainingLabel: MarqueeLabel!
    @IBOutlet var nutritionLabel: MarqueeLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the backgroundColor property of the buttons to blue
        trainingButton.backgroundColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 1.0)
        nutriGoalButton.backgroundColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 1.0)
        trainingLabel.backgroundColor = UIColor.black
        nutritionLabel.backgroundColor = UIColor.black
        
        tableView.separatorColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
