//
//  PlansTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class PlansTableViewController: UITableViewController, UISearchResultsUpdating {
    
    //Array to store the Routines from Parse as objects
    private var plans = [Plan]()
    
    var searchController = UISearchController()
    var searchResults:[Plan] = [Plan]()
    var searchActive: Bool = false
    
    @IBOutlet var addPlan: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Only guests cannot see the add button
        let current = PFUser.current()
        
        if current == nil {
            addPlan.isEnabled = false
            addPlan.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            addPlan.isEnabled = true
            addPlan.tintColor = UIColor.white
        }
        
        loadPlansFromParse()
        
        //Hide the navigation bar when scrolling down
        navigationController?.hidesBarsOnSwipe = true
        
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        
        self.refreshControl?.addTarget(self, action: #selector(RoutinesTableViewController.pullToRefresh(_:)), for: UIControlEvents.valueChanged)
        
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
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(loadPlansFromParse), for: UIControlEvents.valueChanged)
        
    }
    
    //Reloads the data from Parse and the tableview data when pulled down
    func pullToRefresh(_ refreshControl: UIRefreshControl) {
        
        loadPlansFromParse()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
            return plans.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! PlansTableViewCell
        
        // Determine if we get the exercises from search result or the original array
        let plan = (searchController.isActive) ? searchResults[indexPath.row] : plans[indexPath.row]
        
        // Configure the cell
        cell.nameLabel.text = plan.name.uppercased()
        cell.tarjetLabel.text = plan.tarjet.uppercased()
        cell.levelLabel.text = difficultyLevel(difficulty: plan.difficulty)
        cell.numWeeksLabel.text = "DAYS: \(plan.weeks.count)"
        cell.descriptionView.text = plan.description?.uppercased()
        
        tableView.separatorColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 0.3)
        
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
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! PlansTableViewCell
        
        cell.nameLabel.restartLabel()
        cell.tarjetLabel.restartLabel()
        cell.levelLabel.restartLabel()
        cell.numWeeksLabel.restartLabel()
        for cell in tableView.visibleCells as! [PlansTableViewCell] {
            cell.nameLabel.restartLabel()
            cell.tarjetLabel.restartLabel()
            cell.levelLabel.restartLabel()
            cell.numWeeksLabel.restartLabel()
        }
    }
    
    //Shows the delete option on swipe to remove the workout from Parse
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Delete workout", message: "The workout will be deleted permanently. Are you sure you want to delete it?",preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                let query = PFQuery(className: "Plan")
                query.whereKey("objectId", equalTo: self.plans[indexPath.row].planId)
                query.findObjectsInBackground { (objects, error) -> Void in
                    
                    if let error = error {
                        print("Error: \(error) \(error.localizedDescription)")
                        return
                    }
                    
                    if let objects = objects {
                        for object in objects {
                            object.deleteEventually()
                            
                            self.plans.remove(at: indexPath.row)
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
    
    //Prepare data from the selected workout to be shown in the detail view
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showPlanDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                let destinationController = segue.destination as! PlanDetailViewController
                
                destinationController.plan = (searchController.isActive) ? searchResults[indexPath.row] : plans[indexPath.row]
            }
        }
    }*/
    
    //Filter the contents to show by the characters typed
    func filterContent(for searchText: String) {
        
        var query: PFQuery<PFObject>!
        
        let nameQuery = PFQuery(className: "Plan")
        let tarjetsQuery = PFQuery(className: "Plan")
        
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
                        let plan = Plan(pfObject: object)
                        self.searchResults.append(plan)
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
    
    func loadPlansFromParse() {
        // Clear up the array
        plans.removeAll(keepingCapacity: false)
        tableView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Plan")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    
                    let plan = Plan(pfObject: object)
                    self.plans.append(plan)
                    
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
