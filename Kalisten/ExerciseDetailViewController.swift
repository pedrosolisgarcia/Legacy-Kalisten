//
//  ExerciseDetailViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 09/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var exerciseImageView: UIImageView!
    
    @IBOutlet weak var tableViewInformation: UITableView!
    @IBOutlet weak var tableViewExecution: UITableView!
    @IBOutlet weak var tableViewTarjects: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //Variables for the navigation bar used during Workout Session
    @IBOutlet weak var navigBar: UINavigationBar!
    @IBOutlet weak var navigItem: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var exercise: Exercise!
    
    var workoutFamily: String!
    
    //Return from the Exercise List to the New Workout Scene
    @IBAction func unwindToExerciseDetail(segue:UIStoryboardSegue){
        if segue.identifier == "exerciseEdited" {
            viewDidLoad()
            exerciseImageView.reloadInputViews()
            tableViewInformation.reloadData()
            tableViewExecution.reloadData()
        }
    }
    
    @IBAction func backButtonPressed(_sender: UIBarButtonItem){
        
        if workoutFamily == "Ladder" {
            self.performSegue(withIdentifier: "unwindToLadder", sender: self)
        }
        if workoutFamily == "Interval" {
            self.performSegue(withIdentifier: "unwindToInterval", sender: self)
        }
    }
    
    var editMode = false
    
    var labelValues = Array(repeating: "", count: 8)
    var originalValues = Array(repeating: "", count: 8)
    
    @IBOutlet var exerciseSections: UISegmentedControl!
    
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var executionView: UIView!
    @IBOutlet weak var tarjetsView: UIView!
    
    //Switch between views when clicking the segments
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch exerciseSections.selectedSegmentIndex {
        case 0:
            informationView.isHidden = false
            executionView.isHidden = true
            tarjetsView.isHidden = true
        case 1:
            informationView.isHidden = true
            executionView.isHidden = false
            tarjetsView.isHidden = true
        case 2:
            informationView.isHidden = true
            executionView.isHidden = true
            tarjetsView.isHidden = false
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Only admins can see the edit button
        let current = PFUser.current()
        
        if current == nil {
            editButton.isEnabled = false
            editButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else if current?["isAdmin"] as! Bool == false{
            editButton.isEnabled = false
            editButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            editButton.isEnabled = true
            editButton.tintColor = UIColor.white
        }

        // Do any additional setup after loading the view.
        navigItem.title = exercise.name.uppercased()
        
        // Load image in the detail view
        exerciseImageView.image = UIImage()
        if let imageDet = exercise.imageDet {
            imageDet.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }
        else if let image = exercise.image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }
        
        informationView.isHidden = false
        executionView.isHidden = true
        tarjetsView.isHidden = true

        //Sets the header of the navigation bar to the exercise's name
        title = exercise.name.uppercased()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Prevent from hiding the bar on swipe
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func fieldChanged(_ sender: UITextField) {
       // if let indexPath = tableView.indexPath(for: cell){
            
       // }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sets the number of rows of each tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.tableViewInformation {
            count = 7
        }
        
        if tableView == self.tableViewExecution {
            count =  1
        }
        
        /*if tableView == self.tableViewTarjects {
            count =  3
        }*/
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableViewInformation {
            
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  NAME"
                cell.valueText.text = exercise.name.uppercased()
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  CATEGORY"
                cell.valueText.text = exercise.category.uppercased()
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  FAMILY"
                let arrayFamily:NSArray = exercise.family as NSArray
                cell.valueText.text = arrayFamily.componentsJoined(by: ", ").uppercased()
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  DIFFICULTY"
                cell.valueText.text = String(Functions.difficultyLevel(difficulty: exercise.difficulty))
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  TARJETS"
                let arrayTarjets:NSArray = exercise.tarjets as NSArray
                cell.valueText.text = arrayTarjets.componentsJoined(by: ", ").uppercased()
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  PLACE"
                let arrayPlace:NSArray? = exercise.place as NSArray?
                cell.valueText.text = arrayPlace?.componentsJoined(by: ", ").uppercased()
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = "  PHYSICAL QUALITY"
                let arrayPQ:NSArray? = exercise.pq as NSArray?
                cell.valueText.text = arrayPQ?.componentsJoined(by: ", ").uppercased()
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                cell.fieldLabel.text = ""
                cell.valueText.text = ""
                return cell
            }
        }
        
        else if tableView == self.tableViewExecution {
            
            // Configure the cell...
            let cell = tableView.dequeueReusableCell(withIdentifier: "executionCell") as! ExerciseDetailTableViewCell
            cell.fieldLabel.text = "  DESCRIPTION"
            cell.descriptionText.text = exercise?.description?.uppercased()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "executionCell") as! ExerciseDetailTableViewCell
            return cell
        }
        /*if tableView == self.tableViewTarjects {
            cell = tableView.dequeueReusableCell(withIdentifier: "tarjectsCell", for: indexPath) as! ExerciseDetailTableViewCell
            
        }*/
        
    }
    
    //Prepare data from the exercise to be available for editing in the edit view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "editExercise"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! EditExerciseController

            destinationController.editExercise = exercise
        }
    }
}
