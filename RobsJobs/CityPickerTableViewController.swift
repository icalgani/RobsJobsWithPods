//
//  CityPickerTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class CityPickerTableViewController: UITableViewController {
    var City:[String] = []
    
    var cityToPass: String = ""
    var passedProvinceID: String = ""
    let jsonRequest = JsonRequest()

    var selectedCity:String? {
        didSet {
            if let city = selectedCity {
                selectedCityIndex = City.index(of: city)!
            }
        }
    }
    var selectedCityIndex:Int?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "city/\(passedProvinceID)")
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
        return City.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = City[indexPath.row]
        
        if indexPath.row == selectedCityIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedCityIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedCity = City[indexPath.row]
        
        //update the checkmark for the current row
        let cellUpdate = tableView.cellForRow(at: indexPath)
        cellUpdate?.accessoryType = .checkmark
        
        // Get Cell Label
        cityToPass = City[(indexPath.row)]
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        // your new view controller should have property that will store passed value
        viewController.passedCityValue = cityToPass
        
    }
    
    func loadList(notification: NSNotification){
    //load data here
    City = jsonRequest.cityToSend
    self.tableView.reloadData()
    }
}
