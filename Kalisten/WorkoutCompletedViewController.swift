import UIKit
import Parse

class WorkoutCompletedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutSplit: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    var workout: Workout!
    var exercises = [Exercise]()
    var maxLadders = [Int]()
    var exReps = [[Int]]()
    var totalReps = 0
    var index = 1
    
    let date = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        workoutName.text = workout.name.uppercased()
        
        if workout.type == "Interval" {
            while index < workout.numSets {
                workoutSplit.text?.append("S\(index)   ")
                index += 1
            }
            if index == workout.numSets {
                workoutSplit.text?.append("S\(index)")
            }
        }
        
        if PFUser.current() != nil {
            saveButton.backgroundColor = .estonianBlue
            saveButton.isEnabled = true
            discardButton.setTitle("DISCARD", for: .normal)
        } else {
            saveButton.backgroundColor = UIColor.estonianBlue.opacity(percentage: 50)
            discardButton.setTitle("EXIT", for: .normal)
            saveButton.isEnabled = false
        }
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
        if workout.type == "Interval" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntervalCell", for: indexPath) as! IntervalCompletedViewCell
            
            if indexPath.row < exercises.count {
                
                // Configure the cell
                index = 1
                /*while index < workout.numSets - 1{
                    cell.setsReps.text?.append(String(exReps[indexPath.row][index - 1]) + "   ")
                    index += 1
                }
                if index == workout.numSets - 1{
                    cell.setsReps.text?.append(String(exReps[indexPath.row][index - 1]))
                }*/
                cell.exerciseName.text = exercises[indexPath.row].name.uppercased() + "S"
                cell.totalEx.text = String(exReps[indexPath.row].count)
                totalReps = exReps.count
            } else {
                
                // Configure the cell
                cell.totalTitle.text = "TOTAL OF REPETITIONS:"
                cell.totalTitle.textColor = .white
                cell.totalReps.text = String(totalReps)
                cell.totalReps.textColor = .white
                cell.exerciseName.text = ""
                cell.backgroundColor = UIColor.estonianBlue.opacity(percentage: 75)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LadderCell", for: indexPath) as! LadderCompletedViewCell
            
            if indexPath.row < exercises.count {
                
                // Configure the cell
                cell.exerciseName.text = exercises[indexPath.row].name.uppercased() + "S"
                cell.maxLadder.text = String(maxLadders[indexPath.row])
                cell.reps.text = String(exReps[indexPath.row][0])
                totalReps += exReps[indexPath.row][0]
            } else {
                
                // Configure the cell
                cell.totalTitle.text = "TOTAL OF REPETITIONS:"
                cell.totalTitle.textColor = .white
                cell.totalReps.text = String(totalReps)
                cell.totalReps.textColor = .white
                cell.exerciseName.text = ""
                cell.maxLadder.text = ""
                cell.reps.text = ""
                cell.backgroundColor = UIColor.estonianBlue.opacity(percentage: 75)
            }
            return cell
        }
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
