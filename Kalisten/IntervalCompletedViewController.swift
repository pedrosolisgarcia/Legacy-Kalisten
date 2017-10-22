//
//  IntervalCompletedViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 27/07/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class IntervalCompletedViewController: UIViewController {
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    var workout: Workout!
    var exercises = [Exercise]()
    var maxLadders = [Int]()
    var exReps = [[Int]]()
    var totalReps = 0
    
    let date = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if PFUser.current() != nil {
            saveButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
            saveButton.isEnabled = true
            discardButton.setTitle("DISCARD", for: .normal)
        } else {
            saveButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
            discardButton.setTitle("EXIT", for: .normal)
            saveButton.isEnabled = false
        }
        
        workoutName.text = workout.name.uppercased()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LadderCompleteViewCell
        
        if indexPath.row < exercises.count {
            
            // Configure the cell
            cell.exerciseName.text = exercises[indexPath.row].name.uppercased() + "S"
            cell.maxLadder.text = String(maxLadders[indexPath.row])
            cell.reps.text = String(exReps[indexPath.row][0])
            totalReps += exReps[indexPath.row][0]
        } else {
            
            // Configure the cell
            cell.totalTitle.text = "TOTAL OF REPETITIONS:"
            cell.totalTitle.textColor = UIColor.white
            cell.totalReps.text = String(totalReps)
            cell.totalReps.textColor = UIColor.white
            cell.exerciseName.text = ""
            cell.maxLadder.text = ""
            cell.reps.text = ""
            cell.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.75)
        }
        return cell
    }
    
    @IBAction func saveOrDiscard(_ sender: UIButton) {
        if sender == saveButton {
            
            let record = PFObject(className: "Record")
            
            record["user"] = PFUser.current()?.objectId
            record["workName"] = workout.name
            record["workType"] = workout.type
            record["workFamily"] = workout.type
            record["workDate"] = Date()
            record["workExercises"] = workout.exercises
            record["maxReps"] = maxLadders
            record["countReps"] = exReps
            
            // Add the workout record on Parse
            record.saveInBackground(block: { (success, error) -> Void in
                if (success) {
                    print("Successfully added the workout record.")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                }
            })
            
            self.performSegue(withIdentifier: "unwindToTraining", sender: self)
            
        }
        if sender == discardButton {
            
            if PFUser.current() != nil {
                
                let alertController = UIAlertController(title: "Discard Workout Session", message: "If you continue, the information about this workout will be deleted permanently. Are you sure you want to continue?", preferredStyle: .alert)
                
                let applyAction = UIAlertAction(title: "Continue", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    self.performSegue(withIdentifier: "unwindToTraining", sender: self)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                }
                
                alertController.addAction(applyAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion:nil)
            } else {
                
                self.performSegue(withIdentifier: "unwindToTraining", sender: self)
            }
        }
    }
}
