//
//  CoreTabBarControler.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/8/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class CoreTabBarControler: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
//        var tabFrame = self.tabBar.frame
//        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
//        tabFrame.size.height = 30
//        tabFrame.origin.y = self.view.frame.size.height - 30
//        self.tabBar.frame = tabFrame
//        
        self.tabBar.backgroundColor = UIColor.white
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
