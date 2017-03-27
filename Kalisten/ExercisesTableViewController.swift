//
//  ExercisesTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 21/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class ExercisesTableViewController: UITableViewController {
    
    //Array containing objects of exercises
    /*var exercises: [Exercise] = [
        Exercise(name: "Push-Up", type: "Workout", family: "Push-Up", place: "Floor, Rings, Parallel Bars, Bar", pq: "Dynamic Strength, Mobility", object: "", image: "PushUp", difficulty: 2, tarjets: "Chest, Shoulders, Triceps, Core", text: "", isCreated: false),
        Exercise(name: "Pull-Up", type: "Workout", family: "Pull-Up", place: "Bar, Parallel Bars, Rings", pq: "Dynamic Strength, Mobility", object: "Bar", image: "PushUp", difficulty: 4, tarjets: "Lats, Biceps, Core", text: "", isCreated: false),
        Exercise(name: "Plank", type: "Workout", family: "Plank", place: "Floor", pq: "Isometric Strength", object: "", image: "PushUp", difficulty: 1, tarjets: "Core", text: "", isCreated: false),
        Exercise(name: "Squat", type: "Workout", family: "Squat", place: "Floor", pq: "Strength, Mobility, Stability", object: "", image: "PushUp", difficulty: 2, tarjets: "Quads, Hips, Core", text: "", isCreated: false)
    ]*/
    
    //Array to store the exercises from Parse as objects
    private var exercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExercisesFromParse()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! ExercisesTableViewCell
        
        // Configure the cell
        cell.nameLabel.text = exercises[indexPath.row].name.uppercased()
        let arrayTarjet:NSArray = exercises[indexPath.row].tarjets as NSArray
        cell.tarjetLabel.text = arrayTarjet.componentsJoined(by: ", ").uppercased()
        let arrayPQ:NSArray = exercises[indexPath.row].pq as NSArray
        cell.pqLabel.text = arrayPQ.componentsJoined(by: ", ").uppercased()
        cell.levelLabel.text = difficultyLabel(difficulty: exercises[indexPath.row].difficulty)
        
        // Load image in background
        cell.thumbnailImageView.image = UIImage()
        if let image = exercises[indexPath.row].image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    cell.thumbnailImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells as! [ExercisesTableViewCell] {
            cell.nameLabel.restartLabel()
            cell.tarjetLabel.restartLabel()
            cell.pqLabel.restartLabel()
        }
    }
    
    func difficultyLabel(difficulty: Int)-> String {
        
        var diffLabel = ""
        
        switch difficulty {
        case 1: diffLabel = "SUPER EASY"
        case 2: diffLabel = "VERY EASY"
        case 3: diffLabel = "EASY"
        case 4: diffLabel = "NORMAL"
        case 5: diffLabel = "CHALLENGING"
        case 6: diffLabel = "HARD"
        case 7: diffLabel = "VERY HARD"
        case 8: diffLabel = "SUPER HARD"
        case 9: diffLabel = "PROFESSIONAL"
        case 10: diffLabel = "OLYMPIC"
        default:
            diffLabel = "DIFFICULTY"
        }
        
        return diffLabel
    }
    
    // MARK: Parse-related methods
    
    func loadExercisesFromParse() {
        // Clear up the array
        exercises.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Exercise")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    // Convert PFObject into Trip object
                    let exercise = Exercise(pfObject: object)
                    self.exercises.append(exercise)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                }
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
