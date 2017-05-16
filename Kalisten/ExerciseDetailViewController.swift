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
    
    @IBOutlet weak var tableViewInformation: UITableView!
    @IBOutlet weak var tableViewExecution: UITableView!
    @IBOutlet weak var tableViewTarjects: UITableView!
    
    var exercise: Exercise!
    
    @IBOutlet var exerciseSections: UISegmentedControl!
    
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var executionView: UIView!
    @IBOutlet weak var tarjetsView: UIView!
    
    //Switch between views when clicking the segments
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch exerciseSections.selectedSegmentIndex {
        case 0:
            informationView.isHidden = false
            executionView.isHidden = true
            tarjetsView.isHidden = true
        case 1:
            informationView.isHidden = true
            executionView.isHidden = false
            tarjetsView.isHidden = true
        case 2:
            informationView.isHidden = true
            executionView.isHidden = true
            tarjetsView.isHidden = false
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initialize the tableViews in separate ways
        /*tableViewInformation.dataSource = self
        tableViewInformation.delegate = self
        tableViewInformation.register(ExerciseDetailTableViewCell.self, forCellReuseIdentifier: "informationCell")*/
        
        /*tableViewExecution.dataSource = self
        tableViewExecution.delegate = self
        tableViewExecution.register(UITableViewCell.self, forCellReuseIdentifier: "executionCell")
        
        tableViewTarjects.dataSource = self
        tableViewTarjects.delegate = self
        tableViewTarjects.register(UITableViewCell.self, forCellReuseIdentifier: "tarjectsCell")*/
        
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
        
        informationView.isHidden = false
        executionView.isHidden = true
        tarjetsView.isHidden = true

        //Set the default dimension of the cells.
        tableViewInformation.estimatedRowHeight = 25
        //The height of the cell will change according to the text length
        tableViewInformation.rowHeight = UITableViewAutomaticDimension
        
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
    
    //Sets the number of rows of each tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.tableViewInformation {
            count = 5
        }
        
        /*if tableView == self.tableViewExecution {
            count =  4
        }
        
        if tableView == self.tableViewTarjects {
            count =  3
        }*/
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ExerciseDetailTableViewCell!
        
        if tableView == self.tableViewInformation {
            cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! ExerciseDetailTableViewCell
            
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

            
        }
        
        /*if tableView == self.tableViewExecution {
            cell = tableView.dequeueReusableCell(withIdentifier: "executionCell", for: indexPath) as! ExerciseDetailTableViewCell
            
        }
        
        if tableView == self.tableViewTarjects {
            cell = tableView.dequeueReusableCell(withIdentifier: "tarjectsCell", for: indexPath) as! ExerciseDetailTableViewCell
            
        }*/
        
        return cell!
    }

}
