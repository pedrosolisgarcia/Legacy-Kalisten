//
//  EditExerciseController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 20/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class EditExerciseController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var navigBar: UINavigationBar!
    @IBOutlet weak var navigItem: UINavigationItem!
    
    @IBOutlet var exerciseImageView: UIImageView!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var difficultyTextField:UITextField!
    @IBOutlet var categoryTextField:UITextField!
    @IBOutlet var familyTextField:UITextField!
    @IBOutlet var tarjetsTextField:UITextField!
    @IBOutlet var placeTextField:UITextField?
    @IBOutlet var objectTextField:UITextField?
    @IBOutlet var pqTextField:UITextField?
    @IBOutlet var descriptionTextView:UITextView?
    
    var placeholderLabel:UILabel!
    var imagePicked = false
    var thumbPicked = false
    var isThumbImage = false
    
    //Exercise received from segue
    var editExercise: Exercise!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage{
            
            if isThumbImage {
                thumbnailImageView.image = selectedImage
                thumbnailImageView.contentMode = .scaleAspectFit
                thumbnailImageView.clipsToBounds = true
                thumbPicked = true
            } else {
                exerciseImageView.image = selectedImage
                exerciseImageView.contentMode = .scaleAspectFit
                exerciseImageView.clipsToBounds = true
                imagePicked = true
            }
        }
        if !isThumbImage {
            
            let leadingConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.leading, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true
            
            let trailingConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.trailing, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
            
            let topConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.bottom, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(selectPic))
        thumbnailImageView.addGestureRecognizer(gestureRecognizerOne)
        
        // Do any additional setup after loading the view.
        navigItem.title = "EDIT " + editExercise.name.uppercased()
        
        // Load image in the detail view
        if let image = editExercise.image {
            thumbnailImageView.image = UIImage()
            exerciseImageView.image = UIImage()
            image.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.thumbnailImageView.image = UIImage(data: exerciseImageData)
                }
            })
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.clipsToBounds = true
        }
        if let imageDet = editExercise.imageDet {
            imageDet.getDataInBackground(block: { (imageData, error) in
                if let exerciseImageData = imageData {
                    self.exerciseImageView.image = UIImage(data: exerciseImageData)
                }
            })
            contentView.backgroundColor = UIColor.white
            exerciseImageView.contentMode = .scaleAspectFit
            exerciseImageView.clipsToBounds = true
            
            let leadingConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.leading, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true
            
            let trailingConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.trailing, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
            
            let topConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.bottom, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
            
        }
        self.nameTextField.delegate = self
        self.categoryTextField.delegate = self
        self.familyTextField.delegate = self
        self.tarjetsTextField.delegate = self
        self.placeTextField?.delegate = self
        self.objectTextField?.delegate = self
        self.pqTextField?.delegate = self
        self.difficultyTextField.delegate = self
        
        nameTextField.text = editExercise.name.uppercased()
        difficultyTextField.text = String(editExercise.difficulty)
        categoryTextField.text = editExercise.category.uppercased()
        let arrayFamily:NSArray = editExercise.family as NSArray
        familyTextField.text = arrayFamily.componentsJoined(by: ", ").uppercased()
        let arrayTajets:NSArray = editExercise.tarjets as NSArray
        tarjetsTextField.text = arrayTajets.componentsJoined(by: ", ").uppercased()
        let arrayPlace:NSArray? = editExercise.place as NSArray?
        placeTextField?.text = arrayPlace?.componentsJoined(by: ", ").uppercased()
        let arrayObject:NSArray? = editExercise.object as NSArray?
        objectTextField?.text = arrayObject?.componentsJoined(by: ", ").uppercased()
        let arrayPQ:NSArray? = editExercise.pq as NSArray?
        pqTextField?.text = arrayPQ?.componentsJoined(by: ", ").uppercased()
        descriptionTextView?.text = editExercise.description?.uppercased()
        
        descriptionTextView?.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "ENTER A DESCRIPTION:"
        placeholderLabel.font = UIFont(name: "AvenirNextCondensed-Regular", size: (descriptionTextView?.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionTextView?.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView?.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !(descriptionTextView?.text.isEmpty)!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !(descriptionTextView?.text.isEmpty)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Pick an image from photo image library
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            isThumbImage = false
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                isThumbImage = false
                present(imagePicker,animated: true,completion: nil)
            }
        }
    }
    
    func selectPic(_ sender: AnyObject) {
        
        isThumbImage = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    func exerciseDidChange() -> Bool{
        if (editExercise.name == nameTextField.text!) && (editExercise.difficulty == Int(difficultyTextField.text!)!) && (editExercise.category == categoryTextField.text!) && (editExercise.family == (familyTextField.text?.components(separatedBy: ", "))!) && (editExercise.tarjets == (tarjetsTextField.text?.components(separatedBy: ", "))!) && (editExercise.place! == (placeTextField?.text?.components(separatedBy: ", "))!) && (editExercise.object! == (objectTextField?.text?.components(separatedBy: ", "))!) && (editExercise.pq! == (pqTextField?.text?.components(separatedBy: ", "))!) && (editExercise.description! == (descriptionTextView?.text!)!){
            return false
        }else {
            return true
        }
    }
    
    //Prepare data from the exercise to be available for editing in the edit view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "exerciseEdited"{
            
            // Pass the selected object to the new view controller.
            let destinationController = segue.destination as! ExerciseDetailViewController
            destinationController.exercise = editExercise
        }
    }
    
    @IBAction func apply(sender: AnyObject){
        
        if exerciseDidChange(){
            
            if nameTextField.text == "" || categoryTextField.text == "" || familyTextField.text == "" || tarjetsTextField.text == "" || difficultyTextField.text == ""{
                let alertController = UIAlertController(title: "Editing Failed", message: "We cant proceed because one of the mandatory fields is blank. Please check.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion:nil)
            }else{
                let alertController = UIAlertController(title: "Changes Detected", message: "Some of the fields have been changed. Do you want to apply them?", preferredStyle: .alert)
                
                let applyAction = UIAlertAction(title: "Apply", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    
                    
                    let exerciseToUpdate = PFObject(withoutDataWithClassName: "Exercise", objectId: self.editExercise.exId)
                    
                    exerciseToUpdate["name"] = self.nameTextField.text?.capitalized
                    self.editExercise.name = (self.nameTextField.text?.capitalized)!
                    exerciseToUpdate["category"] = self.categoryTextField.text?.capitalized
                    self.editExercise.category = (self.categoryTextField.text?.capitalized)!
                    exerciseToUpdate["family"] = self.familyTextField.text?.capitalized.components(separatedBy: ", ")
                    self.editExercise.family = (self.familyTextField.text?.capitalized.components(separatedBy: ", "))!
                    exerciseToUpdate["difficulty"] = Int(self.difficultyTextField.text!)
                    self.editExercise.difficulty = Int(self.difficultyTextField.text!)!
                    exerciseToUpdate["tarjets"] = self.tarjetsTextField.text?.capitalized.components(separatedBy: ", ")
                    self.editExercise.tarjets = (self.tarjetsTextField.text?.capitalized.components(separatedBy: ", "))!
                    exerciseToUpdate["pq"] = self.pqTextField?.text?.capitalized.components(separatedBy: ", ")
                    self.editExercise.pq = self.pqTextField?.text?.capitalized.components(separatedBy: ", ")
                    exerciseToUpdate["place"] = self.placeTextField?.text?.capitalized.components(separatedBy: ", ")
                    self.editExercise.place = self.placeTextField?.text?.capitalized.components(separatedBy: ", ")
                    exerciseToUpdate["object"] = self.objectTextField?.text?.capitalized.components(separatedBy: ", ")
                    self.editExercise.object = self.objectTextField?.text?.capitalized.components(separatedBy: ", ")
                    exerciseToUpdate["description"] = self.descriptionTextView?.text.lowercased()
                    self.editExercise.description = self.descriptionTextView?.text.lowercased()
                    
                    // Save the image or the icon in case we introduce one
                    let imageData = UIImagePNGRepresentation(self.exerciseImageView.image!)
                    let thumbData = UIImagePNGRepresentation(self.thumbnailImageView.image!)
                    
                    
                    if imageData != nil && self.imagePicked && self.thumbPicked{
                        let imageFile = PFFile(name:"image.png", data:imageData!)
                        exerciseToUpdate["imageDet"] = imageFile
                        self.editExercise.imageDet = imageFile
                        let thumbFile = PFFile(name:"thumb.png", data:thumbData!)
                        exerciseToUpdate["image"] = thumbFile
                        self.editExercise.image = thumbFile
                        
                    }
                    if thumbData != nil && self.thumbPicked && !self.imagePicked{
                        let thumbFile = PFFile(name:"thumb.png", data:thumbData!)
                        
                        exerciseToUpdate["image"] = thumbFile
                        self.editExercise.image = thumbFile
                    }
                    if thumbData != nil && !self.thumbPicked && self.imagePicked{
                        let imageFile = PFFile(name:"image.png", data:imageData!)
                        exerciseToUpdate["imageDet"] = imageFile
                        self.editExercise.imageDet = imageFile
                    }
                    
                    // Update the exercise on Parse
                    exerciseToUpdate.saveInBackground(block: { (success, error) -> Void in
                        if (success) {
                            print("Changes applied successfully.")
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                        }
                    })
                    
                    self.performSegue(withIdentifier: "exerciseEdited", sender: self)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                    
                }
                alertController.addAction(applyAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion:nil)
                
            }
        }
    }
}
