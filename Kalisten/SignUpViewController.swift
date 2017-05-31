//
//  SignUpViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HideShowPasswordTextFieldDelegate  {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameTaken: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailTaken: UILabel!
    @IBOutlet weak var passwordField: HideShowPasswordTextField!
    
    @IBOutlet var signUpView1:UIView!
    @IBOutlet var signUpView2:UIView!
    @IBOutlet var signUpView3:UIView!
    
    let newUser = PFUser()
    
    var view1isHidden = true
    var view2isHidden = true
    var view3isHidden = true
    
    var index = 0
    var usernameIsTaken = false
    var emailIsTaken = false
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage{
            profilePic.image = selectedImage
            profilePic.contentMode = .scaleAspectFill
            profilePic.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signUpView1.isHidden = view1isHidden
        signUpView2.isHidden = view2isHidden
        signUpView3.isHidden = view3isHidden
        
        self.usernameField.delegate = self
        self.emailField.delegate = self
        
        let gestureRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(selectPic))
        profilePic.addGestureRecognizer(gestureRecognizerOne)
        
        usernameTaken.backgroundColor = UIColor.white
        emailTaken.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Pick an image from photo image library
    func selectPic(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    // Show the user that their password is valid.
    func isValidPassword(_ password: String) -> Bool {
     return password.characters.count > 7
     }
    
    fileprivate func setupPasswordTextField() {
        
        passwordField.delegate = self
        passwordField.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        passwordField.clipsToBounds = true
        passwordField.font = UIFont(name: "AvenirNextCondensed-Medium", size: 17)
        
        passwordField.rightView?.tintColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.usernameField {
            
            let query = PFQuery(className: "_User")
            query.whereKey("username", equalTo: usernameField.text!)
            query.findObjectsInBackground { (objects, error) -> Void in
                if error == nil {
                    if (objects!.count > 0){
                        self.usernameIsTaken = true
                        self.usernameTaken.text = "TAKEN"
                        self.usernameTaken.backgroundColor = UIColor(red: 250/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)
                    } else {
                        self.usernameIsTaken = false
                        self.usernameTaken.text = "FREE"
                        self.usernameTaken.backgroundColor = UIColor(red: 100/255.0, green: 210/255.0, blue: 50/255.0, alpha: 1.0)
                    }
                } else {
                    print("Error: \(error) \(error?.localizedDescription)")
                }
            }
        }
        if textField == self.emailField {
            
            let query = PFQuery(className: "_User")
            query.whereKey("email", equalTo: emailField.text!)
            query.findObjectsInBackground { (objects, error) -> Void in
                if error == nil {
                    if (objects!.count > 0){
                        
                        self.emailIsTaken = true
                        self.emailTaken.text = "TAKEN"
                        self.emailTaken.backgroundColor = UIColor.red
                    } else {
                        
                        self.emailIsTaken = false
                        self.emailTaken.text = "FREE"
                        self.emailTaken.backgroundColor = UIColor.green
                    }
                } else {
                    
                    print("Error: \(error) \(error?.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: AnyObject) {
        
        var username = self.usernameField.text!.capitalized
        let firstName = self.firstNameField.text!.capitalized
        let lastName = self.lastNameField.text!.capitalized
        var email = self.emailField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var password = self.passwordField.text!
        
        // Validate the text fields
        if username.characters.count < 5 {
            
            let alertController = UIAlertController(title: "Username Invalid", message: "Username length mus be greater than five characters.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else if usernameIsTaken {
            
            let alertController = UIAlertController(title: "Username taken", message: "The username introduced already exists in the system. Choose another one.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else if email.characters.count < 8 {
            
            let alertController = UIAlertController(title: "Email Invalid", message: "Email length mus be greater than eigth characters.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else if emailIsTaken {
            
            let alertController = UIAlertController(title: "Email exists", message: "The email introduced belongs to another account registered in the system.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else if password.characters.count < 8 {
            
            let alertController = UIAlertController(title: "Password Invalid", message: "Password length mus be greater than five characters.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else {
            
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            newUser.username = username
            newUser["firstName"] = firstName
            newUser["lastName"] = lastName
            newUser.password = password
            newUser.email = finalEmail
            
            // Sign up the user asynchronously
            newUser.signUpInBackground(block: { (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((error) != nil) {
                    
                    let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion:nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Success", message: "Account created successfuly", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                        
                        self.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "unwindMyPlan", sender: self)
                    }
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion:nil)
    
                }
            })
        }
    }
}
