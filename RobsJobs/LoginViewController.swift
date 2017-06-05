//
//  LoginViewController.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var EmailPhoneNumberTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var CreateAccountButton: ButtonCustom!
    
    let Utility = UIUtility()
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var LoginButton: ButtonCustom!
    
    @IBAction func doLogin(_ sender: UIButton) {
        
        //check if email and pass is null
        if (EmailPhoneNumberTextfield.text == ""){
            
            //create alert if email is empty
            let alertController = UIAlertController(title: "Alert", message:
                "Email must be filled in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        
        }else if(PasswordTextfield.text == ""){
            
            //create alert if password is empty
            let alertController = UIAlertController(title: "Alert", message:
                "Password must be filled in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        
        }else{
            
            //close keypad
            view.endEditing(true)
            
            var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/login")!)
            
            //check login
            request.httpMethod = "POST"
            let postString = "email=\((EmailPhoneNumberTextfield.text)!)&password=\((PasswordTextfield.text)!)"
            request.httpBody = postString.data(using: .utf8)
            print("post string: \(postString)")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                //handling json
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            //if status code is not 200
                            let errorMessage = json["error"] as! [String:Any]
                            let currentErrorMessage = errorMessage["message"] as! String
                            print("status code: \(httpStatus.statusCode)")
                            //set alert if email or password is wrong
                            let alertController = UIAlertController(title: "Alert", message:
                                currentErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }else{
                            let jsonData = json["data"] as! [String:Any]
                            print("get ID")
                            DispatchQueue.main.async {
                                print("getuserdatafromserver")
                                self.getUserDataFromServer(userID: String(describing: jsonData["id"]!))
                                
                            }
                        } // if else
                    } //if json
                } catch let error {
                    print(error.localizedDescription)
                } // end do
                
            } //end task
            task.resume()
        }
    }
    
    func getUserDataFromServer(userID: String){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/profile/\(userID)")!)
        
        //check login
        request.httpMethod = "GET"
        print("get user data")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            //handling json
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        //if status code is not 200
                        print("status code: \(httpStatus.statusCode)")
                    }else{
                        if (self.userDefaults.object(forKey: "userDictionary") != nil){
                            print("theres user default")
                            self.userDefaults.removeObject(forKey: "userDictionary")
                        }
                        print("theres no user default")
                        let jsonData = (json["data"]) as! [String:Any]
                        print("value of jsondata[city] == nil is \(jsonData["city"] == nil) and != nil is \(jsonData["city"] != nil)")
                        if jsonData["city"] == nil{
                            let userDictionary: [String:Any] = ["userID": jsonData["id"],"email": jsonData["email"], "userName": jsonData["name"], "mobile_number": jsonData["mobile_number"]]
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                        }else{
//                        set data to UserDefault
                        let userDictionary:[String: Any] = ["userID": jsonData["id"], "birthdate": jsonData["birthdate"], "is_employed": jsonData["is_employed"], "curr_employment_sector": jsonData["curr_employment_sector"], "city": jsonData["city"], "province": jsonData["province"], "edu_level":jsonData["edu_level"], "interests": jsonData["interests"], "employment_type": jsonData["employment_type"], "sectors": jsonData["sectors"], "has_portofolio": jsonData["has_portofolio"], "has_work_experience": jsonData["has_work_experience"], "skills": jsonData["skills"], "bio": jsonData["bio"], "portofolio": jsonData["portofolio"], "email": jsonData["email"], "userName": jsonData["name"], "mobile_number": jsonData["mobile_number"], "image": jsonData["image"]]
                        self.userDefaults.set(userDictionary, forKey: "userDictionary")
                            
                            // Check if data exists
                            let userData = self.userDefaults.value(forKey: "userDictionary") as? [String: Any]
                            
                            print(userData?["city"])
                            print("jason data email = \((jsonData["email"])!)")
                        }
                        DispatchQueue.main.async {
                            let dict = self.userDefaults.object(forKey: "userDictionary") as? [String: String] ?? [String: String]()
                            
                            print("value dict[city] = \(dict["city"])")
                            if(dict["city"] != nil){
                                print("got dict[city] != null")
                                //go to FirstTimeLogin Storyboard
                                self.goToNextView(storyboardName: "Core", identifier: "SwipingScene")
                            }else{
                                print("goto else")
                                //go to FirstTimeLogin Storyboard
                                self.goToNextView(storyboardName: "FirstTimeLogin", identifier: "SetUpProfile")
                            }
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func goToNextView(storyboardName: String, identifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if(storyboardName == "Core"){
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as! UITabBarController
            appDelegate.window?.rootViewController = nextViewController
        }else {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as UIViewController
            appDelegate.window?.rootViewController = nextViewController
        }

    }
    
    @IBAction func goToLogin(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailPhoneNumberTextfield.delegate=self
        PasswordTextfield.delegate=self
        
        CreateAccountButton.whiteBorder()
        LoginButton.roundingButton()
        
        //create background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_login")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //change status bar color
        Utility.setStatusBarBackgroundColor(color: Utility.hexStringToUIColor(hex: "#d3d3d3"))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //press next to change to next tab
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
