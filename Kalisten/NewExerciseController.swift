//
//  NewExerciseController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class NewExerciseController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, /*UIPickerViewDataSource,*/ UIPickerViewDelegate {
    

    @IBOutlet var contentView: UIView!
    @IBOutlet var exerciseImageView: UIImageView!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var categoryTextField:UITextField!
    @IBOutlet var familyTextField:UITextField!
    @IBOutlet var difficultyTextField:UITextField!
    @IBOutlet var tarjetsTextField:UITextField!
    @IBOutlet var placeTextField:UITextField?
    @IBOutlet var pqTextField:UITextField?
    @IBOutlet var descriptionTextView:UITextView?
    
    var difficultyPicker = UIPickerView()
    var placeholderLabel: UILabel!
    var imagePicked = false
    var thumbPicked = false
    var isThumbImage = false
    
    let difficulties = ["SUPER EASY", "VERY EASY", "EASY", "NORMAL", "CHALLENGING", "HARD", "VERY HARD", "SUPER HARD", "PROFESSIONAL", "OLYMPIC"]
    
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
        let selectorName = "selectPic"
        let gestureRecognizerOne = UITapGestureRecognizer(target: self, action: Selector(selectorName))
        thumbnailImageView.addGestureRecognizer(gestureRecognizerOne)
        
        self.difficultyPicker.delegate = self
        self.nameTextField.delegate = self
        self.categoryTextField.delegate = self
        self.familyTextField.delegate = self
        self.tarjetsTextField.delegate = self
        self.placeTextField?.delegate = self
        
        self.pqTextField?.delegate = self
        
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
        if indexPath.row == 0{
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
    
    
    @IBAction func save(sender: AnyObject){
        
        
        if nameTextField.text == "" || categoryTextField.text == "" || familyTextField.text == "" || difficultyTextField.text == "" || tarjetsTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "We cant proceed because one of the mandatory fields is blank. Please check.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        }else{
            let exercise = PFObject(className: "Exercise")
            exercise["name"] = nameTextField.text?.capitalized
            exercise["category"] = categoryTextField.text?.capitalized
            exercise["family"] = familyTextField.text?.capitalized.components(separatedBy: ", ")
            exercise["difficulty"] = Functions.difficultyAmount(difficulty: self.difficultyTextField.text!)
            exercise["tarjets"] = tarjetsTextField.text?.capitalized.components(separatedBy: ", ")
            exercise["pq"] = pqTextField?.text?.capitalized.components(separatedBy: ", ")
            exercise["place"] = placeTextField?.text?.capitalized.components(separatedBy: ", ")
            exercise["description"] = descriptionTextView?.text.lowercased()
            
            // Save the image or the icon in case we introduce one
            let imageData = UIImagePNGRepresentation(self.exerciseImageView.image!)
            let thumbData = UIImagePNGRepresentation(self.thumbnailImageView.image!)
            
            if imageData != nil && self.imagePicked && self.thumbPicked{
                let imageFile = PFFile(name:"image.png", data:imageData!)
                exercise["imageDet"] = imageFile
                let thumbFile = PFFile(name:"thumb.png", data:thumbData!)
                exercise["image"] = thumbFile
            }
            if thumbData != nil && self.thumbPicked && !self.imagePicked{
                let thumbFile = PFFile(name:"thumb.png", data:thumbData!)
                exercise["image"] = thumbFile
            }
            if thumbData != nil && !self.thumbPicked && self.imagePicked{
                let imageFile = PFFile(name:"image.png", data:imageData!)
                exercise["imageDet"] = imageFile
            }
            
            // Add the exercise on Parse
            exercise.saveInBackground(block: { (success, error) -> Void in
                if (success) {
                    print("Successfully added the exercise.")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                }
            })
            
            dismiss(animated: true, completion: nil)
        }
    }
}
