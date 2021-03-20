import UIKit
import Parse

class AddExercisesController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
  
  //Array to store the exercises from Parse as objects
  private var exercises = [Exercise]()
  var workoutView: String!
  
  var searchController = UISearchController()
  var searchResults:[Exercise] = [Exercise]()
  var searchActive: Bool = false
  
  @IBOutlet weak var navigBar: UINavigationBar!
  @IBOutlet weak var navigItem: UINavigationItem!
  
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadExercisesFromParse()
    
    //exerciseIsSelected = Array(repeating: false, count: 100)
    
    // Do any additional setup after loading the view.
    navigItem.title = "ADD EXERCISES"
    
    //Hide the navigation bar when scrolling down
    //navigationController?.hidesBarsOnSwipe = true
    
    //Remove the title of the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    
    // Add a search bar
    searchController = UISearchController(searchResultsController: nil)
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "SEARCH EXERCISES..."
    searchController.searchBar.tintColor = .white
    searchController.searchBar.barTintColor = .black
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //Hide the bar on swipe
    //navigationController?.hidesBarsOnSwipe = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // Return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows
    if searchController.isActive {
      return searchResults.count
    } else {
      return exercises.count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      as! ExercisesTableViewCell
    
    // Determine if we get the exercises from search result or the original array
    let exercise = (searchController.isActive) ? searchResults[indexPath.row] : exercises[indexPath.row]
    
    // Configure the cell
    cell.nameLabel.text = exercise.name.uppercased()
    let arrayTarjet:NSArray = exercise.tarjets as NSArray
    cell.tarjetLabel.text = arrayTarjet.componentsJoined(by: ", ").uppercased()
    let arrayPQ:NSArray? = exercise.pq as NSArray?
    cell.pqLabel.text = arrayPQ?.componentsJoined(by: ", ").uppercased()
    cell.levelLabel.text = difficultyLevel(difficulty: exercise.difficulty)
    
    // Load image in background
    cell.thumbnailImageView.image = UIImage()
    if let image = exercise.image {
      image.getDataInBackground(block: { (imageData, error) in
        if let exerciseImageData = imageData {
          cell.thumbnailImageView.image = UIImage(data: exerciseImageData)
        }
      })
    }
    
    
    
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
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if searchController.isActive {
      return false
    } else {
      return true
    }
  }
  
  @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
    if sender == cancelButton {
      if workoutView == "ExercisesNew" {
        self.performSegue(withIdentifier: "cancelToNew", sender: self)
      }
      if workoutView == "ExercisesEdit" {
        self.performSegue(withIdentifier: "cancelToEdit", sender: self)
      }
    }
    if sender == doneButton {
      if workoutView == "ExercisesNew" {
        self.performSegue(withIdentifier: "doneToNew", sender: self)
      }
      if workoutView == "ExercisesEdit" {
        self.performSegue(withIdentifier: "doneToEdit", sender: self)
      }
    }
  }
  
  //Prepare data from the selected exercise to be shown in the detail view
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    if segue.identifier == "doneToNew"{
      if let indexPath = tableView.indexPathsForSelectedRows {
        // Pass the selected object to the new view controller.
        let destinationController = segue.destination as! NewWorkoutController
        
        for index in indexPath {
          destinationController.exercises.append((searchController.isActive) ? searchResults[index.row] : exercises[index.row])
        }
      }
    }
    if segue.identifier == "doneToEdit"{
      if let indexPath = tableView.indexPathsForSelectedRows {
        // Pass the selected object to the new view controller.
        let destinationController = segue.destination as! EditWorkoutController
        
        for index in indexPath {
          destinationController.exercises.append((searchController.isActive) ? searchResults[index.row] : exercises[index.row])
        }
      }
    }
  }
  
  //Filter the contents to show by the characters typed
  func filterContent(for searchText: String) {
    
    var query: PFQuery<PFObject>!
    
    let nameQuery = PFQuery(className: "Exercise")
    let typeQuery = PFQuery(className: "Exercise")
    let tarjetsQuery = PFQuery(className: "Exercise")
    let pqQuery = PFQuery(className: "Exercise")
    
    // Filter by search string
    nameQuery.whereKey("name", contains: searchText.capitalized)
    typeQuery.whereKey("type", contains: searchText.capitalized)
    tarjetsQuery.whereKey("tarjets", hasPrefix: searchText.capitalized)
    pqQuery.whereKey("pq", contains: searchText.capitalized)
    query = PFQuery.orQuery(withSubqueries: [nameQuery, typeQuery, tarjetsQuery, pqQuery])
    searchActive = true
    query.findObjectsInBackground { (objects, error) -> Void in
      if (error == nil) {
        self.searchResults.removeAll(keepingCapacity: false)
        
        if let objects = objects {
          for object in objects {
            let exercise = Exercise(pfObject: object)
            self.searchResults.append(exercise)
            self.tableView.reloadData()
          }
        }
      }
      else{
        print("Error: \(String(describing: error)) \(String(describing: error?.localizedDescription))")
      }
      self.searchActive = false
    }
    
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      filterContent(for: searchText)
      tableView.reloadData()
    }
  }
  
  // MARK: Parse-related methods
  
  //Load the Exercise data from Parse to the object exercises
  func loadExercisesFromParse() {
    // Clear up the array
    exercises.removeAll(keepingCapacity: true)
    tableView.reloadData()
    
    // Pull data from Parse
    let query = PFQuery(className: "Exercise")
    //query.whereKey("type", equalTo: "Workout")
    query.cachePolicy = PFCachePolicy.networkElseCache
    query.findObjectsInBackground { (objects, error) -> Void in
      
      if let error = error {
        print("Error: \(error) \(error.localizedDescription)")
        return
      }
      
      if let objects = objects {
        for (index, object) in objects.enumerated() {
          // Convert PFObject into Trip object
          let exercise = Exercise(pfObject: object)
          self.exercises.append(exercise)
          
          let indexPath = IndexPath(row: index, section: 0)
          self.tableView.insertRows(at: [indexPath], with: .fade)
        }
      }
    }
  }
}
