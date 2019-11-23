//
//  NewExerciseController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class NewExerciseController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    

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
    
    var categoryPicker = UIPickerView()
    var familyPicker = UIPickerView()
    var difficultyPicker = UIPickerView()
    var tarjetsPicker = UIPickerView()
    var placePicker = UIPickerView()
    var pqPicker = UIPickerView()
    
    var placeholderLabel: UILabel!
    var imagePicked = false
    var thumbPicked = false
    var isThumbImage = false
    
    let categories = ["STRENGTH","CONDITIONING","CARDIO","FLEXIBILITY"]
    let families = ["PUSH-UP","PULL-UP","DIP","SQUAT","FRONT LEVER","BACK LEVER","HANDSTAND","PLANK","FLAG"]
    let difficulties = ["SUPER EASY", "VERY EASY", "EASY", "NORMAL", "CHALLENGING", "HARD", "VERY HARD", "SUPER HARD", "PROFESSIONAL", "OLYMPIC"]
    let tarjets = ["CHEST","BACK","BICEPS","TRICEPS","SHOULDERS","FOREARMS","LEGS","CORE"]
    let places = ["FLOOR","STRAIGHT BAR","PARALLEL BARS","PARALLETES","RINGS","BAND","WEIGHT","ELEVATED SURFACE"]
    let pqs = ["ISOMETRIC STRENGTH", "DYNAMIC STRENGTH","EXPLOSIVE STRENGTH","MOBILITY","ENDURANCE","BALANCE","STABILITY"]
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as?
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
            
            let leadingConstraint = NSLayoutConstraint(item: exerciseImageView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy:NSLayoutConstraint.Relation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true
            
            let trailingConstraint = NSLayoutConstraint(item: exerciseImageView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy:NSLayoutConstraint.Relation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
            
            let topConstraint = NSLayoutConstraint(item: exerciseImageView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy:NSLayoutConstraint.Relation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: exerciseImageView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem: exerciseImageView.superview, attribute:NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectorName = "selectPic"
        let gestureRecognizerOne = UITapGestureRecognizer(target: self, action: Selector(selectorName))
        thumbnailImageView.addGestureRecognizer(gestureRecognizerOne)
        
        //navigationController?.hidesBarsOnSwipe = true
        
        self.nameTextField.delegate = self
        self.categoryTextField.delegate = self
        self.familyTextField.delegate = self
        self.difficultyTextField.delegate = self
        self.tarjetsTextField.delegate = self
        self.placeTextField?.delegate = self
        self.pqTextField?.delegate = self
        
        self.categoryPicker.delegate = self
        self.familyPicker.delegate = self
        self.difficultyPicker.delegate = self
        self.tarjetsPicker.delegate = self
        self.placePicker.delegate = self
        self.pqPicker.delegate = self
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            self.pickData(textField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows = 0
        if pickerView == categoryPicker {
            numRows = categories.count
        }
        if pickerView == familyPicker {
            numRows = families.count
        }
        if pickerView == difficultyPicker {
            numRows = difficulties.count
        }
        if pickerView == tarjetsPicker {
            numRows = tarjets.count
        }
        if pickerView == placePicker {
            numRows = places.count
        }
        if pickerView == pqPicker {
            numRows = pqs.count
        }
        return numRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var value = ""
        if pickerView == categoryPicker {
            value = categories[row]
        }
        if pickerView == familyPicker {
            value = families[row]
        }
        if pickerView == difficultyPicker {
            value = difficulties[row]
        }
        if pickerView == tarjetsPicker {
            value = tarjets[row]
        }
        if pickerView == placePicker {
            value = places[row]
        }
        if pickerView == pqPicker {
            value = pqs[row]
        }
        return value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            categoryTextField.text = categories[row]
        }
        if pickerView == familyPicker {
            familyTextField.text = families[row]
        }
        if pickerView == difficultyPicker {
            difficultyTextField.text = difficulties[row]
        }
        if pickerView == tarjetsPicker {
            tarjetsTextField.text = tarjets[row]
        }
        if pickerView == placePicker {
            placeTextField?.text = places[row]
        }
        if pickerView == pqPicker {
            pqTextField?.text = pqs[row]
        }
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
    
    func pickData(_ textField : UITextField){
        
        // ToolBar
        let toolBar = UIToolbar()
        var done = ""
        var cancel = ""
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor(red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        if textField == categoryTextField {
            self.categoryPicker.backgroundColor = UIColor.lightGray
            textField.inputView = self.categoryPicker
            done = "doneCategory"
            cancel = "cancelCategory"
        }
        if textField == familyTextField {
            self.familyPicker.backgroundColor = UIColor.lightGray
            textField.inputView = self.familyPicker
            done = "doneFamily"
            cancel = "cancelFamily"
        }
        if textField == difficultyTextField {
            self.difficultyPicker.backgroundColor = UIColor.lightGray
            textField.inputView = self.difficultyPicker
            done = "doneDifficulty"
            cancel = "cancelDifficulty"
        }
        if textField == tarjetsTextField {
            self.tarjetsPicker.backgroundColor = UIColor.lightGray
            textField.inputView = self.tarjetsPicker
            done = "doneTarjets"
            cancel = "cancelTarjets"
        }
        if textField == placeTextField {
            self.placePicker.backgroundColor = UIColor.lightGray
            textField.inputView = self.placePicker
            done = "donePlace"
            cancel = "cancelPlace"
        }
        if textField == pqTextField {
            self.pqPicker.backgroundColor = UIColor.lightGray
            textField.inputView = self.pqPicker
            done = "donePQ"
            cancel = "cancelPQ"
        }
        
        
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: Selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: Selector(cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    func doneCategory() {
        categoryTextField.resignFirstResponder()
    }
    func doneFamily() {
        familyTextField.resignFirstResponder()
    }
    func doneDifficulty() {
        difficultyTextField.resignFirstResponder()
    }
    func doneTarjets() {
        tarjetsTextField.resignFirstResponder()
    }
    func donePlace() {
        placeTextField?.resignFirstResponder()
    }
    func donePQ() {
        pqTextField?.resignFirstResponder()
    }
    func cancelCategory() {
        categoryTextField.text = ""
        categoryTextField.resignFirstResponder()
    }
    func cancelFamily() {
        familyTextField.text = ""
        familyTextField.resignFirstResponder()
    }
    func cancelDifficulty() {
        difficultyTextField.text = ""
        difficultyTextField.resignFirstResponder()
    }
    func cancelTarjets() {
        tarjetsTextField.text = ""
        tarjetsTextField.resignFirstResponder()
    }
    func cancelPlace() {
        placeTextField?.text = ""
        placeTextField?.resignFirstResponder()
    }
    func cancelPQ() {
        pqTextField?.text = ""
        pqTextField?.resignFirstResponder()
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
            let imageData = self.exerciseImageView.image!.pngData()
            let thumbData = self.thumbnailImageView.image!.pngData()
            
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
    
    func hideKeyboard() {
        let selectorName = "dismissKeyboard"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(selectorName))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() { view.endEditing(true) }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
