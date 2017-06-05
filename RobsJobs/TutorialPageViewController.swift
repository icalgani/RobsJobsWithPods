//
//  TutorialPageViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/11/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    
    var tutorialDelegate: TutorialPageViewControllerDelegate?

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.NewPageViewController(page: "page1"),
                self.NewPageViewController(page: "page2"),
                self.NewPageViewController(page: "page3"),
                self.NewPageViewController(page: "page4"),
                ]
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self as UIPageViewControllerDelegate
        
//        if let initialViewController = orderedViewControllers.first {
//            scrollToViewController(initialViewController)
//        }
        
//        tutorialDelegate?.tutorialPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        
//        if let visibleViewController = viewControllers?.first,
//            let nextViewController = pageViewController(self, viewControllerAfterViewController: visibleViewController) {
//            scrollToViewController(nextViewController)
//        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    func notifyTutorialDelegateOfNewIndex() {
//        if let firstViewController = viewControllers?.first,
//            let index = orderedViewControllers.index(of: firstViewController) {
//            tutorialDelegate?.tutorialPageViewController(self, didUpdatePageIndex: index)
//        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func NewPageViewController(page: String) -> UIViewController {
        return UIStoryboard(name: "TutorialPage", bundle: nil) .
            instantiateViewController(withIdentifier: "\(page)ViewController")
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

// MARK: UIPageViewControllerDataSource

extension TutorialPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

extension TutorialPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
    
}

protocol TutorialPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
