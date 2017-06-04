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
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var blurEffectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shows the avatar if the user has one
        userAvatar.image = UIImage()
        if let avatar = PFUser.current()?["avatar"] as? PFFile {
            avatar.getDataInBackground(block: { (avatarData, error) in
                if let userAvatarData = avatarData {
                    self.userAvatar.image = UIImage(data: userAvatarData)
                }
            })
        } else {
            self.userAvatar.image = UIImage(named: "user")
        }
        
        // Show the current user's username
        if let pUserName = PFUser.current()?["username"] as? String {
            self.usernameLabel.text = "@" + pUserName
        } else {
            self.usernameLabel.text = "@username"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.view.subviews.count)
        if (PFUser.current() == nil) {
            
            self.userAvatar.image = UIImage(named: "user")
            self.usernameLabel.text = "@username"
            
            if (self.view.subviews.count <= 5) {
                
                //Add the Login subview
                let popLoginView = UIStoryboard(name: "profile", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
                self.addChildViewController(popLoginView)
                popLoginView.view.frame = self.view.frame
                self.view.addSubview(popLoginView.view)
                popLoginView.didMove(toParentViewController: self)
            }
            
        } else {
            
            if (self.view.subviews.count > 5){
                //self.view.subviews.removeLast()
            }
            
            //Shows the avatar if the user has one
            userAvatar.image = UIImage()
            if let avatar = PFUser.current()?["avatar"] as? PFFile {
                avatar.getDataInBackground(block: { (avatarData, error) in
                    if let userAvatarData = avatarData {
                        self.userAvatar.image = UIImage(data: userAvatarData)
                    }
                })
            } else {
                self.userAvatar.image = UIImage(named: "user")
            }
            
            // Show the current user's username
            if let pUserName = PFUser.current()?["username"] as? String {
                self.usernameLabel.text = "@" + pUserName
            } else {
                self.usernameLabel.text = "@username"
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
