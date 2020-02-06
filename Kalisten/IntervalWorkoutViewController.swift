//
//  IntervalWorkoutViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 24/07/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class IntervalWorkoutViewController: UITableViewController {
    
    @IBOutlet weak var navigBar: UINavigationBar!
    @IBOutlet weak var navigItem: UINavigationItem!
    @IBOutlet weak var workoutInfo: UIBarButtonItem!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseInfo: UIButton!
    @IBOutlet weak var exercisesCount: UILabel!
    @IBOutlet weak var setCount: UILabel!
    @IBOutlet weak var maxCount: UILabel!
    
    @IBOutlet weak var overallTimerLabel: UILabel!
    @IBOutlet weak var intervalTimerLabel: UILabel!
    
    @IBOutlet weak var remainIntervalLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var toBeDoneLabel: UILabel!
    @IBOutlet weak var repsCountLabel: UILabel!
    
    @IBOutlet weak var nextExerciseLabel: UILabel!
    @IBOutlet weak var nextExercise: MarqueeLabel!
    @IBOutlet weak var pickReps: UIPickerView!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    var timeRunning = Bool()
    var timePaused = Bool()
    var pausedTime: Date?
    var pausedIntervals = [TimeInterval]()
    
    var alreadyPaused = Bool()
    
    var setInterval = 0.0
    var doneExercise = false
    var repsCount = 0
    var maxExercise = 0
    var maxExercises = [Int]()
    var exerciseReps = [Int]()
    var countReps = [[Int]]()
    
    var workout: Workout!
    var exercises = [Exercise]()
    var index = 0
    var indexSets = 0
    
    var repetitions = [String]()
    var reps = 0
    
    //Return from the Exercise Detail View to the Workout Session
    @IBAction func unwindToIntervalSession(segue:UIStoryboardSegue){
        if !self.alreadyPaused {
            self.pauseResumeTimerAction()
        }
    }
    
    @IBAction func exerciseInfoPressed(_ sender: UIButton) {
        if  !timePaused {
            pauseResumeTimerAction()
            alreadyPaused = false
        } else {
            alreadyPaused = true
        }
        self.performSegue(withIdentifier: "showIntervalExercise", sender: exerciseInfo)
    }
    
    @IBAction func exitButtonPressed(_ sender: UIBarButtonItem){
        if  !timePaused {
            pauseResumeTimerAction()
            alreadyPaused = false
        } else {
            alreadyPaused = true
        }
        if PFUser.current() != nil {
            
            let alertController = UIAlertController(title: "Abort Workout Session", message: "You are trying to abort the current workout. Do you want to save the progress done or you want to discard?", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save and exit", style: .default) { (alert: UIAlertAction!) -> Void in
                
                let record = PFObject(className: "Record")
                
                record["user"] = PFUser.current()?.objectId
                record["workName"] = self.workout.name
                record["workType"] = self.workout.type
                record["workFamily"] = self.workout.type
                record["workDate"] = Date()
                record["workExercises"] = self.workout.exercises
                record["maxReps"] = self.maxExercises
                record["countReps"] = self.countReps
                
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
            
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "unwindToTraining", sender: self)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                if !self.alreadyPaused {
                    self.pauseResumeTimerAction()
                }
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion:nil)
        }
        else {
            
            let alertController = UIAlertController(title: "Abort Workout Session", message: "If you leave now, all the progress done will be lost. Are you sure you want to discard?", preferredStyle: .alert)
            
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "unwindToTraining", sender: self)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                if !self.alreadyPaused {
                    self.pauseResumeTimerAction()
                }
            }
            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        navigItem.title = workout.name.uppercased()
        
        repetitions = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
        pickReps.delegate = self
        pickReps.dataSource = self
        
        insertExerciseData()
        startTimer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load all the data from the exercise in execution
    func insertExerciseData () {
        
        exerciseName.text = "EXERCISE \(index + 1): \(exercises[index].name.uppercased())S"
        
        // Load image in the detail view
        exerciseImage.image = UIImage()
        if let imageDet = exercises[index].imageDet {
            imageDet.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImage.image = UIImage(data: exerciseImageData)
                    self.exerciseImage.backgroundColor = UIColor.white
                }
            })
        }
        else if let image = exercises[index].image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImage.image = UIImage(data: exerciseImageData)
                    self.exerciseImage.backgroundColor = UIColor.white
                }
            })
        } else {
            self.exerciseImage.backgroundColor = UIColor.lightGrey
            
        }
        
        exercisesCount.text = "EXERCISES: \(index + 1)/\(exercises.count)"
        setCount.text = "SET: 1/\(workout.numSets)"
        maxCount.text = "MAX: 0"
        toBeDoneLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 45)
        toBeDoneLabel.text = "6-12"
        repsCountLabel.text = "0"
        maxExercise = 0
        repsCount = 0
        reps = 0
        
        if indexSets == workout.numSets - 2 {
            nextExerciseLabel.text = "CURR. EXERCISE"
            nextExercise.text = "\(workout.numSets - (indexSets + 1)) SET LEFT"
        } else if indexSets == workout.numSets - 1 {
            if index == exercises.count - 2 {
                nextExerciseLabel.text = "LAST EXERCISE    ----->"
                nextExercise.text = exercises[index + 1].name.uppercased() + "S"
            } else if index == exercises.count - 1 {
                nextExerciseLabel.text = ""
                nextExercise.text = "ALMOST DONE..."
            } else {
                
                nextExerciseLabel.text = "NEXT EXERCISE"
                nextExercise.text = exercises[index + 1].name.uppercased() + "S"
            }
            doneExercise = true
            
        } else {
            nextExerciseLabel.text = "CURR. EXERCISE"
            nextExercise.text = "\(workout.numSets - (indexSets + 1)) SETS LEFT"
        }
    }
    
    //Load all the data from the exercise in execution
    func insertSetsData () {
        
        setCount.text = "SET: \(indexSets + 1)/\(workout.numSets)"
        toBeDoneLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 55)
        toBeDoneLabel.text = String(reps)
        maxCount.text = "MAX: \(maxExercise)"
        
        
        if indexSets == workout.numSets - 2 {
            nextExerciseLabel.text = "CURR. EXERCISE"
            nextExercise.text = "\(workout.numSets - (indexSets + 1)) SET LEFT"
        } else if indexSets == workout.numSets - 1 {
            if index == exercises.count - 2 {
                nextExerciseLabel.text = "LAST EXERCISE    ----->"
                nextExercise.text = exercises[index + 1].name.uppercased() + "S"
            } else if index == exercises.count - 1 {
                nextExerciseLabel.text = ""
                nextExercise.text = "ALMOST DONE..."
            } else {
                
                nextExerciseLabel.text = "NEXT EXERCISE"
                nextExercise.text = exercises[index + 1].name.uppercased() + "S"
            }
            doneExercise = true
            
        } else {
            nextExerciseLabel.text = "CURR. EXERCISE"
            nextExercise.text = "\(workout.numSets - (indexSets + 1)) SETS LEFT"
        }
    }
    //Initializes the clock to start counting the workout timing
    func startTimer() {
        
        if !timer.isValid {
            let selectorName = "updateTime"
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector(selectorName), userInfo: nil, repeats: true)
            zeroTime = Date.timeIntervalSinceReferenceDate
        }
        
        timeRunning = true
        timePaused = false
        pausedIntervals = []
    }
    
    //Is called during startTimer() and provides data to be used when creating the timers
    func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        var pausedSeconds = pausedIntervals.reduce(0) { $0 + $1 }
        if let pausedTime = pausedTime {
            pausedSeconds += Date().timeIntervalSince(pausedTime)
        }
        var timePassed: TimeInterval = currentTime - zeroTime - pausedSeconds
        var interPassed: TimeInterval = currentTime - zeroTime - pausedSeconds - setInterval
        var interLeft = (workout.intTime[0] * 60) - interPassed + 1
        
        //If the clock has 10 secs or less to finish the interval, it becomes red.
        if interLeft <= 11 {
            
            remainIntervalLabel.textColor = UIColor.red
            
        } else {
            
            if #available(iOS 13.0, *) {
                remainIntervalLabel.textColor = UIColor.label
            } else {
                remainIntervalLabel.textColor = UIColor.black
            }
        }
        
        if interLeft <= 0 {
            
            
            if indexSets < workout.numSets - 1 {
                exerciseReps.append(reps)
                repsCount += reps
                setInterval += (workout.intTime[0] * 60)
                indexSets += 1
                if reps > maxExercise {
                    maxExercise = reps
                }
                insertSetsData()
            } else {
                
                maxExercises.append(maxExercise)
                countReps.append(exerciseReps)
                exerciseReps.removeAll()
                
                if index < exercises.count - 1 {
                    setInterval += (workout.intTime[0] * 60)
                    index += 1
                    indexSets = 0
                    insertExerciseData()
                } else {
                    timer.invalidate()
                    self.performSegue(withIdentifier: "workoutResults", sender: self)
                }
            }
        }
        
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let interMin = UInt8(interPassed / 60.0)
        interPassed -= (TimeInterval(interMin) * 60)
        let minsLeft = UInt8(interLeft / 60)
        interLeft -= (TimeInterval(minsLeft) * 60)
        
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let interSecs = UInt8(interPassed)
        interPassed -= TimeInterval(interSecs)
        let secsLeft = UInt8(Int(interLeft) % 60)
        interLeft -= TimeInterval(secsLeft)
        
        let strMinutes = String(format: "%02d", minutes)
        let strInterMins = String(format: "%02d", interMin)
        let strMinsLeft = String(format: "%02d", minsLeft)
        let strSeconds = String(format: "%02d", seconds)
        let strInterSecs = String(format: "%02d", interSecs)
        let strSecsLeft = String(format: "%02d", secsLeft)
        
        overallTimerLabel.text = "\(strMinutes):\(strSeconds)"
        intervalTimerLabel.text = "\(strInterMins):\(strInterSecs)"
        remainIntervalLabel.text = "\(strMinsLeft):\(strSecsLeft)"
        repsCountLabel.text = String(reps + repsCount)
    }
    
    func pauseResumeTimerAction() {
        if timeRunning && !timePaused {
            alreadyPaused = true
            timer.invalidate()
            timePaused = true
            timeRunning = false
            pausedTime = Date()
            pauseButton.setTitle("RESUME", for: .normal)
            
        } else if !timeRunning && timePaused {
            alreadyPaused = false
            let pausedSeconds = Date().timeIntervalSince(pausedTime!)
            pausedIntervals.append(pausedSeconds)
            pausedTime = nil
            
            if !timer.isValid {
                timer.invalidate()
                let selectorName = "updateTime"
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector(selectorName), userInfo: nil, repeats: true)
            }
            
            timePaused = false
            timeRunning = true
            pauseButton.setTitle("PAUSE", for: .normal)
        }
    }
    
    //Stops or resumes the timer when the button is clicked. It also sets the elements when tapped
    @IBAction func pauseResumeTimer(_ sender: AnyObject) {
        pauseResumeTimerAction()
    }
}

extension IntervalWorkoutViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repetitions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let repsLabel = UILabel()
        var repsData: String!
        
        repsData = repetitions[row]
        repsLabel.textAlignment = .center
        let myDiff = NSAttributedString(string: repsData, attributes: [NSAttributedString.Key.font:UIFont(name: "AvenirNextCondensed-DemiBold", size: 55)!])
        repsLabel.attributedText = myDiff
        repsLabel.textColor = UIColor.estonianBlue
        
        
        return repsLabel
    }
    
    //Sets the space between elements by changing the row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reps = Int(repetitions[row])!
    }
    
    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showIntervalExercise"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! ExerciseDetailViewController
            destinationController.exercise =  exercises[index]
            destinationController.workoutFamily = workout.type
        }
        if segue.identifier == "workoutResults"{
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! WorkoutCompletedViewController
            
            destinationController.workout = workout
            destinationController.exercises = exercises
            destinationController.exReps = countReps
        }
    }
}
