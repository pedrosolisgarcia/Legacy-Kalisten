//
//  WorkoutListTableViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 01/04/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class TrainingViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    let navigationAndTabBarSize: CGFloat = 114.5
    
    @IBAction func unwindToTraining(segue:UIStoryboardSegue) -> Void {}

    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        self.fitCellsToScreenSize();
    }
    
    override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        //Prevent from hiding the bar on swipe
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() -> Void {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Load one by one the collection cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell\(indexPath.row + 1)", for: indexPath) as! TrainingCollectionViewCell
        // Configure the cell...
        cell.categoryLabel.text = getCollectionString(index: indexPath.row).localized()
        cell.backgroundColor = UIColor.estonianBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Load each table cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell\(indexPath.row + 1)") as! TrainingTableViewCell
        // Configure the cell...
        cell.rowLabel.text = "training.\(indexPath.row == 0 ? "training-plans" : "my-workouts")-section.title".localized()
        return cell
    }
    
    //Automatically deselect the collection cell when touched
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //Automatically deselect the table cell when touched
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getCollectionString(index: Int) -> String {
        switch index {
        case 0:
            return "training.strength-section.title"
        case 1:
            return "training.acrobatics-section.title"
        case 2:
            return "training.aerobics-section.title"
        case 3:
            return "training.mobility-section.title"
        default:
            return "SECTION"
        }
    }
    
    private func fitCellsToScreenSize() -> Void {
        let viewHeight = self.view.frame.size.height
        let viewWidth = self.view.frame.size.width
        let layout = UICollectionViewFlowLayout()
        let cellSize = (viewWidth - 1) * 0.5

        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.frame.size.height = viewWidth
        tableView.frame.size.height = (viewHeight - viewWidth - navigationAndTabBarSize)
        tableView.rowHeight = tableView.frame.size.height * 0.5
        tableView.separatorColor = UIColor.white
    }
}
