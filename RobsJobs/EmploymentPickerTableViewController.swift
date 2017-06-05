//
//  EmploymentPickerTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/6/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class EmploymentPickerTableViewController: UITableViewController {
    
    let jsonRequest = JsonRequest()
    var employments:[String] = []
    var employmentToPass: String = ""
    
    var selectedEmployment:String? {
        didSet {
            if let employment = selectedEmployment {
                selectedEmploymentIndex = employments.index(of: employment)!
            }
        }
    }
    
    var selectedEmploymentIndex:Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "employmenttype")
    }
    
    func loadList(notification: NSNotification){
        //load data here
        employments = jsonRequest.desiredEmploymentToSend
        self.tableView.reloadData()
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
        return employments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "employmentCell", for: indexPath)
        cell.textLabel?.text = employments[indexPath.row]
        
        if indexPath.row == selectedEmploymentIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedEmploymentIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedEmployment = employments[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedEmployment = employments[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        employmentToPass = employments[indexPath.row]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! ProfileSettingViewController
        // your new view controller should have property that will store passed value
        viewController.passedWorkTimeValue = employmentToPass
    }
}
