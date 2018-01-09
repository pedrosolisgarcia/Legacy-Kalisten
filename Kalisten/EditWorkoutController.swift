//
//  EditWorkoutController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 01/07/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class EditWorkoutController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let current = PFUser.current()
    
    @IBOutlet var familyTextField:UITextField!
    @IBOutlet var familyIconImageView: UIImageView!
    @IBOutlet var numExercisesLabel:UILabel!
    @IBOutlet var setsTextField:UITextField!
    @IBOutlet var totalTimeTextField:UITextField!
    @IBOutlet var intervalTimeTextField:UITextField!
    @IBOutlet var pqTextField:UITextField!
    @IBOutlet var difficultyTextField:UITextField!
    @IBOutlet var tableView: UITableView!
    
    var workout: Workout!
    var exercises = [Exercise]()
    var exercisesNames = [String]()
    
    //Return from the Exercise List to the New Workout Scene
    @IBAction func unwindToEditWorkout(segue:UIStoryboardSegue){
        if segue.identifier == "doneToEdit" {
            tableView.reloadData()
            numExercisesLabel.text = String(exercises.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        
        self.familyTextField.delegate = self
        self.setsTextField.delegate = self
        self.totalTimeTextField.delegate = self
        self.intervalTimeTextField.delegate = self
        self.pqTextField.delegate = self
        self.difficultyTextField.delegate = self
        
        familyTextField.text = workout.type.uppercased()
        familyIconImageView.image = UIImage(named: "\(workout.type.lowercased())")
        numExercisesLabel.text = String(workout.exercises.count)
        setsTextField.text = String(workout.numSets)
        totalTimeTextField.text = String(workout.totalTime)
        intervalTimeTextField.text = String(workout.intTime[0])
        pqTextField.text = workout.improves.uppercased()
        difficultyTextField.text = Functions.difficultyLevel(difficulty: workout.difficulty)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    //If the family workout introduced is ladder, it will show the ladder icon
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.familyTextField {
            if familyTextField.text?.lowercased() == "ladder" {
                // Load familyIcon in the detail view
                familyIconImageView.image = UIImage(named: "ladder")
                familyIconImageView.reloadInputViews()
            }
        }
    }
    
    //We increase the number of rows in one unit to include the add Exercise cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if exercises.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! NewWorkoutViewCell
            cell.plusLabel.text = "+"
            cell.addExerciseLabel.text = "ADD AN EXERCISE"
            
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! NewWorkoutViewCell
                
                cell.plusLabel.text = "+"
                cell.addExerciseLabel.text = "ADD AN EXERCISE"
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewWorkoutViewCell
                
                // Configure the cell
                cell.nameLabel.text = exercises[indexPath.row - 1].name.uppercased() + "S"
                
                // Load image in background
                cell.thumbnailImageView.image = UIImage()
                if let image = exercises[indexPath.row - 1].image {
                    //if let image = exercises_order[indexPath.row]?.image {
                    image.getDataInBackground(block: { (imageData, error) in
                        if let exerciseImageData = imageData {
                            cell.thumbnailImageView.image = UIImage(data: exerciseImageData)
                        }
                    })
                }
                
                return cell
            }
        }
    }
    
    //Automatically deselect the cell when touched
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Manages the tableView and the exercises objects when cells are moved
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.exercises[sourceIndexPath.row - 1]
        exercises.remove(at: sourceIndexPath.row - 1)
        exercises.insert(movedObject, at: destinationIndexPath.row - 1)
        self.tableView.reloadData()
    }
    
    //The add Exercise Cell is not editable, so it cant be moved
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 || exercises.count == 0{
            return false
        }
        else {
            return true
        }
    }
    
    //The add Exercise Cell is not editable, so I wont have delete action
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 || exercises.count == 0{
            return false
        }
        else {
            return true
        }
    }
    
    //Shows the delete option on swipe to remove the exercise from Parse
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.exercises.remove(at: indexPath.row - 1)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.numExercisesLabel.text = String(self.exercises.count)
        }
        
        //This is nice if you want to add a edit button later
        return [deleteAction]
    }
    
    func getTarjet(array: [Exercise])-> [String] {
        var exerciseTarjets = [String]()
        for exercise in exercises {
            exerciseTarjets.append(exercise.tarjets[0])
        }
        var noRepTarjects = [String]()
        for (index,tarjet) in exerciseTarjets.enumerated() {
            if index == 0 {
                noRepTarjects.append(tarjet)
            } else {
                if !noRepTarjects.contains(tarjet) {
                    noRepTarjects.append(tarjet)
                }
            }
        }
        var frequencies = [Int](repeating: 0, count: noRepTarjects.count)
        for (index, tar) in noRepTarjects.enumerated(){
            for tarj in exerciseTarjets {
                if tar == tarj {
                    frequencies[index] += 1
                }
            }
        }
        let sorted = zip(noRepTarjects, frequencies).sorted { $0.1 > $1.1 }
        
        noRepTarjects = sorted.map { $0.0 }
        frequencies = sorted.map { $0.1 }
        
        if noRepTarjects.count > 2{
            noRepTarjects.removeLast()
        }
        return noRepTarjects
    }
    
    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "addExercisesEdit"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! AddExercisesController
            
            destinationController.workoutView = "ExercisesEdit"
            
        }
        if segue.identifier == "doneEditWorkout"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! WorkoutDetailViewController
            destinationController.workout = workout
            
        }
    }
    
    @IBAction func done(sender: AnyObject){
        
        if familyTextField.text == "" || setsTextField.text == "" || totalTimeTextField.text == "" || intervalTimeTextField.text == "" || pqTextField.text == "" || difficultyTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "We cant proceed because one of the mandatory fields is blank. Please check.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        }else{
            var intTime = [Double]()
            let isAdmin = current?["isAdmin"] as! Bool
            for exercise in exercises {
                exercisesNames.append(exercise.name.capitalized)
                intTime.append(Double(intervalTimeTextField.text!)!)
            }
            
            if isAdmin {
                
                let alertController = UIAlertController(title: "Update or Variation", message: "Change detected. Do you want to update the current workout or create a variation of it?", preferredStyle: .alert)
                
                let updateAction = UIAlertAction(title: "Update", style: .default) { (alert: UIAlertAction!) -> Void in
                    
                    let workoutToUpdate = PFObject(withoutDataWithClassName: "Workout", objectId: self.workout.workId)
                    
                    workoutToUpdate["type"] = self.familyTextField.text?.capitalized
                    self.workout.type = (self.familyTextField.text?.capitalized)!
                    workoutToUpdate["numSets"] = Int(self.setsTextField.text!)
                    self.workout.numSets = Int(self.setsTextField.text!)!
                    workoutToUpdate["exercises"] = self.exercisesNames
                    self.workout.exercises = self.exercisesNames
                    workoutToUpdate["intTime"] = intTime
                    self.workout.intTime = intTime
                    workoutToUpdate["totalTime"] = Int(self.totalTimeTextField.text!)
                    self.workout.totalTime = Int(self.totalTimeTextField.text!)!
                    workoutToUpdate["difficulty"] = Functions.difficultyAmount(difficulty: self.difficultyTextField.text!)
                    self.workout.difficulty = Functions.difficultyAmount(difficulty: self.difficultyTextField.text!)
                    workoutToUpdate["tarjets"] = self.getTarjet(array: self.exercises)
                    self.workout.tarjets = self.getTarjet(array: self.exercises)
                    workoutToUpdate["improves"] = self.pqTextField?.text?.capitalized
                    self.workout.improves = (self.pqTextField?.text?.capitalized)!
                    workoutToUpdate["isCreated"] = false
                    self.workout.isCreated = false
                    workoutToUpdate["user"] = self.current?.objectId
                    self.workout.user = self.current?.objectId
                    
                    // Update the workout on Parse
                    workoutToUpdate.saveInBackground(block: { (success, error) -> Void in
                        if (success) {
                            print("Changes applied successfully.")
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                        }
                    })
                    
                    self.performSegue(withIdentifier: "doneEditWorkout", sender: self)
                }
                
                let createAction = UIAlertAction(title: "Create", style: .default) { (alert: UIAlertAction!) -> Void in
                    
                    let workout = PFObject(className: "Workout")
                    workout["name"] = self.workout.name.capitalized + " (Variation)"
                    workout["category"] = "Strength"
                    workout["type"] = self.familyTextField.text?.capitalized
                    workout["numSets"] = Int(self.setsTextField.text!)
                    workout["exercises"] = self.exercisesNames
                    workout["intTime"] = intTime
                    workout["totalTime"] = Int(self.totalTimeTextField.text!)
                    workout["difficulty"] = Functions.difficultyAmount(difficulty: self.difficultyTextField.text!)
                    workout["tarjets"] = self.getTarjet(array: self.exercises)
                    workout["improves"] = self.pqTextField?.text?.capitalized
                    workout["isCreated"] = false
                    workout["user"] = self.current?.objectId
                    
                    // Add the workout on Parse
                    workout.saveInBackground(block: { (success, error) -> Void in
                        if (success) {
                            print("Successfully added the workout.")
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                        }
                    })
                    
                    self.performSegue(withIdentifier: "doneEditWorkout", sender: self)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                }
                
                alertController.addAction(updateAction)
                alertController.addAction(createAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion:nil)
                
            } else {
                let alertController = UIAlertController(title: "Confirm changes", message: "Change detected. Do you want to save the changes done in a new Workout Variation", preferredStyle: .alert)
                
                let createAction = UIAlertAction(title: "Yes, save", style: .default) { (alert: UIAlertAction!) -> Void in
                    
                    let workout = PFObject(className: "Workout")
                    workout["name"] = self.workout.name.capitalized + " (Variation)"
                    workout["category"] = "Strength"
                    workout["type"] = self.familyTextField.text?.capitalized
                    workout["numSets"] = Int(self.setsTextField.text!)
                    workout["exercises"] = self.exercisesNames
                    workout["intTime"] = intTime
                    workout["totalTime"] = Int(self.totalTimeTextField.text!)
                    workout["difficulty"] = Functions.difficultyAmount(difficulty: self.difficultyTextField.text!)
                    workout["tarjets"] = self.getTarjet(array: self.exercises)
                    workout["improves"] = self.pqTextField?.text?.capitalized
                    workout["isCreated"] = true
                    workout["user"] = self.current?.objectId
                    
                    // Add the workout on Parse
                    workout.saveInBackground(block: { (success, error) -> Void in
                        if (success) {
                            print("Successfully added the workout.")
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                        }
                    })
                    
                    
                    self.performSegue(withIdentifier: "doneEditWorkout", sender: self)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                }
                
                alertController.addAction(createAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion:nil)
            }
        }
    }
}
