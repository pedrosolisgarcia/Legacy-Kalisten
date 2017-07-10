//
//  LadderWorkoutViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 04/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class LadderWorkoutViewController: UITableViewController {
    
    @IBOutlet weak var navigBar: UINavigationBar!
    @IBOutlet weak var navigItem: UINavigationItem!
    @IBOutlet weak var workoutInfo: UIBarButtonItem!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseInfo: UIButton!
    @IBOutlet weak var exercisesCount: UILabel!
    @IBOutlet weak var laddersCount: UILabel!
    
    @IBOutlet weak var overallTimerLabel: UILabel!
    @IBOutlet weak var intervalTimerLabel: UILabel!
    
    @IBOutlet weak var remainIntervalLabel: UILabel!
    @IBOutlet weak var countTimerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var repsCountLabel: UILabel!
    @IBOutlet weak var ladderUpButton: UIButton!
    @IBOutlet weak var ladderDownButton: UIButton!
    
    @IBOutlet weak var nextExerciseLabel: UILabel!
    @IBOutlet weak var nextExercise: UILabel!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    var timeRunning = Bool()
    var timePaused = Bool()
    var pausedTime: Date?
    var pausedIntervals = [TimeInterval]()
    
    var setLadder = 0.0
    
    var reps = 0
    var repsCount = 0
    var isGoingUp = true
    var maxLadder = 0
    var maxLadders = [Int]()
    var exReps = [Int]()
    
    var workout: Workout!
    var exercises = [Exercise]()
    var index = 0
    
    //Return from the Exercise Detail View to the Workout Session
    @IBAction func unwindToLadderSession(segue:UIStoryboardSegue){}
    
    @IBAction func exitButtonPressed(_ sender: UIBarButtonItem){
        
        let alertController = UIAlertController(title: "Discard Workout Session", message: "If you continue, the information about this workout will be deleted permanently. Are you sure you want to continue?", preferredStyle: .alert)
        
        let applyAction = UIAlertAction(title: "Continue", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "unwindToTraining", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
        }
        
        alertController.addAction(applyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigItem.title = workout.name.uppercased()
        
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
            self.exerciseImage.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)

        }
        
        exercisesCount.text = "EXERCISES: \(index + 1)/\(exercises.count)"
        laddersCount.text = "MAX. LADDER: 0"
        ladderUpButton.setTitle("1", for: .normal)
        isGoingUp = true
        ladderUpButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
        ladderUpButton.isEnabled = true
        ladderDownButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
        ladderDownButton.setTitle("", for: .normal)
        ladderDownButton.isEnabled = false
        repsCountLabel.text = "00"
        maxLadder = 0
        repsCount = 0
        reps = 0
        
        if index == exercises.count - 2 {
            nextExerciseLabel.text = "LAST EXERCISE    ----->"
            nextExercise.text = exercises[index + 1].name.uppercased() + "S"
        } else if index == exercises.count - 1 {
            nextExerciseLabel.text = ""
            nextExercise.text = "ALMOST DONE..."
        } else {
            nextExercise.text = exercises[index + 1].name.uppercased() + "S"
        }
        

    }
    
    //Initializes the clock to start counting the workout timing
    func startTimer() {
        
        if !timer.isValid {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LadderWorkoutViewController.updateTime), userInfo: nil, repeats: true)
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
        var interPassed: TimeInterval = currentTime - zeroTime - pausedSeconds - setLadder
        var ladderLeft = (workout.intTime[0] * 60) - interPassed + 1
        
        //If the clock has 10 secs or less to finish the interval, it becomes red.
        if ladderLeft <= 11 {
            
            remainIntervalLabel.tintColor = UIColor.red
            
        } else {
            
            remainIntervalLabel.tintColor = UIColor.black
        }
        
        if ladderLeft <= 0 {
            
            maxLadders.append(maxLadder)
            exReps.append(repsCount)
            
            if index < exercises.count - 1{
                setLadder += (workout.intTime[0] * 60)
                index += 1
                insertExerciseData()
            } else {
                timer.invalidate()
                self.performSegue(withIdentifier: "workoutResults", sender: self)
            }
        }
        
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let interMin = UInt8(interPassed / 60.0)
        interPassed -= (TimeInterval(interMin) * 60)
        let minsLeft = UInt8(ladderLeft / 60)
        ladderLeft -= (TimeInterval(minsLeft) * 60)
        
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let interSecs = UInt8(interPassed)
        interPassed -= TimeInterval(interSecs)
        let secsLeft = UInt8(Int(ladderLeft) % 60)
        ladderLeft -= TimeInterval(secsLeft)
        
        let strMinutes = String(format: "%02d", minutes)
        let strInterMins = String(format: "%02d", interMin)
        let strMinsLeft = String(format: "%02d", minsLeft)
        let strSeconds = String(format: "%02d", seconds)
        let strInterSecs = String(format: "%02d", interSecs)
        let strSecsLeft = String(format: "%02d", secsLeft)
        
        overallTimerLabel.text = "\(strMinutes):\(strSeconds)"
        intervalTimerLabel.text = "\(strInterMins):\(strInterSecs)"
        remainIntervalLabel.text = "\(strMinsLeft):\(strSecsLeft)"
    }
    
    //Stops or resumes the timer when the button is clicked. It also sets the elements when tapped
    @IBAction func pauseResumeTimer(_ sender: AnyObject) {
        
        if timeRunning && !timePaused {
            timer.invalidate()
            timePaused = true
            timeRunning = false
            pausedTime = Date()
            pauseButton.setTitle("RESUME", for: .normal)
            
            ladderUpButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
            ladderDownButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
            ladderUpButton.isEnabled = false
            ladderDownButton.isEnabled = false
            
        } else if !timeRunning && timePaused {
            let pausedSeconds = Date().timeIntervalSince(pausedTime!)
            pausedIntervals.append(pausedSeconds)
            pausedTime = nil
            
            if !timer.isValid {
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LadderWorkoutViewController.updateTime), userInfo: nil, repeats: true)
            }
            
            timePaused = false
            timeRunning = true
            pauseButton.setTitle("PAUSE", for: .normal)
            
            if isGoingUp {
                ladderUpButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
                ladderUpButton.isEnabled = true
            }
            if repsCount > 0 {
                ladderDownButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
                ladderDownButton.isEnabled = true
            }
        }
    }
    
    //Sets the amounts of reps in each state of the workout
    @IBAction func ladderButtonPressed(_ sender: UIButton) {
        if sender == ladderUpButton {
            isGoingUp = true
            ladderDownButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
            ladderDownButton.isEnabled = true
            reps += 1
            repsCount += reps
            ladderUpButton.setTitle(String(reps + 1), for: .normal)
            if reps <= 2{
                ladderDownButton.setTitle("1", for: .normal)
            } else {
                ladderDownButton.setTitle(String(reps - 1), for: .normal)
            }
            if reps > maxLadder {
                maxLadder = reps
                laddersCount.text = "MAX. LADDER: \(maxLadder)"
            }
        }
        if sender == ladderDownButton {
            if reps > 2 {
                isGoingUp = false
                ladderUpButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
                ladderUpButton.setTitle("", for: .normal)
                ladderUpButton.isEnabled = false
                reps -= 1
                repsCount += reps
                ladderDownButton.setTitle(String(reps - 1), for: .normal)
            } else if reps == 2{
                isGoingUp = false
                ladderUpButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
                ladderUpButton.isEnabled = true
                reps -= 1
                repsCount += reps
                ladderUpButton.setTitle(String(reps + 1), for: .normal)
                ladderDownButton.setTitle("1", for: .normal)
            } else {
                ladderUpButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
                ladderUpButton.isEnabled = true
                repsCount += reps
                ladderUpButton.setTitle(String(reps + 1), for: .normal)
                ladderDownButton.setTitle("1", for: .normal)
            }
        }
        repsCountLabel.text = String(repsCount)
    }
    
    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showLadderExercise"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! ExerciseDetailViewController
            destinationController.exercise =  exercises[index]
            destinationController.workoutFamily = workout.family
        }
        if segue.identifier == "workoutResults"{
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! LadderCompletedViewController
            
            destinationController.workout = workout
            destinationController.exercises = exercises
            destinationController.maxLadders = maxLadders
            destinationController.exReps = exReps
        }
    }
}
