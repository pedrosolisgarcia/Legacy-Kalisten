//
//  ExercisesTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 21/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class ExercisesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    //Array to store the exercises from Parse as objects
    private var exercises = [Exercise]()
    
    var searchController = UISearchController()
    var searchResults:[Exercise] = [Exercise]()
    var searchActive: Bool = false
    let current = PFUser.current()
    
    @IBOutlet var addExercise: UIBarButtonItem!
    
    //Return from the New Exercise View to the Exercise tableView
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Only admins can see the add button
        if current == nil {
            addExercise.isEnabled = false
            addExercise.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else if current?["isAdmin"] as! Bool == false{
            addExercise.isEnabled = false
            addExercise.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            addExercise.isEnabled = true
            addExercise.tintColor = UIColor.white
        }
        
        loadExercisesFromParse()
        
        //Hide the navigation bar when scrolling down
        //navigationController?.hidesBarsOnSwipe = true
        
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "SEARCH EXERCISES..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(loadExercisesFromParse), for: UIControlEvents.valueChanged)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        if searchController.isActive {
            return searchResults.count
        } else {
            return exercises.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        tableView.separatorColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.3)
        
        /*if(cell.isSelected){
            cell.contentView.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
            cell.nameLabel.textColor = UIColor.white
            cell.tarjetLabel.textColor = UIColor.white
            cell.pqLabel.textColor = UIColor.white
            cell.levelLabel.textColor = UIColor.white
        }else{
            cell.contentView.backgroundColor = UIColor.white
            cell.nameLabel.textColor = UIColor.black
            cell.tarjetLabel.textColor = UIColor.black
            cell.pqLabel.textColor = UIColor.black
            cell.levelLabel.textColor = UIColor.black
        }*/
        
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            if (current != nil) && (current?["isAdmin"] as! Bool == true){
                return true
            }
            else{
                return false
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! ExercisesTableViewCell
        
        cell.nameLabel.restartLabel()
        cell.tarjetLabel.restartLabel()
        cell.pqLabel.restartLabel()
        for cell in tableView.visibleCells as! [ExercisesTableViewCell] {
            cell.nameLabel.restartLabel()
            cell.tarjetLabel.restartLabel()
            cell.pqLabel.restartLabel()
        }
    }
    
    //Shows the delete option on swipe to remove the exercise from Parse
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Delete exercise", message: "The exercise will be deleted permanently. Are you sure you want to delete it?",preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                let query = PFQuery(className: "Exercise")
                query.whereKey("objectId", equalTo: self.exercises[indexPath.row].exId)
                query.findObjectsInBackground { (objects, error) -> Void in
                    
                    if let error = error {
                        print("Error: \(error) \(error.localizedDescription)")
                        return
                    }
                    
                    if let objects = objects {
                        for object in objects {
                            object.deleteEventually()
                            
                            self.exercises.remove(at: indexPath.row)
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
        
        //This is nice if you want to add a edit button later
        return [deleteAction]
    }
    
    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showExerciseDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                let destinationController = segue.destination as! ExerciseDetailViewController
                
                destinationController.exercise = (searchController.isActive) ? searchResults[indexPath.row] : exercises[indexPath.row]
            }
        }
    }
    
    //Filter the contents to show by the characters typed
    func filterContent(for searchText: String) {
        
        var query: PFQuery<PFObject>!
        
        let nameQuery = PFQuery(className: "Exercise")
        let familyQuery = PFQuery(className: "Exercise")
        let tarjetsQuery = PFQuery(className: "Exercise")
        let pqQuery = PFQuery(className: "Exercise")
        
        // Filter by search string
        nameQuery.whereKey("name", contains: searchText.capitalized)
        familyQuery.whereKey("family", contains: searchText.capitalized)
        tarjetsQuery.whereKey("tarjets", hasPrefix: searchText.capitalized)
        pqQuery.whereKey("pq", contains: searchText.capitalized)
        query = PFQuery.orQuery(withSubqueries: [nameQuery, familyQuery, tarjetsQuery, pqQuery])
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
        //query.order(byAscending: "family")
        query.addAscendingOrder("family")
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
            if let refreshControl = self.refreshControl {
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}
