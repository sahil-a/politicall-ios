//
//  TutorialPaginationViewController.swift
//  Politicall
//
//  Created by Sahil Ambardekar on 9/10/16.
//  Copyright © 2016 Pennhacks. All rights reserved.
//

import UIKit

class TutorialPaginationViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource  {
    
    var paginationViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...4 {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(i)")
            paginationViewControllers.append(viewController)
        }
        setViewControllers([paginationViewControllers.first!], direction: .Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = paginationViewControllers.indexOf(viewController)!
        if index == 0 {
            return nil
        }
        return paginationViewControllers[index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = paginationViewControllers.indexOf(viewController)!
        if index == paginationViewControllers.count - 1 {
            return nil
        }
        return paginationViewControllers[index + 1]
    }
}