import UIKit

class SignUpPageViewController: UIPageViewController, UIPageViewControllerDataSource {
  
  var view1isHidden = [false, true]
  var view2isHidden = [true, false]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the data source to itself
    dataSource = self

    // Create the first walkthrough screen
    if let startingViewController = contentViewController(at: 0) {
      setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! SignUpViewController).index
    index -= 1
    
    return contentViewController(at: index)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! SignUpViewController).index
    index += 1
    
    return contentViewController(at: index)
  }
  
  // MARK: - Helper Methods
  
  func contentViewController(at index: Int) -> SignUpViewController? {
    if index < 0 || index >= view1isHidden.count {
      return nil
    }
    
    // Create a new view controller and pass the suitable view in each case
    if let pageSignUp = storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController {
      
      pageSignUp.view1isHidden = view1isHidden[index]
      pageSignUp.view2isHidden = view2isHidden[index]
      pageSignUp.index = index
      
      return pageSignUp
    }
    return nil
  }
  
  func forward(index: Int) {
    if let nextViewController = contentViewController(at: index + 1) {
      setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
  }
}
