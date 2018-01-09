//
//  RoutinesTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class RoutinesTableViewController: UITableViewController, UISearchResultsUpdating {

    //Array to store the Routines from Parse as objects
    private var routines = [Routine]()
    
    var searchController = UISearchController()
    var searchResults:[Routine] = [Routine]()
    var searchActive: Bool = false
    
    @IBOutlet var addRoutine: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Only guests cannot see the add button
        let current = PFUser.current()
        
        if current == nil {
            addRoutine.isEnabled = false
            addRoutine.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            addRoutine.isEnabled = true
            addRoutine.tintColor = UIColor.white
        }
        
        loadRoutinesFromParse()
        
        //Hide the navigation bar when scrolling down
        navigationController?.hidesBarsOnSwipe = true
        
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "SEARCH ROUTINES..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.black
        
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.5)
        let selectorName = "loadRoutinesFromParse"
        refreshControl?.addTarget(self, action: Selector(selectorName), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the bar on swipe
        navigationController?.hidesBarsOnSwipe = true
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
            return routines.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! RoutinesTableViewCell
        
        // Determine if we get the routines from search result or the original array
        let routine = (searchController.isActive) ? searchResults[indexPath.row] : routines[indexPath.row]
        
        // Configure the cell
        cell.nameLabel.text = routine.name.uppercased()
        cell.familyLabel.text = routine.family.uppercased()
        cell.improvesLabel.text = routine.improves.uppercased()
        cell.numDayslLabel.text = "DAYS: \(routine.workouts.count)"
        cell.timeLabel.text = "TIME: \(routine.avgTime)MIN"
        cell.levelLabel.text = String(Functions.difficultyLevel(difficulty: routine.difficulty))
        
        tableView.separatorColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.3)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    //Shows the delete option on swipe to remove the routine from Parse
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Delete routine", message: "The routine will be deleted permanently. Are you sure you want to continue?",preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                let query = PFQuery(className: "Routine")
                query.whereKey("objectId", equalTo: self.routines[indexPath.row].routId)
                query.findObjectsInBackground { (objects, error) -> Void in
                    
                    if let error = error {
                        print("Error: \(error) \(error.localizedDescription)")
                        return
                    }
                    
                    if let objects = objects {
                        for object in objects {
                            object.deleteEventually()
                            
                            self.routines.remove(at: indexPath.row)
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
    
    //Prepare data from the selected routine to be shown in the detail view
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showRoutineDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                let destinationController = segue.destination as! RoutineDetailViewController
                
                destinationController.routine = (searchController.isActive) ? searchResults[indexPath.row] : routines[indexPath.row]
            }
        }
    }*/
    
    //Filter the contents to show by the characters typed
    func filterContent(for searchText: String) {
        
        var query: PFQuery<PFObject>!
        
        let nameQuery = PFQuery(className: "Routine")
        let tarjetsQuery = PFQuery(className: "Routine")
        
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
                        let routine = Routine(pfObject: object)
                        self.searchResults.append(routine)
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
    
    func loadRoutinesFromParse() {
        // Clear up the array
        routines.removeAll(keepingCapacity: false)
        tableView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Routine")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    //Filter routines objects that belong to strength type
                    query.whereKey("type", equalTo: "Strength")
                    let routine = Routine(pfObject: object)
                    self.routines.append(routine)
                    
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
