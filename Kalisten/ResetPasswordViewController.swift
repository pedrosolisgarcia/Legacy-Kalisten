//
//  ResetPasswordViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordReset(_ sender: AnyObject) {
        let email = self.emailField.text!
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Send a request to reset a password
        PFUser.requestPasswordResetForEmail(inBackground: finalEmail)
        
        let alertController = UIAlertController(title: "Password Reset", message: "An email containing information on how to reset your password has been sent to \(finalEmail).", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
    }
}
