//
//  HomeViewControllerExtension.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? PageContentViewController {
                currentIndex = currentViewController.index
            }
        }
    }
    
    // swiftlint:disable force_cast
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let viewController: PageContentViewController = viewController as! PageContentViewController
        var index = viewController.index as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return self.makePageContentViewController(with: index)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let viewController: PageContentViewController = viewController as! PageContentViewController
        var index = viewController.index as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == self.pageImages.count {
            print("Add New Jar")
            return nil
        }
        return self.makePageContentViewController(with: index)
    }
    // swiftlint:enable force_cast
}

extension HomeViewController: UIPageViewControllerDelegate { }
