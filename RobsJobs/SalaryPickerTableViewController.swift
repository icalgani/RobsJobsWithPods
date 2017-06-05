//
//  SalaryPickerTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class SalaryPickerTableViewController: UITableViewController {
    
    let jsonRequest = JsonRequest()
    var salaryArray: [String] = []
    var salaryMinArray: [String] = []
    var salaryMaxArray: [String] = []
    
    var salaryMinToPass: String = "0"
    var salaryMaxToPass: String = "0"
    var salaryToPass: String = ""
    
    var selectedSalary:String? {
        didSet {
            if let salary = selectedSalary {
                selectedSalaryIndex = salaryArray.index(of: salary)!
            }
        }
    }
    var selectedSalaryIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "salary")
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
        return salaryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "salaryCell", for: indexPath)
        cell.textLabel?.text = salaryArray[indexPath.row]
        
        if indexPath.row == selectedSalaryIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedSalaryIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedSalary = salaryArray[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedSalary = salaryArray[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        salaryToPass = salaryArray[(indexPath.row)]
        salaryMaxToPass = salaryMaxArray[indexPath.row]
        salaryMinToPass = salaryMinArray[indexPath.row]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        // your new view controller should have property that will store passed value
        viewController.passedSalaryValue = salaryToPass
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        salaryArray = jsonRequest.salaryToSend
        salaryMaxArray = jsonRequest.salaryMaxToSend
        salaryMinArray = jsonRequest.salaryMinToSend
        self.tableView.reloadData()
    }
}
