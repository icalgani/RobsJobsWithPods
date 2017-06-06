//
//  ContainerViewController.swift
//  RobsJobs
//
//  Created by MacBook on 6/6/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var TutorialContainerView: UIView!
    @IBOutlet weak var TutorialPageControl: UIPageControl!
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TutorialPageControl.addTarget(self, action: #selector(self.didChangePageControlValue), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController?.tutorialDelegate = tutorialPageViewController as? TutorialPageViewControllerDelegate
        }
    }
    
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: TutorialPageControl.currentPage)
    }
}

extension ContainerViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        self.TutorialPageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        self.TutorialPageControl.currentPage = 2
    }
    
}
