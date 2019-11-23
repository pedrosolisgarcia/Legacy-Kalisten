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
    @IBOutlet weak var userAvatarView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    var blurEffectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shows the avatar if the user has one
        userAvatar.image = UIImage()
        if let avatar = PFUser.current()?["avatar"] as? PFFile {
            avatar.getDataInBackground(block: { (avatarData, error) in
                if let userAvatarData = avatarData {
                    self.userAvatar.image = UIImage(data: userAvatarData)
                    self.userAvatarView.backgroundColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 0.5)
                }
            })
        } else {
            self.userAvatar.image = UIImage(named: "user")
        }
        
        // Show the current user's username, name and surname
        if let pUserName = PFUser.current()?["username"] as? String {
            self.usernameLabel.text = "@" + pUserName.uppercased()
        } else {
            self.usernameLabel.text = "@USERNAME"
        }
        if let pFirstName = PFUser.current()?["firstName"] as? String {
            if let pLastName = PFUser.current()?["lastName"] as? String {
                self.nameSurnameLabel.text = pFirstName.uppercased() + " " + pLastName.uppercased()
            } else {
                self.nameSurnameLabel.text = pFirstName.uppercased()
            }
            
        } else {
            self.nameSurnameLabel.text = "NAME SURNAME"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (PFUser.current() == nil) {
            
            self.userAvatar.image = UIImage(named: "user")
            self.usernameLabel.text = "@USERNAME"
            
            if (self.view.subviews.count <= 6) {
                
                //Add the Login subview
                let popLoginView = UIStoryboard(name: "profile", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
                self.addChild(popLoginView)
                popLoginView.view.frame = self.view.frame
                self.view.addSubview(popLoginView.view)
                popLoginView.didMove(toParent: self)
            }
            
        } else {
            
            if (self.view.subviews.count > 6){
                //self.view.subviews.removeLast()
            }
            //Shows the avatar if the user has one
            userAvatar.image = UIImage()
            if let avatar = PFUser.current()?["avatar"] as? PFFile {
                avatar.getDataInBackground(block: { (avatarData, error) in
                    if let userAvatarData = avatarData {
                        self.userAvatar.image = UIImage(data: userAvatarData)
                        self.userAvatarView.backgroundColor = UIColor(red: 0/255.0, green: 114/255.0, blue: 206/255.0, alpha: 0.5)
                    }
                })
            } else {
                self.userAvatar.image = UIImage(named: "user")
            }
            // Show the current user's username, name and surname
            if let pUserName = PFUser.current()?["username"] as? String {
                self.usernameLabel.text = "@" + pUserName.uppercased()
            } else {
                self.usernameLabel.text = "@USERNAME"
            }
            if let pFirstName = PFUser.current()?["firstName"] as? String {
                if let pLastName = PFUser.current()?["lastName"] as? String {
                    self.nameSurnameLabel.text = pFirstName.uppercased() + " " + pLastName.uppercased()
                } else {
                    self.nameSurnameLabel.text = pFirstName.uppercased()
                }
                
            } else {
                self.nameSurnameLabel.text = "NAME SURNAME"
            }
        }
        self.viewDidLoad()
    }
    
    @IBAction func logOutAction(_ sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        
        let alertController = UIAlertController(title: "Logged out Successfuly", message: "You have been disconnected from your acount. You can keep using Kalisten as a gest.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
        self.tabBarController?.selectedIndex = 2
    }
}
