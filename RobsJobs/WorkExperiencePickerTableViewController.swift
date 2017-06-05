//
//  WorkExperiencePickerTableViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/10/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class WorkExperiencePickerTableViewController: UITableViewController {
    var workExperienceToPass: String = ""
    var workExperienceArray: [String] = ["0 - 1 Tahun",
                                         "1 - 3 Tahun",
                                         "3 - 5 Tahun",
                                         ">5 Tahun"]

    var selectedWorkExperience:String? {
        didSet {
            if let workExperience = selectedWorkExperience {
                selectedWorkExperienceIndex = workExperienceArray.index(of: workExperience)!
            }
        }
    }
    var selectedWorkExperienceIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workExperienceArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workExperienceCell", for: indexPath)
        cell.textLabel?.text = workExperienceArray[indexPath.row]
        
        if indexPath.row == selectedWorkExperienceIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedWorkExperienceIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedWorkExperience = workExperienceArray[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        workExperienceToPass = workExperienceArray[(indexPath.row)]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        // your new view controller should have property that will store passed value
        viewController.passedWorkExperienceValue = workExperienceToPass
        
    }
}
