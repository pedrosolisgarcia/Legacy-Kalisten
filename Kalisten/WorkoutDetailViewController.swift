//
//  WorkoutDetailViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 10/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class WorkoutDetailViewController: UITableViewController  {
    
    @IBOutlet var family: UILabel!
    @IBOutlet var numExercises: UILabel!
    @IBOutlet var familyIconImageView: UIImageView!
    @IBOutlet var sets: UILabel!
    
    @IBOutlet var time: UILabel!
    @IBOutlet var intTime: UILabel!
    
    @IBOutlet var pqImproved: UILabel!
    @IBOutlet var level: UILabel!
    
    @IBOutlet var descrpt: UILabel!
    
    var workout: Workout!
    
    private var WExercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* We enter the line below to avoid the following error:
          'NSInternalInconsistencyException', reason: 'unable to dequeue a cell with identifier Cell -must register a nib or a class for the identifier or connect a prototype cell in a storyboard'*/
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        loadExercisesFromWorkout()
        
        //Sets the header of the navigation bar with the workout's name
        title = workout.name.uppercased()
        
        //The height of the cell will change according to the text length
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Set the cells content with the information from the selected workout
        family.text = "\(workout.family.uppercased()):"
        numExercises.text = "\(workout.numEx)"
        
        // Load familyIcon in the detail view
        familyIconImageView.image = UIImage()
        if let imageDet = workout.familyIcon {
            imageDet.getDataInBackground(block: { (imageData, error) in
                if let familyIconData = imageData {
                    self.familyIconImageView.image = UIImage(data: familyIconData)
                }
            })
        }
        
        sets.text = "\(workout.numSets)"
        
        time.text = "\(workout.totalTime)"
        intTime.text = "\(workout.family.uppercased()): \(workout.intTime[1]) MIN."
        pqImproved.text = workout.improves.uppercased()
        
        descrpt.text = workout.description
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! WorkoutDetailTableViewCell
        
        // Configure the cell
        cell.nameLabel.text = WExercises[indexPath.row].name.uppercased()
        
        // Load image in background
        cell.thumbnailImageView.image = UIImage()
        if let image = WExercises[indexPath.row].image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    cell.thumbnailImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }
        
        return cell
    }
    
    //Load the exercises from the selected Workout
    func loadExercisesFromWorkout() {
        // Clear up the array
        WExercises.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Exercise")
        //Filter exercises whoses Ids are contained in the workout array
        query.whereKey("objectId", containedIn: workout.exercises)
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
                    self.WExercises.append(exercise)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
