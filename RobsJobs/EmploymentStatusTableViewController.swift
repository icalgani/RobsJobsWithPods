//
//  EmploymentStatusTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 6/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class EmploymentStatusTableViewController: UITableViewController {

    let jsonRequest = JsonRequest()
    var employmentStatus:[String] = []
    var employmentStatusToPass: String = ""
    
    var selectedEmploymentStatus:String? {
        didSet {
            if let employment = selectedEmploymentStatus {
                selectedEmploymentStatusIndex = employmentStatus.index(of: employment)!
            }
        }
    }
    
    var selectedEmploymentStatusIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "empstatus")
    }
    
    func loadList(notification: NSNotification){
        //load data here
        employmentStatus = jsonRequest.employmentStatusToSend
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
        return employmentStatus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "employmentStatusCell", for: indexPath)
        cell.textLabel?.text = employmentStatus[indexPath.row]
        print(employmentStatus[indexPath.row])
        if indexPath.row == selectedEmploymentStatusIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedEmploymentStatusIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedEmploymentStatus = employmentStatus[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedEmploymentStatus = employmentStatus[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        employmentStatusToPass = employmentStatus[indexPath.row]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! ProfileSettingViewController
        // your new view controller should have property that will store passed value
        viewController.passedWorkTypeValue = employmentStatusToPass
    }

}
