import UIKit
import Parse

class WorkoutsTableViewController: UITableViewController, UISearchResultsUpdating {
  
  //Array to store the workouts from Parse as objects
  var workouts = [Workout]()
  
  var searchController = UISearchController()
  var searchResults:[Workout] = [Workout]()
  var searchActive: Bool = false
  let current = PFUser.current()
  
  @IBOutlet var addWorkout: UIBarButtonItem!
  
  //Return from the New Workout View to the Exercise tableView
  @IBAction func unwindToWorkouts(segue:UIStoryboardSegue){}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Only guests cannot see the add button
    if current == nil {
      addWorkout.isEnabled = false
      addWorkout.tintColor = .clear
    } else {
      addWorkout.isEnabled = true
      addWorkout.tintColor = .white
    }
    
    loadWorkoutsFromParse()
    
    //Hide the navigation bar when scrolling down
    //navigationController?.hidesBarsOnSwipe = true
    
    //Remove the title of the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    
    // Add a search bar
    searchController = UISearchController(searchResultsController: nil)
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "SEARCH WORKOUTS..."
    searchController.searchBar.tintColor = .white
    searchController.searchBar.barTintColor = .black
    
    // Pull To Refresh Control
    refreshControl = UIRefreshControl()
    refreshControl?.backgroundColor = .white
    refreshControl?.tintColor = UIColor.estonianBlue.opacity(percentage: 50)
    let selectorName = "loadWorkoutsFromParse"
    refreshControl?.addTarget(self, action: Selector(selectorName), for: UIControl.Event.valueChanged)
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
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows
    if searchController.isActive {
      return searchResults.count
    } else {
      return workouts.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
      as! WorkoutsTableViewCell
    
    // Determine if we get the exercises from search result or the original array
    let workout = (searchController.isActive) ? searchResults[indexPath.row] : workouts[indexPath.row]
    
    // Configure the cell
    cell.nameLabel.text = workout.name.uppercased()
    cell.familyLabel.text = workout.type.uppercased()
    let arrayTarjet: NSArray? = workout.tarjets as NSArray?
    cell.tarjetLabel.text = arrayTarjet?.componentsJoined(by: ", ").uppercased()
    cell.numExlLabel.text = "EXERCISES: \(workout.exercises.count)"
    cell.timeLabel.text = "TIME: \(workout.totalTime)MIN"
    cell.levelLabel.text = String(Functions.difficultyLevel(difficulty: workout.difficulty))
    
    tableView.separatorColor = UIColor.estonianBlue.opacity(percentage: 30)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if searchController.isActive {
      return false
    } else {
      if (current != nil) && (current?["isAdmin"] as! Bool == true){
        return true
      } else if (current != nil) && (current?["isAdmin"] as! Bool == false) && (workouts[indexPath.row].user == current?.objectId){
        return true
      }else{
        return false
      }
    }
  }
  
  //Shows the delete option on swipe to remove the workout from Parse
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
  let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
      let alert = UIAlertController(title: "Delete workout", message: "The workout will be deleted permanently. Are you sure you want to delete it?",preferredStyle: .alert)
      
      let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
        
        let query = PFQuery(className: "Workout")
        query.whereKey("objectId", equalTo: self.workouts[indexPath.row].workId)
        query.findObjectsInBackground { (objects, error) -> Void in
          
          if let error = error {
            print("Error: \(error) \(error.localizedDescription)")
            return
          }
          
          if let objects = objects {
            for object in objects {
              object.deleteEventually()
              
              self.workouts.remove(at: indexPath.row)
              self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
          }
        }
      })
      
      let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
      
      alert.addAction(cancel)
      alert.addAction(delete)
      self.present(alert, animated: true, completion: nil)
      
    }
    
    let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

    return swipeActions
    
  }
  
  //Prepare data from the selected workout to be shown in the detail view
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    if segue.identifier == "showWorkoutDetail"{
      if let indexPath = tableView.indexPathForSelectedRow {
        // Pass the selected object to the new view controller.
        let destinationController = segue.destination as! WorkoutDetailViewController
        
        destinationController.workout = (searchController.isActive) ? searchResults[indexPath.row] : workouts[indexPath.row]
      }
    }
  }
  
  //Filter the contents to show by the characters typed
  func filterContent(for searchText: String) {
    
    var query: PFQuery<PFObject>!
    
    let nameQuery = PFQuery(className: "Workout")
    let tarjetsQuery = PFQuery(className: "Workout")
    
    // Filter by search string
    nameQuery.whereKey("name", contains: searchText.capitalized)
    tarjetsQuery.whereKey("tarjets", hasPrefix: searchText.capitalized)
    query = PFQuery.orQuery(withSubqueries: [nameQuery, tarjetsQuery])
    searchActive = true
    query.findObjectsInBackground { (objects, error) -> Void in
      if (error == nil) {
        self.searchResults.removeAll(keepingCapacity: false)
        
        if let objects = objects {
          for object in objects {
            let workout = Workout(pfObject: object)
            self.searchResults.append(workout)
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
  
  func loadWorkoutsFromParse() {
    // Clear up the array
    workouts.removeAll(keepingCapacity: false)
    tableView.reloadData()
    
    // Pull data from Parse
    var query: PFQuery<PFObject>!
    //Filter exercises objects that belong to strength type
    
    let typeQuery = PFQuery(className: "Workout")
    let userQuery = PFQuery(className: "Workout")
    
    typeQuery.whereKey("category", equalTo: "Strength")
    if current == nil {
      userQuery.whereKey("user", equalTo: "kalisten")
    }else {
      userQuery.whereKey("user", contains: "kalisten,\(String(describing: current?.objectId))")
    }
    query = PFQuery.orQuery(withSubqueries: [typeQuery, userQuery])
    
    
    query.cachePolicy = PFCachePolicy.networkElseCache
    query.findObjectsInBackground { (objects, error) -> Void in
      
      if let error = error {
        print("Error: \(error) \(error.localizedDescription)")
        return
      }
      
      if let objects = objects {
        for (index, object) in objects.enumerated() {
          let workout = Workout(pfObject: object)
          self.workouts.append(workout)
          
          let indexPath = IndexPath(row: index, section: 0)
          self.tableView.insertRows(at: [indexPath], with: .fade)
        }
        //fixes the issue in which the last element had the labels without the info.<<<
        self.tableView.reloadData()
      }
      if let refreshControl = self.refreshControl {
        if refreshControl.isRefreshing {
          refreshControl.endRefreshing()
        }
      }
    }
  }
}
