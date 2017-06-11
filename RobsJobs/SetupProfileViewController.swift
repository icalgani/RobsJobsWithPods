//
//  SetupProfileViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController, UITextFieldDelegate, SSRadioButtonControllerDelegate {
    
    let Utility = UIUtility()

    
    var passedProvinceValue:String = "Province"
    var passedCityValue:String = ""
    var passedEducationValue: String = ""
    var passedSalaryValue:String = ""
    var passedCharacterValue:[String] = []
    var passedSkillValue:[String] = []
    var passedEmploymentValue:String = ""
    var passedDesiredSectorValue:String = ""
    var passedCurrentSectorValue:String = ""
    var provinceID: String = ""
    var passedWorkExperienceValue: String = ""
    var passedMajorsValue: String = ""
    var passedCompetenceValue:[String] = []
    var prevControllerFrom = 0
    
    var skillHeightConstraint: NSLayoutConstraint!
    var skillTopConstraint: NSLayoutConstraint!
    var skillHeightConstraintShow: NSLayoutConstraint!
    var skillTopConstraintShow: NSLayoutConstraint!
    
    
    var majorsHeightConstraint: NSLayoutConstraint!
    var majorsTopConstraint: NSLayoutConstraint!
    var majorsHeightConstraintShow: NSLayoutConstraint!
    var majorsTopConstraintShow: NSLayoutConstraint!
    
    var competenceHeightConstraint: NSLayoutConstraint!
    var competenceTopConstraint: NSLayoutConstraint!
    var competenceHeightConstraintShow: NSLayoutConstraint!
    var competenceTopConstraintShow: NSLayoutConstraint!
    
    @IBOutlet weak var TestTextfield: UITextField!
    
    @IBOutlet weak var Scrollview: UIScrollView!
    @IBOutlet weak var ContainerView: UIView!
    
    @IBOutlet weak var WorkExperienceInput: UITextField!
    @IBOutlet weak var EducationInput: UITextField!
    @IBOutlet weak var CharacterInput: FloatLabelTextField!
    @IBOutlet weak var ProvinceInput: UITextField!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var BirthdateInput: UITextField!
    @IBOutlet weak var CityInput: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var DescribeYourselfInput: UITextField!
    @IBOutlet weak var SkillsInput: UITextField!
    @IBOutlet weak var MajorsInput: UITextField!
    @IBOutlet weak var CompetenceInput: UITextField!
    
    
    @IBAction func goToTutorialPage(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        var userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if(validateData()){
            
            userDictionary?["userName"] = NameInput.text
            userDictionary?["birthdate"] = BirthdateInput.text
            userDictionary?["province"] = ProvinceInput.text
            userDictionary?["city"] = CityInput.text
            userDictionary?["bio"] = DescribeYourselfInput.text
            userDictionary?["edu_level"] = EducationInput.text
            if(EducationInput.text == "SD/SLTP" || EducationInput.text == "SMA"){
                userDictionary?["skills"] = SkillsInput.text
                userDictionary?.removeValue(forKey: "jurusan")
                userDictionary?.removeValue(forKey: "kompetensi")
            }else{
                userDictionary?["jurusan"] = MajorsInput.text
                userDictionary?["kompetensi"] = CompetenceInput.text
                userDictionary?.removeValue(forKey: "skills")
            }
            userDictionary?["experience"]  = WorkExperienceInput.text
            
            userDefaults.set(userDictionary, forKey: "userDictionary")

            let sendJson = SendJsonSetupProfile()
            sendJson.sendDataToAPI(userDictionary: userDictionary!)
            
            //close keypad
            view.endEditing(true)
            
            if(userDictionary?["city"] != nil){
                let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! UITabBarController
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = nextViewController
            }else{
            //go to tutorial page
            let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "profileSetting") as UIViewController
                
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nextViewController
            }
        }
    }
    
    func validateData() -> Bool {
        if (NameInput.text == "" || EducationInput.text == "" || BirthdateInput.text == "" || CityInput.text == "" || ProvinceInput.text == "" || DescribeYourselfInput.text == ""){
            
            showAlert(alertMessage: "Field must be filled")
            
            return false
        } else{
            return true
        }
    }
    
    func showAlert(alertMessage: String){
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //segue
    @IBAction func backToSetupProfile(segue: UIStoryboardSegue) {
        
        //if segue from province picker
        if(segue.source.isKind(of: ProvincePickerTableViewController.self))
        {
            let view2:ProvincePickerTableViewController = segue.source as! ProvincePickerTableViewController
            
            if(view2.valueToPass != ""){
                self.passedProvinceValue = view2.valueToPass
                ProvinceInput.text = passedProvinceValue
                self.provinceID = view2.idToPass
                let cityView = CityPickerTableViewController()
                cityView.passedProvinceID = provinceID
            }
            
            if(passedProvinceValue != "" && passedProvinceValue != "Province"){
                CityInput.isUserInteractionEnabled=true
            }
        }
        
        //if segue from City picker
        if(segue.source.isKind(of: CityPickerTableViewController.self)){
            let CityView:CityPickerTableViewController = segue.source as! CityPickerTableViewController
            
            if(CityView.cityToPass != ""){
                passedCityValue = CityView.cityToPass
                CityInput.text = passedCityValue
            }
        }
        
        //if segue from educationpicker
        if(segue.source.isKind(of: EducationPickerTableViewController.self)){
            let educationView:EducationPickerTableViewController = segue.source as! EducationPickerTableViewController
            
            if(educationView.educationToPass != ""){
                passedEducationValue = educationView.educationToPass
                EducationInput.text = passedEducationValue
            }
            
            setInputToHide()
        }
        
        //if segue from skills picker
        if(segue.source.isKind(of: SkillsPickerTableViewController.self)){
            let sourceView:SkillsPickerTableViewController = segue.source as! SkillsPickerTableViewController
            
            if(sourceView.skillToPass.count>0){
                passedSkillValue = sourceView.skillToPass
                let concatedString: String = passedSkillValue.joined(separator: ", ")
                SkillsInput.text = concatedString
            }
        }
        
        //if segue from majors
        if(segue.source.isKind(of: MajorsTableViewController.self)){
            let sourceView:MajorsTableViewController = segue.source as! MajorsTableViewController

            if(sourceView.majorsToPass != ""){
                passedMajorsValue = sourceView.majorsToPass
                MajorsInput.text = passedMajorsValue
            }
        }
        
        //if segue from competence picker
        if(segue.source.isKind(of: CompetenceTableViewController.self)){
            let sourceView:CompetenceTableViewController = segue.source as! CompetenceTableViewController
            
            if(sourceView.CompetencesToPass.count>0){
                passedCompetenceValue = sourceView.CompetencesToPass
                let concatedString: String = passedCompetenceValue.joined(separator: ", ")
                CompetenceInput.text = concatedString
            }
        }
        
        //if segue from WorkExperience
        if(segue.source.isKind(of: WorkExperiencePickerTableViewController.self)){
            let workExperienceView:WorkExperiencePickerTableViewController = segue.source as! WorkExperiencePickerTableViewController
            
            if(workExperienceView.workExperienceToPass != ""){
                passedWorkExperienceValue = workExperienceView.workExperienceToPass
                WorkExperienceInput.text = passedWorkExperienceValue
            }
        }

        
        //if segue from Characters picker
//        if(segue.source.isKind(of: CharactersTableViewController.self)){
//            let CharacterView:CharactersTableViewController = segue.source as! CharactersTableViewController
//            
//            if(CharacterView.charactersToPass.count>0){
//                passedCharacterValue = CharacterView.charactersToPass
//                let concatedPassedCharacterValue: String = passedCharacterValue.joined(separator: ", ")
//                CharacterInput.text = concatedPassedCharacterValue
//            }
//        }
    }
    
    @IBAction func setDateInput(_ sender: FloatLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if(userDictionary?["city"] != nil){
            setInputText()
        }
        
        //add done to birthdate datepicker
        addUIBarPad(textField: BirthdateInput)
        
        //disable City
        CityInput.isUserInteractionEnabled=false
        
        //add dropdown image
        ProvinceInput.delegate = self
        CityInput.delegate = self
        EducationInput.delegate = self
        WorkExperienceInput.delegate = self
        DescribeYourselfInput.delegate = self
        SkillsInput.delegate = self
        MajorsInput.delegate = self
        CompetenceInput.delegate = self
        
        //set keyboard
        NameInput.setLeftPaddingPoints(20)
        BirthdateInput.setLeftPaddingPoints(20)
        ProvinceInput.setLeftPaddingPoints(20)
        CityInput.setLeftPaddingPoints(20)
        EducationInput.setLeftPaddingPoints(20)
        WorkExperienceInput.setLeftPaddingPoints(20)
        DescribeYourselfInput.setLeftPaddingPoints(20)
        SkillsInput.setLeftPaddingPoints(20)
        MajorsInput.setLeftPaddingPoints(20)
        CompetenceInput.setLeftPaddingPoints(20)
        
        //set constraint
        setHeightTopConstraint()
//        setInputToHide()

        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setInputToHide()
    }
    
    func setInputToHide(){
        //hide competence and majors
        if(EducationInput.text == "SD/SLTP" || EducationInput.text == "SMA" || EducationInput.text == ""){
            //hide majors and competence input
            hideTextfield(itemToConstraint: MajorsInput, heightConstraintIdentifier: "majors height", topConstraintIdentifier: "majors top", toItem: SkillsInput, heightConstraintVar: majorsHeightConstraint, topConstraintVar: majorsTopConstraint)
            hideTextfield(itemToConstraint: CompetenceInput, heightConstraintIdentifier: "competence height", topConstraintIdentifier: "competence top", toItem: MajorsInput, heightConstraintVar: competenceHeightConstraint, topConstraintVar: competenceTopConstraint)
            
            //show skills input
            showTextfield(itemToConstraint: SkillsInput, heightConstraintShow: skillHeightConstraintShow, topConstraintShow: skillTopConstraintShow, heightConstraintVar: skillHeightConstraint, topConstraintVar: skillTopConstraint)
            
        }else{
            //hide skills input
            hideTextfield(itemToConstraint: SkillsInput, heightConstraintIdentifier: "skills height", topConstraintIdentifier: "skills top", toItem: EducationInput, heightConstraintVar: skillHeightConstraint, topConstraintVar: skillTopConstraint)
            
            //show majors and competence input
            showTextfield(itemToConstraint: MajorsInput, heightConstraintShow: majorsHeightConstraintShow, topConstraintShow: majorsTopConstraintShow, heightConstraintVar: majorsHeightConstraint, topConstraintVar: majorsTopConstraint)
            showTextfield(itemToConstraint: CompetenceInput, heightConstraintShow: competenceHeightConstraintShow, topConstraintShow: competenceTopConstraintShow, heightConstraintVar: competenceHeightConstraint, topConstraintVar: competenceTopConstraint)
        }
    }
    
    func setInputText(){
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if let username = userDictionary?["userName"]{
            NameInput.text = username as? String
        }
        
        if let birthdate = userDictionary?["birthdate"]{
            BirthdateInput.text = birthdate as? String
        }
        
        if let province = userDictionary?["province"] {
            ProvinceInput.text = province as? String
        }
        
        if let city = userDictionary?["city"]{
            CityInput.text = city as? String
        }
        
        if let edu_level = userDictionary?["edu_level"]{
            EducationInput.text = edu_level as? String
        }
        
        if let bio = userDictionary?["bio"]{
            DescribeYourselfInput.text = bio as? String
        }
        
        if let workExperience = userDictionary?["experience"]{
            WorkExperienceInput.text = workExperience as? String
        }
        
        if let skills = userDictionary?["skills"]{
            SkillsInput.text = skills as? String
        }
        
        if let jurusan = userDictionary?["jurusan"]{
            MajorsInput.text = jurusan as? String
        }
        
        if let kompetensi = userDictionary?["kompetensi"]{
            CompetenceInput.text = kompetensi as? String
        }
        
        
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification as Notification)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.ProvinceInput){
            performSegue(withIdentifier: "showProvincePicker", sender: self)
            return false
        }
        
        if(textField==self.CityInput){
            self.performSegue(withIdentifier: "showCityPicker", sender: self)
            return false
        }
        
        if(textField == self.EducationInput){
            performSegue(withIdentifier: "showEducationPicker", sender: self)
            return false
        }
        
        if(textField == self.WorkExperienceInput){
            performSegue(withIdentifier: "showWorkExperiencePicker", sender: self)
            return false
        }
        
