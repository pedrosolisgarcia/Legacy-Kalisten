//
//  SignUpAuxViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 03/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class SignUpAuxViewController: UIViewController {
    
    //Variables that will keep the data to be saved
    var keepPic: UIImage!
    var keepUsername = "mierda"
    var keepFirstName = ""
    var keepLastName = ""
    var keepEmail = ""
    var keepPassword = ""
    var keepGender = ""
    var keepWeight = 0.0
    var weightUnit = ""
    var keepHeight = 0.0
    var heightUnit = ""
    var keepAge = 0
    var factor = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
