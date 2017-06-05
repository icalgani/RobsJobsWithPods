//
//  SettingTableViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/10/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backAction))
    }
    
    func backAction(){
        print("Back Button Clicked")
        
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        if(indexPath == IndexPath(row: 0, section: 0)){
            let storyboard = UIStoryboard(name: "FirstTimeLogin", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SetUpProfile") as! SetupProfileViewController
            // Add your destination view controller name and Identifier
            
            self.present(controller, animated: true, completion: nil)
        }
        
        if(indexPath == IndexPath(row: 1, section: 0)){
            let storyboard = UIStoryboard(name: "Core", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "profileSetting") as! ProfileSettingViewController
            // Add your destination view controller name and Identifier
            
            // For example consider that there is an variable xyz in your destination View Controller and you are passing "ABC" values from current viewController.
            
            self.present(controller, animated: true, completion: nil)
        }
        
        if(indexPath == IndexPath(row: 0, section: 1)){
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "userDictionary")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as UIViewController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nextViewController
        }
    }
}
