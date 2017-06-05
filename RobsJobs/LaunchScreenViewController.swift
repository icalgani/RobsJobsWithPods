//
//  LaunchScreenViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/25/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.userDefaults.object(forKey: "userDictionary") != nil){
            let userDefaults = UserDefaults.standard
            let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]

            if(userDictionary?["city"] == nil){
                //go to FirstTimeLogin Storyboard
                goToNextView(storyboardName: "FirstTimeLogin", identifier: "SetUpProfile")
            }else{
                //go to FirstTimeLogin Storyboard
                goToNextView(storyboardName: "Core", identifier: "SwipingScene")
            }
        }else{
            goToNextView(storyboardName: "Main", identifier: "StartingPoint")
        }
    }
    
    func goToNextView(storyboardName: String, identifier: String){
        //go to FirstTimeLogin Storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
