import UIKit

class WorkoutInstructionsViewController: UIViewController {
  
  @IBOutlet weak var instructions: UITextView!
  @IBOutlet weak var startButton: UIButton!
  
  var workout: Workout!
  var exercises = [Exercise]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.instructions.text = "Tips before training:\n\nAlways focus on perform each rep in a controlled motion, taking care of the technique. Remember that five reps perfectly performed count twice more that ten with poor execution."
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Depending on the workout type, the button will forward us to the workout session appropiate
  @IBAction func startWorkout(_ sender: UIButton) {
    if workout.type == "Ladder" {
      self.performSegue(withIdentifier: "startLadderWorkout", sender: self)
    }
    if workout.type == "Interval" {
      self.performSegue(withIdentifier: "startIntervalWorkout", sender: self)
    }
  }
  
  //The function will load the data in the workout screen selected by the button
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    if segue.identifier == "startLadderWorkout"{
      
      // Pass the selected object to the new view controller.
      let destinationController = segue.destination as! LadderWorkoutViewController
      destinationController.workout = workout
      destinationController.exercises = exercises
    }
    if segue.identifier == "startIntervalWorkout"{
      
      // Pass the selected object to the new view controller.
      let destinationController = segue.destination as! IntervalWorkoutViewController
      destinationController.workout = workout
      destinationController.exercises = exercises
    }
  }
}
