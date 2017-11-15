//
//  MyPlanTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 18/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class MyPlanTableViewController: UITableViewController {
    
    @IBOutlet weak var trainingButton: UIButton!
    @IBOutlet weak var nutriGoalButton: UIButton!
    @IBOutlet weak var trainingLabel: MarqueeLabel!
    @IBOutlet weak var nutritionLabel: MarqueeLabel!
    
    let navigationAndTabBarSize: CGFloat = 112
    
    @IBAction func unwindToMyPlan(segue:UIStoryboardSegue){}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = (self.view.frame.size.height - navigationAndTabBarSize)*0.5
        tableView.separatorColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
