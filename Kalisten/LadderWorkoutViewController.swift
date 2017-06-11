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
    @IBOutlet weak var exerciseName: UILabel!
    
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
    
    @IBOutlet weak var nextExercise: UILabel!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    var timeRunning = Bool()
    var timePaused = Bool()
    var pausedTime: Date?
    var pausedIntervals = [TimeInterval]()
    
    var reps = 0
    var repsCount = 0
    var isGoingUp = true
    var maxLadder = [0,0,0,0]
    
    var workout: Workout!
    var exercises = [Exercise]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = workout.name.uppercased()
        
        exerciseName.text = "EXERCISE \(index + 1): \(exercises[index].name.uppercased())S"
        
        exercisesCount.text = "EXERCISES: \(index + 1)/\(exercises.count)"
        laddersCount.text = "MAX. LADDER: 0"
        ladderUpButton.setTitle("1", for: .normal)
        ladderDownButton.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
        ladderDownButton.setTitle("", for: .normal)
        ladderDownButton.isEnabled = false
        
        nextExercise.text = exercises[index + 1].name.uppercased() + "S"
        startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        
        if !timer.isValid {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LadderWorkoutViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        }
        
        timeRunning = true
        timePaused = false
        pausedIntervals = []
    }
    
    func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        var pausedSeconds = pausedIntervals.reduce(0) { $0 + $1 }
        if let pausedTime = pausedTime {
            pausedSeconds += Date().timeIntervalSince(pausedTime)
        }
        var timePassed: TimeInterval = currentTime - zeroTime - pausedSeconds
        var ladderTime = (workout.intTime[0] * 60) - timePassed + 1
        
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let minsLeft = UInt8(ladderTime / 60)
        ladderTime -= (TimeInterval(minsLeft) * 60)
        
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let secsLeft = UInt8(Int(ladderTime) % 60)
        ladderTime -= TimeInterval(secsLeft)
        
        let strMinutes = String(format: "%02d", minutes)
        let strMinsLeft = String(format: "%02d", minsLeft)
        let strSeconds = String(format: "%02d", seconds)
        let strSecsLeft = String(format: "%02d", secsLeft)
        
        overallTimerLabel.text = "\(strMinutes):\(strSeconds)"
        intervalTimerLabel.text = "\(strMinutes):\(strSeconds)"
        remainIntervalLabel.text = "\(strMinsLeft):\(strSecsLeft)"
    }
    
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
            if reps > maxLadder[index] {
                maxLadder[index] = reps
                laddersCount.text = "MAX. LADDER: \(maxLadder[index])"
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
        print(reps)
        repsCountLabel.text = String(repsCount)
    }
    
    /*@IBAction func startTimer(_ sender: AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()
    }*/
}
