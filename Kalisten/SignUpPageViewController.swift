//
//  SignUpPageViewController.swift
//  Kalisten
//
//  Created by Pedro Solís García on 29/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class SignUpPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var view1isHidden = [false, true, true]
    var view2isHidden = [true, false, true]
    var view3isHidden = [true, true, false]

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
        if let pageSignUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController {
            
            pageSignUpViewController.view1isHidden = view1isHidden[index]
            pageSignUpViewController.view2isHidden = view2isHidden[index]
            pageSignUpViewController.view3isHidden = view3isHidden[index]
            pageSignUpViewController.index = index
            
            return pageSignUpViewController
            
        }
        return nil
    }
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}
