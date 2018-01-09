//
//  NewWorkoutController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 27/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class NewWorkoutController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let current = PFUser.current()
    
    @IBOutlet var cancelButton:UIBarButtonItem!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var familyTextField:UITextField!
    @IBOutlet var familyIconImageView: UIImageView!
    @IBOutlet var numExercisesLabel:UILabel!
    @IBOutlet var setsTextField:UITextField!
    @IBOutlet var totalTimeTextField:UITextField!
    @IBOutlet var intervalTimeTextField:UITextField!
    @IBOutlet var pqTextField:UITextField!
    @IBOutlet var difficultyTextField:UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    var workoutNew: Workout!
    
    var exercises = [Exercise]()
    var exercisesNames = [String]()
    
    //Return from the Exercise List to the New Workout Scene
    @IBAction func unwindToNewWorkout(segue:UIStoryboardSegue){
        if segue.identifier == "doneToNew" {
            tableView.reloadData()
            numExercisesLabel.text = String(exercises.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        
        self.nameTextField.delegate = self
        self.familyTextField.delegate = self
        self.setsTextField.delegate = self
        self.totalTimeTextField.delegate = self
        self.intervalTimeTextField.delegate = self
        self.pqTextField.delegate = self
        self.difficultyTextField.delegate = self
    }
    
    // Keyboard will disappear when return button is touched
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
        if segue.identifier == "addExercisesNew"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! AddExercisesController
            
            destinationController.workoutView = "ExercisesNew"
        }
        /*if segue.identifier == "savedNewWorkout"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! WorkoutsTableViewController
            destinationController.workouts.append(workoutNew)
        }*/
    }
    
    @IBAction func save(sender: AnyObject){
        
        if familyTextField.text == "" || setsTextField.text == "" || totalTimeTextField.text == "" || intervalTimeTextField.text == "" || pqTextField.text == "" || difficultyTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "We cant proceed because one of the mandatory fields is blank. Please check.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        }else{
            var intTime = [Double]()
            for exercise in exercises {
                exercisesNames.append(exercise.name.capitalized)
                intTime.append(Double(intervalTimeTextField.text!)!)
            }
            let workout = PFObject(className: "Workout")
            workout["name"] = nameTextField.text?.capitalized
            workout["category"] = "Strength"
            workout["type"] = familyTextField.text?.capitalized
            workout["numSets"] = Int(setsTextField.text!)
            workout["exercises"] = exercisesNames
            workout["intTime"] = intTime
            workout["totalTime"] = Int(totalTimeTextField.text!)
            workout["difficulty"] = Functions.difficultyAmount(difficulty: difficultyTextField.text!)
            workout["tarjets"] = getTarjet(array: exercises)
            workout["improves"] = pqTextField?.text?.capitalized
            let isAdmin = current?["isAdmin"] as! Bool
            isAdmin ? (workout["isCreated"] = false) : (workout["isCreated"] = true)
            workout["user"] = current?.objectId

            // Add the exercise on Parse
            workout.saveInBackground(block: { (success, error) -> Void in
                if (success) {
                    print("Successfully added the workout.")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                }
            })
            
            self.performSegue(withIdentifier: "savedNewWorkout", sender: self)
        }
    }
}
