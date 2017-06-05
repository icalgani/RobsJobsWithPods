//
//  EducationPickerTableViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/20/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class EducationPickerTableViewController: UITableViewController {

    let jsonRequest = JsonRequest()
    var educationArray: [String] = []
    var educationToPass: String = ""
    
    var selectedEducation:String? {
        didSet {
            if let education = selectedEducation {
                selectedEducationIndex = educationArray.index(of: education)!
            }
        }
    }
    var selectedEducationIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "education")
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
        return educationArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell", for: indexPath)
        cell.textLabel?.text = educationArray[indexPath.row]
        
        if indexPath.row == selectedEducationIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedEducationIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedEducation = educationArray[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedEducation = educationArray[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        educationToPass = educationArray[(indexPath.row)]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        // your new view controller should have property that will store passed value
        viewController.passedEducationValue = educationToPass
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        educationArray = jsonRequest.educationToSend
        self.tableView.reloadData()
    }

}
