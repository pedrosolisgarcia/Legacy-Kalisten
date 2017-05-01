//
//  WorkoutsTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 30/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class WorkoutsTableViewController: UITableViewController {
    
    //Array to store the workouts from Parse as objects
    private var workouts = [Workout]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWorkoutsFromParse()
        
        //Hide the navigation bar when scrolling down
        navigationController?.hidesBarsOnSwipe = true
        
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the bar on swipe
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! WorkoutsTableViewCell
        
        // Configure the cell
        cell.nameLabel.text = workouts[indexPath.row].name.uppercased()
        cell.familyLabel.text = workouts[indexPath.row].family.uppercased()
        let arrayTarjet:NSArray = workouts[indexPath.row].tarjets as NSArray
        cell.tarjetLabel.text = arrayTarjet.componentsJoined(by: ", ").uppercased()
        cell.numExlLabel.text = "EXERCISES: \(workouts[indexPath.row].numEx)"
        cell.timeLabel.text = "TIME: \(workouts[indexPath.row].totalTime)MIN"
        cell.levelLabel.text = difficultyLevel(difficulty: workouts[indexPath.row].difficulty)
        
        tableView.separatorColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.3)

        return cell
    }
    
    func difficultyLevel(difficulty: Int)-> String {
        
        var diffLevel = ""
        
        switch difficulty {
        case 1: diffLevel = "SUPER EASY"
        case 2: diffLevel = "VERY EASY"
        case 3: diffLevel = "EASY"
        case 4: diffLevel = "NORMAL"
        case 5: diffLevel = "CHALLENGING"
        case 6: diffLevel = "HARD"
        case 7: diffLevel = "VERY HARD"
        case 8: diffLevel = "SUPER HARD"
        case 9: diffLevel = "PROFESSIONAL"
        case 10: diffLevel = "OLYMPIC"
        default:
            diffLevel = "DIFFICULTY"
        }
        
        return diffLevel
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! WorkoutsTableViewCell
        
        cell.nameLabel.restartLabel()
        cell.familyLabel.restartLabel()
        cell.tarjetLabel.restartLabel()
        cell.timeLabel.restartLabel()
        cell.numExlLabel.restartLabel()
        cell.levelLabel.restartLabel()
        for cell in tableView.visibleCells as! [WorkoutsTableViewCell] {
            cell.nameLabel.restartLabel()
            cell.familyLabel.restartLabel()
            cell.tarjetLabel.restartLabel()
            cell.timeLabel.restartLabel()
            cell.numExlLabel.restartLabel()
            cell.levelLabel.restartLabel()
        }
    }
    
    //Prepare data from the selected workout to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showWorkoutDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                let destinationController = segue.destination as! WorkoutDetailViewController
                
                destinationController.workout =  workouts[indexPath.row]
            }
        }
    }
    
    // MARK: Parse-related methods
    
    func loadWorkoutsFromParse() {
        // Clear up the array
        workouts.removeAll(keepingCapacity: false)
        tableView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Workout")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    // Convert PFObject into Workout object
                    let workout = Workout(pfObject: object)
                    self.workouts.append(workout)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                }
                //fixes the issue in which the last element had the labels without the info.<<<
                self.tableView.reloadData()
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
