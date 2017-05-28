//
//  SignUpViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: AnyObject) {
        
        var username = self.usernameField.text!
        var password = self.passwordField.text!
        var email = self.emailField.text!
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Validate the text fields
        if username.characters.count < 5 {
            
            let alertController = UIAlertController(title: "Username Invalid", message: "Username length mus be greater than five characters.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else if password.characters.count < 8 {
            
            let alertController = UIAlertController(title: "Password Invalid", message: "Password length mus be greater than five characters.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)

            
        } else if email.characters.count < 8 {
            
            let alertController = UIAlertController(title: "Email Invalid", message: "Email length mus be greater than eigth characters.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
        } else {
            
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
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
