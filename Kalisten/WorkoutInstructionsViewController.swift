//
//  WorkoutInstructionsViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 04/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class WorkoutInstructionsViewController: UIViewController {
    
    @IBOutlet weak var instructions: UITextView!
    @IBOutlet weak var startButton: UIButton!
    
    var workout: Workout!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.instructions.text = workout.information?[1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Depending on the workout type, the button will forward us to the workout session appropiate
    @IBAction func startWorkout(_ sender: UIButton) {
        if workout.family == "Ladder" {
            self.performSegue(withIdentifier: "startLadderWorkout", sender: self)
        }
    }
    
    //The function will load the data in the workout screen selected by the button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "startLadderWorkout"{
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! LadderWorkoutViewController
            
            destinationController.ladderWorkout = workout
        }
    }
}
