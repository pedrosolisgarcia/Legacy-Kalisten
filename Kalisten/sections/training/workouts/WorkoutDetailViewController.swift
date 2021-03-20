import UIKit
import Parse

class WorkoutDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet var editButton: UIBarButtonItem!
  @IBOutlet var family: UILabel!
  @IBOutlet var numExercises: UILabel!
  @IBOutlet var familyIconImageView: UIImageView!
  @IBOutlet var sets: UILabel!
  
  @IBOutlet var time: UILabel!
  @IBOutlet var intTime: UILabel!
  
  @IBOutlet var pqImproved: UILabel!
  @IBOutlet var level: UILabel!
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var selectButton: UIButton!
  
  
  //Return from the Edit Workout to the Workout Detail Scene
  @IBAction func unwindToWorkoutDetail(segue:UIStoryboardSegue){
    if segue.identifier == "doneEditWorkout" {
      viewDidLoad()
    }
  }
  
  var workout: Workout!
  var exercises = [Exercise]()
  var workoutFamily: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    /* We enter the line below to avoid the following error:
      'NSInternalInconsistencyException', reason: 'unable to dequeue a cell with identifier Cell -must register a nib or a class for the identifier or connect a prototype cell in a storyboard'*/
    
    //Only admins can see the edit button
    let current = PFUser.current()
    
    if current == nil {
      editButton.isEnabled = false
      editButton.tintColor = .clear
    } else {
      editButton.isEnabled = true
      editButton.tintColor = .white
    }
    
    loadExercisesFromWorkout()
    
    
    //Sets the header of the navigation bar with the workout's name
    title = workout.name.uppercased()
    
    //Remove the title of the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    
    //let exercisesMultiplier = 1.0/CGFloat(workout.exercises.count)
    tableView.rowHeight = (tableView.frame.size.height - 64 - headerView.frame.size.height)*0.2
    //Set the cells content with the information from the selected workout
    family.text = "\(workout.type.uppercased()):"
    numExercises.text = "\(workout.exercises.count)"
    
    // Load familyIcon in the detail view
    familyIconImageView.image = UIImage(named: "\(workout.type.lowercased())")
    
    //Depending of the amount of sets the label is set in plural or singular
    workout.numSets > 1 ? (sets.text = "\(workout.numSets) SETS PER EXERCISE") : (sets.text = "\(workout.numSets) SET PER EXERCISE")
    
    time.text = "\(workout.totalTime)"
    intTime.text = "\(workout.type.uppercased()): \(workout.intTime[1]) MIN."
    pqImproved.text = workout.improves.uppercased()
    
    level.text = difficultyLevel(difficulty: workout.difficulty)
    
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
  
  // MARK: - Table view data source
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exercises.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkoutDetailTableViewCell
    
    // Configure the cell
    cell.nameLabel.text = exercises[indexPath.row].name.uppercased() + "S"
    
    // Load image in background
    cell.thumbnailImageView.image = UIImage()
    if let image = exercises[indexPath.row].image {
    //if let image = exercises_order[indexPath.row]?.image {
      image.getDataInBackground(block: { (imageData, error) in
        if let exerciseImageData = imageData {
          cell.thumbnailImageView.image = UIImage(data: exerciseImageData)
        }
      })
    }
    
    cell.backgroundColor = UIColor.white
    
    tableView.separatorColor = UIColor.estonianBlue.opacity(percentage: 30)
    
    return cell
  }
  
  func difficultyLevel(difficulty: Int)-> String {
    
    var diffLevel = ""
    
    switch difficulty {
    case 1: diffLevel = "SUPER EASY"
    case 2: diffLevel = "VERY EASY"
    case 3: diffLevel = "EASY"
    case 4: diffLevel = "NORMAL"
    case 5: diffLevel = "CHALLENGING"
    case 6: diffLevel = "HARD"
    case 7: diffLevel = "VERY HARD"
    case 8: diffLevel = "SUPER HARD"
    case 9: diffLevel = "PROFESSIONAL"
    case 10: diffLevel = "OLYMPIC"
    default:
      diffLevel = "DIFFICULTY"
    }
    
    return diffLevel
  }
  
  //Automatically deselect the cell when touched
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //Load the exercises from the selected Workout
  func loadExercisesFromWorkout() {
    // Clear up the array
    exercises.removeAll(keepingCapacity: true)
    tableView.reloadData()
    
    // Pull data from Parse
    let query = PFQuery(className: "Exercise")
    //Filter exercises whoses names are contained in the workout array
    query.whereKey("name", containedIn: workout.exercises)
    query.cachePolicy = PFCachePolicy.networkElseCache
    query.findObjectsInBackground { (objects, error) -> Void in
      
      if let error = error {
        print("Error: \(error) \(error.localizedDescription)")
        return
      }
      
      if let objects = objects {
        var objects_order = [PFObject]()
        for exercise in self.workout.exercises {
          for object in objects {
            let ex = Exercise(pfObject: object)
            if (ex.name == exercise){
              objects_order.append(object)
            }
          }
        }
        
        for (index, object) in objects_order.enumerated() {
          
          // Convert PFObject into Exercise object
          let exercise = Exercise(pfObject: object)
          self.exercises.append(exercise)
          
          let indexPath = IndexPath(row: index, section: 0)
          self.tableView.insertRows(at: [indexPath], with: .fade)
        }
        self.editButton.isEnabled = true
        self.selectButton.isEnabled = true
      }
    }
  }
    
  //Prepare data from the selected exercise to be shown in the detail view
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    if segue.identifier == "showWorkoutExercise"{
      if let indexPath = tableView.indexPathForSelectedRow {
        // Pass the selected object to the new view controller.
        let destinationController = segue.destination as! ExerciseDetailViewController
        
        destinationController.exercise =  exercises[indexPath.row]
      }
    }
    if segue.identifier == "editWorkout"{
      
      // Pass the selected object to the new view controller.
      let destinationController = segue.destination as! EditWorkoutController
      
      destinationController.workout = workout
      destinationController.exercises = exercises
    }
    if segue.identifier == "selectWorkout"{
      // Pass the selected object to the new view controller.
      let destinationController = segue.destination as! WorkoutInstructionsViewController
      
      destinationController.workout = workout
      destinationController.exercises = exercises
    }
  }
}
