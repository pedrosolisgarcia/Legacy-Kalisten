//
//  WorkoutListTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 01/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class TrainingViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove the title of the back button
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        tableView.separatorColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Prevent from hiding the bar on swipe
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Load one by one the collection cells
        switch indexPath.row{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell1", for: indexPath) as! TrainingCollectionViewCell
            // Configure the cell...
            cell.strengthLabel.text = "STRENGTH"
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell2", for: indexPath) as! TrainingCollectionViewCell
            // Configure the cell...
            cell.conditioningLabel.text = "CONDITIONING"
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell3", for: indexPath) as! TrainingCollectionViewCell
            // Configure the cell...
            cell.cardioLabel.text = "CARDIO"
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell4", for: indexPath) as! TrainingCollectionViewCell
            // Configure the cell...
            cell.stretchingLabel.text = "STRETCHING"
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Configure the cell...
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell1") as! TrainingTableViewCell
            // Configure the cell...
            cell.planLabel.text = "TRAINING PLANS"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell2") as! TrainingTableViewCell
            // Configure the cell...
            cell.myWorkoutsLabel.text = "MY WORKOUTS"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell")
            return cell!
        }
    }
    
    //Automatically deselect the collection cell when touched
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //Automatically deselect the table cell when touched
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
