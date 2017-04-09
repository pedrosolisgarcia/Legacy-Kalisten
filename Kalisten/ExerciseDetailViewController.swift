//
//  ExerciseDetailViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 09/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        if let imageDet = exercise.imageDet {
            imageDet.getDataInBackground(block: { (imageData, error) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Preven from hiding the bar on swipe
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExerciseDetailViewController
        
//        // Configure the cell...
//        switch indexPath.row{
//        case 0:
//            cell.fieldLabel.text = "Name"
//            cell.valueLabel.text = restaurant.name
//        case 1:
//            cell.fieldLabel.text = "Type"
//            cell.valueLabel.text = restaurant.type
//        case 2:
//            cell.fieldLabel.text = "Location"
//            cell.valueLabel.text = restaurant.location
//        case 3:
//            cell.fieldLabel.text = "Phone"
//            cell.valueLabel.text = restaurant.phone
//        case 4:
//            cell.fieldLabel.text = "Been here"
//            //CHAPTER 16: Added the rating field
//            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here defore. \(restaurant.rating)" : "No"
//        default:
//            cell.fieldLabel.text = ""
//            cell.valueLabel.text = ""
//        }
        
        tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.2)
        
        //cell.backgroundColor = UIColor.clear
        
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.separatorColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
        
        return cell
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