//        if(textField == self.CharacterInput){
//            performSegue(withIdentifier: "showCharactersPicker", sender: self)
//            return false
//        }
//        
        if(textField == self.SkillsInput){
            performSegue(withIdentifier: "showSkillsPicker", sender: self)
            return false
        }
        
        if(textField == self.MajorsInput){
            performSegue(withIdentifier: "showMajorsPicker", sender: self)
            return false
        }
        if(textField == self.CompetenceInput){
            performSegue(withIdentifier: "showCompetencePicker", sender: self)
            return false
        }
    return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
//        
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        
//        dateFormatter.timeStyle = DateFormatter.Style.none

        BirthdateInput.text = dateFormatter.string(from: sender.date)
    }
    
    func addUIBarPad(textField: UITextField){
        let numberToolbar: UIToolbar = UIToolbar()
        
        numberToolbar.barStyle = UIBarStyle.blackTranslucent
        numberToolbar.items=[
        
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeNumpad))
        ]
        
        numberToolbar.sizeToFit()
        textField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
    }
    
    
    func closeNumpad() {
        BirthdateInput.resignFirstResponder()
    }
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        Scrollview.contentInset.bottom = adjustmentHeight
        Scrollview.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setHeightTopConstraint(){
        // SKILLS CONSTRAINT
        skillHeightConstraint = NSLayoutConstraint(item: SkillsInput,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 0.0)
        
        skillTopConstraint = NSLayoutConstraint(item: SkillsInput,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: EducationInput,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0.0)
        
        skillHeightConstraintShow = NSLayoutConstraint(item: SkillsInput,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 40.0)
        
        skillTopConstraintShow = NSLayoutConstraint(item: SkillsInput,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: EducationInput,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: 20.0)
        
        // MAJORS CONSTRAINT
        majorsHeightConstraint = NSLayoutConstraint(item: MajorsInput,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
        
        majorsTopConstraint = NSLayoutConstraint(item: MajorsInput,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: SkillsInput,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: 0.0)
        majorsHeightConstraintShow = NSLayoutConstraint(item: MajorsInput,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: 40.0)
        
        majorsTopConstraintShow = NSLayoutConstraint(item: MajorsInput,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: SkillsInput,
                                                 attribute: .bottom,
                                                 multiplier: 1.0,
                                                 constant: 20.0)
        // COMPETENCE CONSTRAINT
        competenceHeightConstraint = NSLayoutConstraint(item: CompetenceInput,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
        
        competenceTopConstraint = NSLayoutConstraint(item: CompetenceInput,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: MajorsInput,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: 0.0)
        
        competenceHeightConstraintShow = NSLayoutConstraint(item: CompetenceInput,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: 40.0)
        
        competenceTopConstraintShow = NSLayoutConstraint(item: CompetenceInput,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: MajorsInput,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 20.0)
    }
    
    func hideTextfield(itemToConstraint: UITextField, heightConstraintIdentifier: String, topConstraintIdentifier: String, toItem: UITextField, heightConstraintVar: NSLayoutConstraint, topConstraintVar: NSLayoutConstraint){
        
        let heightConstraintTemp = itemToConstraint.constraint(withIdentifier: heightConstraintIdentifier)
        let topConstraintTemp = itemToConstraint.constraint(withIdentifier: topConstraintIdentifier)
        
        topConstraintTemp?.isActive = false
        heightConstraintTemp?.isActive = false
        
        heightConstraintVar.isActive = true
        topConstraintVar.isActive = true
        
//        itemToConstraint.isHidden = true
    }
    
    func showTextfield(itemToConstraint: UITextField, heightConstraintShow: NSLayoutConstraint, topConstraintShow: NSLayoutConstraint, heightConstraintVar: NSLayoutConstraint, topConstraintVar: NSLayoutConstraint){
        
        heightConstraintVar.isActive = false
        topConstraintVar.isActive = false
        
        heightConstraintShow.isActive = true
        heightConstraintShow.isActive = true
        
//        itemToConstraint.isHidden = false
        itemToConstraint.layer.addBorder(edge: UIRectEdge.all, color: UIColor.black, thickness: 1)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityPicker" {
            let dvc = segue.destination as! UINavigationController
            let view = dvc.topViewController as! CityPickerTableViewController
            view.passedProvinceID = provinceID
        }
    }
 

}
