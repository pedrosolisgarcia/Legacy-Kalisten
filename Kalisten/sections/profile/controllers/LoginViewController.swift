import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet var loginView: UIView!
  
  @IBAction func unwindToLogInScreen(_ segue:UIStoryboardSegue) {}
  var blurEffectView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.usernameField.delegate = self
    self.passwordField.delegate = self
    
    view.addDismissKeyboardListener()
    
    // Do any additional setup after loading the view.
    setupPasswordTextField()
    self.showModal()
    //Add blur effect to the background view
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    self.view.insertSubview(blurEffectView, belowSubview: loginView)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  // Sets the configuration for the password text field
  fileprivate func setupPasswordTextField() {
    
    passwordField.delegate = self
    passwordField.layer.borderColor = UIColor.lightGrey.cgColor
    passwordField.clipsToBounds = true
    passwordField.font = UIFont(name: "AvenirNextCondensed-Regular", size: 17)
    passwordField.rightView?.tintColor = .estonianBlue
  }
  
  @IBAction func loginAction(sender: AnyObject) {
    let username = self.usernameField.text!.lowercased()
    let password = self.passwordField.text!
    
    // Validate the text fields
    if username.count < 5 {
      
      let alertController = UIAlertController(title: "Username Invalid", message: "Username length mus be greater than five characters.", preferredStyle: .alert)
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
      
      // Send a request to login
      PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) -> Void in
        
        // Stop the spinner
        spinner.stopAnimating()
        
        if ((user) != nil) {
          let alertController = UIAlertController(title: "Loged In Successfully", message: "Your account has been logged in. Welcome back \(username)", preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_)in
            
            self.hideModal()
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
