//
//  SkillsPickerTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/6/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class SkillsPickerTableViewController: UITableViewController {
    
    var skills:[String] = []
    let jsonRequest = JsonRequest()
    var numberOfSkillSelected: Int = 0
    
    var skillToPass:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "skill")
        
    }
    
    //refresh table when data from JsonRequest is ready
    func loadList(notification: NSNotification){
        //load data here
        skills = jsonRequest.skillToSend
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
        return skills.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath)
        cell.textLabel?.text = skills[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        
        if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell?.accessoryType = UITableViewCellAccessoryType.none
            numberOfSkillSelected -= 1
            skillToPass = skillToPass.filter {$0 != skills[indexPath.row]}
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            numberOfSkillSelected += 1
            // Get Cell Label
            skillToPass.append(skills[indexPath.row])
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        
        // your new view controller should have property that will store passed value
        viewController.passedSkillValue = skillToPass
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if(skillToPass.count>5){
            
            //create alert if theres more than 5 skills
            let alertController = UIAlertController(title: "Alert", message:
                "You can only pick 5 skill", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }else{
            return true
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
