//
//  WorkoutDetailViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 10/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class WorkoutDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var family: UILabel!
    @IBOutlet var numExercises: UILabel!
    @IBOutlet var familyIconImageView: UIImageView!
    @IBOutlet var sets: UILabel!
    
    @IBOutlet var time: UILabel!
    @IBOutlet var intTime: UILabel!
    
    @IBOutlet var pqImproved: UILabel!
    @IBOutlet var level: UILabel!
    
    @IBOutlet var descrpt: UILabel!
    
    @IBOutlet var tableView: UITableView!

    
    var workout: Workout!
    
    private var WExercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* We enter the line below to avoid the following error:
          'NSInternalInconsistencyException', reason: 'unable to dequeue a cell with identifier Cell -must register a nib or a class for the identifier or connect a prototype cell in a storyboard'*/
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        loadExercisesFromWorkout()
        
        //Sets the header of the navigation bar with the workout's name
        title = workout.name.uppercased()
        
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
        
        //Depending of the amount of sets the label is set in plural or singular
        workout.numSets > 1 ? (sets.text = "\(workout.numSets) SETS PER EXERCISE") : (sets.text = "\(workout.numSets) SET PER EXERCISE")
        
        time.text = "\(workout.totalTime)"
        intTime.text = "\(workout.family.uppercased()): \(workout.intTime[1]) MIN."
        pqImproved.text = workout.improves.uppercased()
        
        descrpt.text = workout.description.uppercased()
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
        return WExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkoutDetailTableViewCell
        
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
        
        cell.backgroundColor = UIColor.white
        
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
