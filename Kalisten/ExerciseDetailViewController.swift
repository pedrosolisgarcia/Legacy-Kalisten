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
    
    //var cell: ExerciseDetailTableViewCell!
    
    var exercise: Exercise!
    
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

        // Do any additional setup after loading the view.
        
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
            
            // Configure the cell...
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell0") as! ExerciseDetailTableViewCell
                
                cell.fieldLabel.text = "  NAME"
                cell.valueText.text = exercise.name.uppercased()
                cell.fieldLabel0.text = "  DIFFICULTY"
                cell.valueText0.text = String(exercise.difficulty)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell

                cell.fieldLabel.text = "  TYPE"
                cell.valueText.text = exercise.type.uppercased()
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell

                cell.fieldLabel.text = "  FAMILY"
                let arrayFamily:NSArray = exercise.family as NSArray
                cell.valueText.text = arrayFamily.componentsJoined(by: ", ").uppercased()
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell

                cell.fieldLabel.text = "  PLACE"
                let arrayPlace:NSArray? = exercise.place as NSArray?
                cell.valueText.text = arrayPlace?.componentsJoined(by: ", ").uppercased()
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell

                cell.fieldLabel.text = "  OBJECT"
                let arrayObject:NSArray? = exercise.object as NSArray?
                cell.valueText.text = arrayObject?.componentsJoined(by: ", ").uppercased()
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                editMode ? (cell.isUserInteractionEnabled = true) : (cell.isUserInteractionEnabled = false)
                cell.fieldLabel.text = "  PHYSICAL QUALITY"
                let arrayPQ:NSArray? = exercise.pq as NSArray?
                cell.valueText.text = arrayPQ?.componentsJoined(by: ", ").uppercased()
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as! ExerciseDetailTableViewCell
                editMode ? (cell.isUserInteractionEnabled = true) : (cell.isUserInteractionEnabled = false)
                cell.fieldLabel.text = "  TARJETS"
                let arrayTarjets:NSArray = exercise.tarjets as NSArray
                cell.valueText.text = arrayTarjets.componentsJoined(by: ", ").uppercased()
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
            cell.valueText.placeholder = "No description available."
            cell.valueText.text = exercise?.description
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
    
    //Action for the Edit button:
    /* When clicked the user can modify the fields. In case he does, the system check them
     * If the changes are correct, the system asks the user to confirm the canges.
     * If the user applies them, the user will update the data and return to the normal view
     * If the user cancels, the view will go back to normal but discarding any changes */
    
    @IBAction func editValues(sender: UIBarButtonItem){
        
        if editMode {
            if labelValues == originalValues{
                editButton.title = "Edit"
                editMode = false
            }
            else{
                if labelValues[0] == "" || labelValues[1] == "" || labelValues[2] == "" || labelValues[6] == "" || labelValues[7] == ""{
                    let alertController = UIAlertController(title: "Editing Failed", message: "We cant proceed because one of the mandatory fields is blank. Please check.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true, completion:nil)
                }else{
                    let alertController = UIAlertController(title: "Changes Detected", message: "Some of the fields have been changed. Do you want to apply them?", preferredStyle: .alert)
                    
                    let applyAction = UIAlertAction(title: "Apply", style: .destructive) { (alert: UIAlertAction!) -> Void in
                        
                        self.exercise.name = self.labelValues[0]
                        self.exercise.type = self.labelValues[1]
                        self.exercise.family = self.labelValues[2].components(separatedBy: ", ")
                        self.exercise.place = self.labelValues[3].components(separatedBy: ", ")
                        self.exercise.object = self.labelValues[4].components(separatedBy: ", ")
                        self.exercise.pq = self.labelValues[5].components(separatedBy: ", ")
                        self.exercise.tarjets = self.labelValues[6].components(separatedBy: ", ")
                        self.exercise.difficulty = Int(self.labelValues[7])!
                        //exercise["description"] = descriptionTextField?.text
                        
                        // Add the exercise on Parse
                        self.exercise.toPFObject().saveInBackground(block: { (success, error) -> Void in
                            if (success) {
                                print("Changes applied successfully.")
                            } else {
                                print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                            }
                        })
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                        
                        self.editButton.title = "Edit"
                        self.editMode = false
                    }
                    alertController.addAction(applyAction)
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion:nil)
                    
                    editButton.title = "Edit"
                    editMode = false
                }
            }
        } else{
            editButton.title = "Done"
            editMode = true
        }
        tableViewInformation.reloadData()
        informationView.reloadInputViews()
    }

}
