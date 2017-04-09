//
//  ExerciseDetailViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 09/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tarjetLabel: UILabel!
    @IBOutlet var pqLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var exerciseImageView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    var exercise: Exercise!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load image in the detail view
        exerciseImageView.image = UIImage()
        if let image = exercise.image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }
        
        //Set the default dimension of the cells.
        //tableView.estimatedRowHeight = 36
        //The height of the cell will change according to the text length
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        //Sets the header of the navigation bar to the exercise's name
        title = exercise.name.uppercased()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
