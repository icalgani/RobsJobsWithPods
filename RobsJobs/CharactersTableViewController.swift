//
//  CharactersTableViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class CharactersTableViewController: UITableViewController {
    
    var characters:[String] = []
    let jsonRequest = JsonRequest()
    var numberOfCharacterSelected: Int = 0
    var charactersToPass:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        jsonRequest.getDataFromServer(dataToGet: "interest")
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        characters = jsonRequest.characterToSend
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
        return characters.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        cell.textLabel?.text = characters[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        
        if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
        cell?.accessoryType = UITableViewCellAccessoryType.none
            numberOfCharacterSelected -= 1
            charactersToPass = charactersToPass.filter {$0 != characters[indexPath.row]}
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            numberOfCharacterSelected += 1
            // Get Cell Label
            charactersToPass.append(characters[indexPath.row])
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! SetupProfileViewController
        
        // your new view controller should have property that will store passed value
        viewController.passedCharacterValue = charactersToPass
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if(charactersToPass.count>5){
            
            //create alert if theres more than 5 character
            let alertController = UIAlertController(title: "Alert", message:
                "You can only pick 5 character", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
}
