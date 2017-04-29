//
//  ExerciseDetailViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 09/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        else if let image = exercise.image {
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImageView.image = UIImage(data: exerciseImageData)
                }
            })
        }

        
        //Set the default dimension of the cells.
        tableView.estimatedRowHeight = 25
        //The height of the cell will change according to the text length
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Sets the header of the navigation bar to the exercise's name
        title = exercise.name.uppercased()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExerciseDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row{
        case 0:
            cell.fieldLabel.text = "NAME"
            cell.valueLabel.text = exercise.name.uppercased()
        case 1:
            cell.fieldLabel.text = "FAMILY"
            let arrayFamily:NSArray = exercise.family as NSArray
            cell.valueLabel.text = arrayFamily.componentsJoined(by: ", ").uppercased()
        case 2:
            cell.fieldLabel.text = "PLACE"
            let arrayPlace:NSArray = exercise.place as NSArray
            cell.valueLabel.text = arrayPlace.componentsJoined(by: ", ").uppercased()
        case 3:
            cell.fieldLabel.text = "PHYSICAL QUALITY"
            let arrayPQ:NSArray = exercise.pq as NSArray
            cell.valueLabel.text = arrayPQ.componentsJoined(by: ", ").uppercased()
        case 4:
            cell.fieldLabel.text = "TARJETS"
            let arrayTarjets:NSArray = exercise.tarjets as NSArray
            cell.valueLabel.text = arrayTarjets.componentsJoined(by: ", ").uppercased()
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.separatorColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
        
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
