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
    
    @IBAction func unwindToMyPlan(segue:UIStoryboardSegue){}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
