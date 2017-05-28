//
//  ProfileViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 23/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    var blurEffectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the current visitor's username
        if let pUserName = PFUser.current()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        } else {
            self.userNameLabel.text = "@username"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (PFUser.current() == nil) {
            
            if (self.view.subviews.count == 5) {
                
                //Add the Login subview
                let popLoginView = UIStoryboard(name: "profile", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
                self.addChildViewController(popLoginView)
                popLoginView.view.frame = self.view.frame
                self.view.addSubview(popLoginView.view)
                popLoginView.didMove(toParentViewController: self)
            }
            
        } else {
            
            if let pUserName = PFUser.current()?["username"] as? String {
                self.userNameLabel.text = "@" + pUserName
            } else {
                self.userNameLabel.text = "@username"
            }
        }
    }
    
    @IBAction func logOutAction(_ sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        
        let alertController = UIAlertController(title: "Logged out Successfuly", message: "You have been disconnected from your acount. You can keep using Kalisten as a gest.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
        self.tabBarController?.selectedIndex = 2;
    }
}
