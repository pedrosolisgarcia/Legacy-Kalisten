//
//  NewExerciseController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class NewExerciseController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet var cell:NewExerciseViewCell!
    
    @IBOutlet var exerciseImageView: UIImageView!
    
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var familyTextField:UITextField!
    @IBOutlet var tarjetsTextField:UITextField!
    @IBOutlet var placeTextField:UITextField?
    @IBOutlet var objectTextField:UITextField?
    @IBOutlet var pqTextField:UITextField?
    @IBOutlet var descriptionTextView:UITextView?
    var placeholderLabel : UILabel!
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage{
            exerciseImageView.image = selectedImage
            exerciseImageView.contentMode = .scaleAspectFit
            exerciseImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.leading, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.trailing, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: exerciseImageView, attribute: NSLayoutAttribute.bottom, relatedBy:NSLayoutRelation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView?.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter a description:"
        placeholderLabel.font = UIFont(name: "AvenirNextCondensed-Regular", size: (descriptionTextView?.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionTextView?.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView?.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !(descriptionTextView?.text.isEmpty)!
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
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker,animated: true,completion: nil)
            }
        }
    }
    
    @IBAction func save(sender: AnyObject){

        
        if nameTextField.text == "" || typeTextField.text == "" || familyTextField.text == "" || tarjetsTextField.text == "" || cell.difficulty == 0{
            let alertController = UIAlertController(title: "Error", message: "We cant proceed because one of the mandatory fields is blank. Please check.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
        }else{
            let exercise = PFObject(className: "Exercise")
            exercise["name"] = nameTextField.text
            exercise["type"] = typeTextField.text
            exercise["family"] = familyTextField.text?.components(separatedBy: ", ")
            exercise["difficulty"] = cell.difficulty
            exercise["tarjets"] = tarjetsTextField.text?.components(separatedBy: ", ")
            exercise["pq"] = pqTextField?.text?.components(separatedBy: ", ")
            exercise["place"] = placeTextField?.text?.components(separatedBy: ", ")
            exercise["object"] = objectTextField?.text?.components(separatedBy: ", ")
            exercise["description"] = descriptionTextView?.text
            
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
