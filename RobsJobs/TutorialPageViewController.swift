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
    var pageControl = UIPageControl()

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.NewPageViewController(page: "Page1"),
                self.NewPageViewController(page: "Page2"),
                self.NewPageViewController(page: "Page3"),
                self.NewPageViewController(page: "Page4"),
                ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        configurePageControl()
        
        if let initialViewController = orderedViewControllers.first {
            self.scrollToViewController(viewController: initialViewController)
        }
        
        tutorialDelegate?.tutorialPageViewController(tutorialPageViewController: self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController){
                scrollToViewController(viewController: nextViewController)
        }
    }
    
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
                           completion: {
                            (finished) -> Void in
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    func notifyTutorialDelegateOfNewIndex() {
        let pageContentViewController = viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
        if(orderedViewControllers.index(of: pageContentViewController)! == 3){
            self.pageControl.isHidden = true
        } else if (self.pageControl.isHidden == true){
            self.pageControl.isHidden = false
        }
        print("index value\(orderedViewControllers.index(of: pageContentViewController)!)")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func NewPageViewController(page: String) -> UIViewController {
        return UIStoryboard(name: "TutorialPage", bundle: nil).instantiateViewController(withIdentifier: "\(page)ViewController") as UIViewController
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
    
    //page view controller BEFORE
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        print("page view controller before")
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    //Page view controller AFTER
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        print("page view controller after")

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension TutorialPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
//        if let firstViewController = viewControllers?.first,
//            let index = orderedViewControllers.index(of: firstViewController) {
//            tutorialDelegate?.tutorialPageViewController(tutorialPageViewController: self, didUpdatePageIndex: index)
//        }
        notifyTutorialDelegateOfNewIndex()
    }
    
}

protocol TutorialPageViewControllerDelegate: class {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
