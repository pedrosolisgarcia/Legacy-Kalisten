import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HideShowPasswordTextFieldDelegate  {
  
  @IBOutlet var signUpView1:UIView!
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var usernameTaken: UILabel!
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var emailTaken: UILabel!
  @IBOutlet weak var passwordField: HideShowPasswordTextField!
  @IBOutlet weak var saveContButton: UIButton!
  
  @IBOutlet var signUpView2:UIView!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var femaleButton: UIButton!
  @IBOutlet weak var weightField: UITextField!
  @IBOutlet weak var pickWeightUnit: UIPickerView!
  @IBOutlet weak var heightField: UITextField!
  @IBOutlet weak var pickHeightUnit: UIPickerView!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var finishButton: UIButton!
  
  let newUser = PFUser()
  let profilePicPicker = UIImagePickerController()
  
  var view1isHidden = true
  var view2isHidden = true
  var index = 0
  
  var usernameIsTaken = false
  var emailIsTaken = false
  var avatarPicked = false
  var gender = ""
  var weightUnit = "KG"
  var heightUnit = "CM"
  var factor = 0.0
  
  var weightUnits = ["KG","LB"]
  var heightUnits = ["CM","IN"]
  
  var activityLevels = ["SEDENTARY","LIGHTLY ACTIVE","MODERATELY ACTIVE","VERY ACTIVE","EXTRA ACTIVE"]
  var factors = [1.2, 1.375, 1.55, 1.725, 1.9]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addDismissKeyboardListener()
    
    // Do any additional setup after loading the view.
    signUpView1.isHidden = view1isHidden
    signUpView2.isHidden = view2isHidden
    
    self.usernameField.delegate = self
    self.firstNameField.delegate = self
    self.lastNameField.delegate = self
    self.emailField.delegate = self
    self.passwordField.delegate = self
    self.weightField.delegate = self
    self.heightField.delegate = self
    self.ageField.delegate = self
    
    usernameTaken.backgroundColor = .clear
    emailTaken.backgroundColor = .clear
    
    pickWeightUnit.delegate = self
    pickWeightUnit.dataSource = self
    pickHeightUnit.delegate = self
    pickHeightUnit.dataSource = self
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorColor = UIColor.estonianBlue.opacity(percentage: 50)
    tableView.sectionIndexColor = .white
    tableView.sectionIndexBackgroundColor = .estonianBlue
    
    profilePicPicker.delegate = self
  }
  
  @IBAction func handleProfilePicTap(_ gesture: UITapGestureRecognizer) {
    profilePicPicker.allowsEditing = false
    profilePicPicker.sourceType = .photoLibrary

    present(profilePicPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      profilePic.image = pickedImage
      profilePic.contentMode = .scaleAspectFill
      profilePic.clipsToBounds = true
      avatarPicked = true
    }
   
    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func selectMaleGender(_ sender: UIButton) {
    
    maleButton.setTitleColor(.white, for: .normal)
    maleButton.backgroundColor = UIColor.estonianBlue.opacity(percentage: 50)
    femaleButton.setTitleColor(.black, for: .normal)
    femaleButton.backgroundColor = .white
    femaleButton.isSelected = false
    gender = "male"
  }
  
  @IBAction func selectFemaleGender(_ sender: UIButton) {
    
    femaleButton.setTitleColor(.white, for: .normal)
    femaleButton.backgroundColor = UIColor.estonianBlue.opacity(percentage: 50)
    maleButton.setTitleColor(.black, for: .normal)
    maleButton.backgroundColor = .white
    maleButton.isSelected = false
    gender = "female"
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
    return password.count > 7
  }
  
  fileprivate func setupPasswordTextField() {
    
    passwordField.delegate = self
    passwordField.layer.borderColor = UIColor.lightGrey.cgColor
    passwordField.clipsToBounds = true
    passwordField.font = UIFont(name: "AvenirNextCondensed-Medium", size: 17)
    
    passwordField.rightView?.tintColor = .estonianBlue
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if textField == self.usernameField {
      
      let query = PFQuery(className: "_User")
      query.whereKey("username", equalTo: usernameField.text!.lowercased())
      query.findObjectsInBackground { (objects, error) -> Void in
        if error == nil {
          if (objects!.count > 0){
            self.usernameIsTaken = true
            self.usernameTaken.text = "TAKEN"
            self.usernameTaken.textColor = .white
            self.usernameTaken.backgroundColor = .errorRed
          } else {
            
            if self.usernameField.text == "" {
              
              self.usernameIsTaken = false
              self.usernameTaken.textColor = .clear
              self.usernameTaken.backgroundColor = .clear
            } else {
              
              self.usernameIsTaken = false
              self.usernameTaken.text = "FREE"
              self.usernameTaken.textColor = .white
              self.usernameTaken.backgroundColor = .availableGreen
            }
          }
        } else {
          print("Error: \(String(describing: error)) \(String(describing: error?.localizedDescription))")
        }
      }
    }
    if textField == self.emailField {
      
      let query = PFQuery(className: "_User")
      query.whereKey("email", equalTo: emailField.text!.lowercased())
      query.findObjectsInBackground { (objects, error) -> Void in
        if error == nil {
          if (objects!.count > 0){
            
            self.emailIsTaken = true
            self.emailTaken.text = "TAKEN"
            self.emailField.textColor = .white
            self.emailTaken.backgroundColor = .errorRed
          } else {
            
            if self.emailField.text == "" {
              
              self.emailIsTaken = false
              self.emailField.textColor = .clear
              self.emailTaken.backgroundColor = .clear
            } else {
              
              self.emailIsTaken = false
              self.emailTaken.text = "FREE"
              self.emailField.textColor = .white
              self.emailTaken.backgroundColor = .availableGreen
            }
          }
        } else {
          
          print("Error: \(String(describing: error)) \(String(describing: error?.localizedDescription))")
        }
      }
    }
  }
  
  // Table view structure, containing the activity levels
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return activityLevels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SignUpTableViewCell
    
    // Configure the cell
    cell.activity.text = activityLevels[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let indexPath = tableView.indexPathForSelectedRow {
      self.factor = factors[indexPath.row]
    }
  }
  
  //Function to be called when the user has been added successfully to change to the next screen
  func moveForward() {
    let pageViewController = parent as! SignUpPageViewController
    pageViewController.forward(index: self.index)
  }
  
  @IBAction func signUpAction(_ sender: UIButton) {
    
    if sender == saveContButton {
      
      let username = self.usernameField.text!.lowercased()
      let firstName = self.firstNameField.text?.capitalized
      let lastName = self.lastNameField.text?.capitalized
      let email = self.emailField.text!.lowercased()
      let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      let password = self.passwordField.text!
      
      // Validate the text fields
      if username.count < 5 {
        
        let alertController = UIAlertController(title: "Username Invalid", message: "Username length mus be greater than five characters.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
      } else if usernameIsTaken {
        
        let alertController = UIAlertController(title: "Username taken", message: "The username introduced already exists in the system. Choose another one.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
      } else if email.count < 8 {
        
        let alertController = UIAlertController(title: "Email Invalid", message: "Email length mus be greater than eigth characters.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
      } else if emailIsTaken {
        
        let alertController = UIAlertController(title: "Email exists", message: "The email introduced belongs to another account registered in the system.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
      } else if password.count < 8 {
        
        let alertController = UIAlertController(title: "Password Invalid", message: "Password length mus be greater than five characters.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion:nil)
        
      } else {
        
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        // Save the avatar in case the user introduces one
        let imageData = self.profilePic.image!.pngData()
        if imageData != nil && self.avatarPicked {
          let imageFile = PFFile(name:"\(username).png", data:imageData!)
          newUser["avatar"] = imageFile
        }
        
        newUser.username = username
        newUser["firstName"] = firstName
        newUser["lastName"] = lastName
        newUser.email = finalEmail
        newUser.password = password
        
        // Sign up the user asynchronously
        newUser.signUpInBackground(block: { (succeed, error) -> Void in
          
          // Stop the spinner
          spinner.stopAnimating()
          
          if ((error) != nil) {
            
            let alertController = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:nil)
            
          } else {
            
            let alertController = UIAlertController(title: "Success", message: "Your account has been already created. In the following screen you will gather all the information related with body tracking.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
            }
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion:nil)
            
            self.moveForward()
          }
        })
      }
    }
    if sender == finishButton {
      
      let current = PFUser.current()
      
      if current != nil {
        
        if gender.count == 0 || weightField.text == "" || heightField.text == "" || ageField.text == "" || factor < 1 {
          
          let alertController = UIAlertController(title: "Information incomplete", message: "Part of the information required has not been filled. Please check and gather all the information required.", preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
          }
          
          alertController.addAction(alertAction)
          self.present(alertController, animated: true, completion:nil)
          
        } else {
          
          let weight = Double(weightField.text!)
          let height = Double(heightField.text!)
          let age = Int(ageField.text!)
          
          // Run a spinner to show a task in progress
          let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
          spinner.startAnimating()
          
          current?["bodyDataAdded"] = true
          current?["gender"] = gender.lowercased()
          current?["weight"] = weight
          current?["weightUnit"] = weightUnit.lowercased()
          current?["height"] = height
          current?["heightUnit"] = heightUnit.lowercased()
          current?["age"] = age
          current?["factor"] = factor
          current?["isAdmin"] = false
          
          // Sign up the user asynchronously
          current?.saveInBackground(block: { (succeed, error) -> Void in
            
            
            // Stop the spinner
            spinner.stopAnimating()
            
            if ((error) != nil) {
              
              let alertController = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
              let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              alertController.addAction(cancelAction)
              self.present(alertController, animated: true, completion:nil)
              
            } else {
              
              let alertController = UIAlertController(title: "Success", message: "Account created successfuly", preferredStyle: .alert)
              let alertAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
              }
              
              alertController.addAction(alertAction)
              self.present(alertController, animated: true, completion:nil)
            }
          })
        }
      }
    }
  }
}

extension SignUpViewController: UIPickerViewDataSource , UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return weightUnits.count
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    let unitLabel = UILabel()
    var unitData: String!
    
    pickerView == pickWeightUnit ? (unitData = weightUnits[row]) : (unitData = heightUnits[row])
    
    unitLabel.textAlignment = .center
    let myUnit = NSAttributedString(string: unitData, attributes: [NSAttributedString.Key.font:UIFont(name: "AvenirNextCondensed-Medium", size: 21)!])
    unitLabel.attributedText = myUnit
    
    return unitLabel
  }
  
  //Sets the space between elements by changing the row height
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 42
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == pickWeightUnit {weightUnit = weightUnits[row].lowercased()}
    if pickerView == pickHeightUnit {heightUnit = heightUnits[row].lowercased()}
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
