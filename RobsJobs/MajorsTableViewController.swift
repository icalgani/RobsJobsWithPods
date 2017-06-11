//
//  MajorsTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 6/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class MajorsTableViewController: UITableViewController {

    let jsonRequest = JsonRequest()
    var majorsArray: [String] = []
    var majorsToPass: String = ""
    
    var selectedCell:String? {
        didSet {
            if let major = selectedCell {
                selectedCellIndex = majorsArray.index(of: major)!
            }
        }
    }
    var selectedCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "jurusan")
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
        return majorsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorsCell", for: indexPath)
        cell.textLabel?.text = majorsArray[indexPath.row]
        
        if indexPath.row == selectedCellIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedCellIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedCell = majorsArray[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedCell = majorsArray[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        majorsToPass = majorsArray[(indexPath.row)]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        // your new view controller should have property that will store passed value
        viewController.passedEducationValue = majorsToPass
    }
    
    func loadList(notification: NSNotification){
        //load data here
        print("majors to send is \(jsonRequest.majorsToSend)")
        majorsArray = jsonRequest.majorsToSend
        self.tableView.reloadData()
    }
}
