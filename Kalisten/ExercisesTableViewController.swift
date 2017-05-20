//
//  ExercisesTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 21/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class ExercisesTableViewController: UITableViewController {
    
    //Array to store the exercises from Parse as objects
    private var exercises = [Exercise]()
    
    //Return from the New Exercise View to the Exercise tableView
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExercisesFromParse()
        
        //Hide the navigation bar when scrolling down
        navigationController?.hidesBarsOnSwipe = true
        
        //Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return exercises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! ExercisesTableViewCell
        
        // Configure the cell
        cell.nameLabel.text = exercises[indexPath.row].name.uppercased()
        let arrayTarjet:NSArray = exercises[indexPath.row].tarjets as NSArray
        cell.tarjetLabel.text = arrayTarjet.componentsJoined(by: ", ").uppercased()
        let arrayPQ:NSArray? = exercises[indexPath.row].pq as NSArray?
        cell.pqLabel.text = arrayPQ?.componentsJoined(by: ", ").uppercased()
        cell.levelLabel.text = difficultyLevel(difficulty: exercises[indexPath.row].difficulty)
        
        // Load image in background
        cell.thumbnailImageView.image = UIImage()
        if let image = exercises[indexPath.row].image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    cell.thumbnailImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }
        
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

    //Prepare data from the selected exercise to be shown in the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "showExerciseDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                let destinationController = segue.destination as! ExerciseDetailViewController
                
                destinationController.exercise =  exercises[indexPath.row]
            }
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
        //Filter exercises objects that belong to workout type
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
