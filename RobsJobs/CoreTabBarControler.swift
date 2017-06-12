//
//  CoreTabBarControler.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/8/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class CoreTabBarControler: UITabBarController {

    @IBOutlet weak var CoreTabBar: UITabBar!
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        let yNavBar = self.navigationController?.navigationBar.frame.size.height
        // yStatusBar indicates the height of the status bar
        let yStatusBar = UIApplication.shared.statusBarFrame.size.height
        // Set the size and the position in the screen of the tab bar
        CoreTabBar.frame = CGRect(x: 0,y: yStatusBar,width: CoreTabBar.frame.size.width,height: CoreTabBar.frame.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
