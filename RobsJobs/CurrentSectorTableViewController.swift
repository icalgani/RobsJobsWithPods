//
//  CurrentSectorTableViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/7/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class CurrentSectorTableViewController: UITableViewController {
    let jsonRequest = JsonRequest()
    var currentSectorArray: [String] = []
    var currentSectorToPass: String = ""
    
    var selectedSector:String? {
        didSet {
            if let sector = selectedSector {
                selectedSectorIndex = currentSectorArray.index(of: sector)!
            }
        }
    }
    var selectedSectorIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "employmentsector")
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        currentSectorArray = jsonRequest.employmentSectorToSend
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
        return currentSectorArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentSectorCell", for: indexPath)
        cell.textLabel?.text = currentSectorArray[indexPath.row]
        
        if indexPath.row == selectedSectorIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedSectorIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedSector = currentSectorArray[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedSector = currentSectorArray[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        currentSectorToPass = currentSectorArray[(indexPath.row)]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        // your new view controller should have property that will store passed value
        viewController.passedCurrentSectorValue = currentSectorToPass
        
    }

}
