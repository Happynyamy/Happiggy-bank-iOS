//
//  HomeViewControllerExtension.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/17.
//

import UIKit

extension HomeViewController: UIPageViewControllerDataSource {
    
    // TODO: ViewModel 로 옮기기
    /// 종료되지 않은 유리병의 존재 여부
    private var hasBottleInProgress: Bool { false }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0]
                as? BottleViewController {
                currentIndex = currentViewController.index
            }
        }
    }
    
    // swiftlint:disable force_cast
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let viewController: BottleViewController = viewController as! BottleViewController
        var index = viewController.index as Int
        
        if index <= 0 {
            return nil
        }
        index -= 1
        return self.makePageContentViewController(with: index)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let viewController: BottleViewController = viewController as! BottleViewController
        var index = viewController.index as Int
        let numberOfBottles = self.pageImages.count
        
        if  (index + 1 == numberOfBottles && self.hasBottleInProgress)
              || index >= numberOfBottles {
            return nil
        }
        
        index += 1
        
        if index == numberOfBottles {
            print("Add New Jar")
        }
        return self.makePageContentViewController(with: index)
    }
    // swiftlint:enable force_cast
}

extension HomeViewController: UIPageViewControllerDelegate { }
