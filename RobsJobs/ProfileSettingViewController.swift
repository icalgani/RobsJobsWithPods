//
//  ProfileSettingViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/10/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SectorTextfield: UITextField!
    @IBOutlet weak var SalaryTextfield: UITextField!
    @IBOutlet weak var WorkTypeTextfield: UITextField!
    @IBOutlet weak var WorkTimeTextfield: UITextField!
    @IBOutlet weak var DistanceSlider: UISlider!
    
    var passedSalaryValue: String?
    var passedSalaryMinValue: String?
    var passedSalaryMaxValue: String?
    var passedCurrentSectorValue: String?
    var passedWorkTypeValue: String?
    var passedWorkTimeValue: String?
    var distanceValue: String?
    
    func validateData() -> Bool {
        if (SectorTextfield.text == "" || SalaryTextfield.text == "" || WorkTimeTextfield.text == ""){
            
            showAlert(alertMessage: "Field must be filled")
            
            return false
        } else{
            return true
        }
        return false
    }
    
    func showAlert(alertMessage: String){
        //show alert if there is empty field
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToProfileSettingSegue(segue: UIStoryboardSegue) {
        
        //if segue from Salary picker
        if(segue.source.isKind(of: SalaryPickerTableViewController.self)){
            let SalaryView:SalaryPickerTableViewController = segue.source as! SalaryPickerTableViewController
            
            if(SalaryView.salaryToPass != ""){
                passedSalaryValue = SalaryView.salaryToPass
                passedSalaryMaxValue = SalaryView.salaryMaxToPass
                passedSalaryMinValue = SalaryView.salaryMinToPass
                SalaryTextfield.text = passedSalaryValue
            }
        }
        
        //if segue from sector picker
        if(segue.source.isKind(of: CurrentSectorTableViewController.self)){
            let View:CurrentSectorTableViewController = segue.source as! CurrentSectorTableViewController
            
            if(View.currentSectorToPass != ""){
                passedCurrentSectorValue = View.currentSectorToPass
                SectorTextfield.text = passedCurrentSectorValue
            }
        }
        
        if(segue.source.isKind(of: EmploymentPickerTableViewController.self)){
            let View:EmploymentPickerTableViewController = segue.source as! EmploymentPickerTableViewController
            
            if(View.employmentToPass != ""){
                passedWorkTimeValue = View.employmentToPass
                WorkTimeTextfield.text = passedWorkTimeValue
            }
        }
        
        
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        let step: Float = 25.0
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setField()
        
        SectorTextfield.delegate = self
        SalaryTextfield.delegate = self
        WorkTimeTextfield.delegate = self
        WorkTypeTextfield.delegate = self
        
        SectorTextfield.setLeftPaddingPoints(30)
        SalaryTextfield.setLeftPaddingPoints(30)
        WorkTimeTextfield.setLeftPaddingPoints(30)
        WorkTypeTextfield.setLeftPaddingPoints(30)
    }
    
    func setField(){
        let userDefaults = UserDefaults.standard
        var userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if let sectors = userDictionary?["sectors"]{
            SectorTextfield.text = (userDictionary?["sectors"] as? String)
        }
        print(userDictionary?["salary"])
        if let salary = userDictionary?["salary"]{
            SalaryTextfield.text = (userDictionary?["salary"] as? String)
        }
        if let employment_type = userDictionary?["employment_type"]{
            WorkTimeTextfield.text = (userDictionary?["employment_type"] as! String)
        }
        if let distance = userDictionary?["distance"]{
            DistanceSlider.value = (userDictionary?["distance"] as! Float)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.SectorTextfield){
            performSegue(withIdentifier: "showSectorPicker", sender: self)
            return false
        }
        
        if(textField==self.SalaryTextfield){
            self.performSegue(withIdentifier: "showSalaryPicker", sender: self)
            return false
        }
        
//        if(textField == self.WorkTypeTextfield){
//            performSegue(withIdentifier: "showEducationPicker", sender: self)
//            return false
//        }
        
        if(textField == self.WorkTimeTextfield){
            performSegue(withIdentifier: "showWorkTImePicker", sender: self)
            return false
        }
    
        return true
    }

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if(validateData()){
            let userDefaults = UserDefaults.standard
            var userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
            
            userDictionary?["sectors"] = SectorTextfield.text
            userDictionary?["salary"] = SalaryTextfield.text
            userDictionary?["employment_type"] = WorkTimeTextfield.text
            userDictionary?["distance"] = DistanceSlider.value
            userDictionary?["salarymin"] = passedSalaryMinValue
            userDictionary?["salarymax"] = passedSalaryMaxValue
            userDefaults.set(userDictionary, forKey: "userDictionary")
            
            let sendJson = SendJsonSetupProfile()
            sendJson.sendDataToAPI(userDictionary: userDictionary!)
            
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
