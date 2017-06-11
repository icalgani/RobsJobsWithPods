//
//  CompetenceTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 6/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class CompetenceTableViewController: UITableViewController {

    var competences:[String] = []
    let jsonRequest = JsonRequest()
    var numberOfCompetenceSelected: Int = 0
    
    var CompetencesToPass:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "kompetensi")
    }
    
    //refresh table when data from JsonRequest is ready
    func loadList(notification: NSNotification){
        //load data here
        competences = jsonRequest.competenceToSend
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
        return competences.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompetenceCell", for: indexPath)
        cell.textLabel?.text = competences[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        
        if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell?.accessoryType = UITableViewCellAccessoryType.none
            numberOfCompetenceSelected -= 1
            CompetencesToPass = CompetencesToPass.filter {$0 != competences[indexPath.row]}
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            numberOfCompetenceSelected += 1
            // Get Cell Label
            CompetencesToPass.append(competences[indexPath.row])
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        
        // your new view controller should have property that will store passed value
        viewController.passedCompetenceValue = CompetencesToPass
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if(CompetencesToPass.count>5){
            
            //create alert if theres more than 5 skills
            let alertController = UIAlertController(title: "Alert", message:
                "You can only pick 5 competence", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }else{
            return true
        }
    }

}
