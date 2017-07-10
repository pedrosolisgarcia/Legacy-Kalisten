//
//  LoginViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate/*, HideShowPasswordTextFieldDelegate*/ {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: HideShowPasswordTextField!
    @IBOutlet var loginView: UIView!
    @IBAction func unwindToLogInScreen(_ segue:UIStoryboardSegue) {}
    var blurEffectView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.removeFromSuperview()
        
        // Do any additional setup after loading the view.
        setupPasswordTextField()
        self.view.backgroundColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 0.4)
        self.showAnimate()
        //Add blur effect to the background view
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.view.insertSubview(blurEffectView, belowSubview: loginView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate()
    {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
        
    // Sets the configuration for the password text field 
    fileprivate func setupPasswordTextField() {
        
        passwordField.delegate = self
        passwordField.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        passwordField.clipsToBounds = true
        passwordField.font = UIFont(name: "AvenirNextCondensed-Regular", size: 17)
        passwordField.rightView?.tintColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 1.0)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text!.lowercased()
        var password = self.passwordField.text!
        
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
        
        } else {
            
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // Send a request to login
            PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    let alertController = UIAlertController(title: "Loged In Successfully", message: "Your account has been logged in. Welcome back \(username)", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (_)in
                        
                        self.removeAnimate()
                        self.view.willRemoveSubview(self.blurEffectView)
                        super.viewDidLoad()
                    })

                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion:nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error while logging in", message: "Invalid username or password. Please check your credentials and try again.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion:nil)
                }
            })
        }
    }
}
