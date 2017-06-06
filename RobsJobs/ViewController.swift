//
//  ViewController.swift
//  RobsJobs
//
//  Created by MacBook on 3/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var CreateAccountButton: ButtonCustom!
    @IBOutlet weak var FacebookButton: ButtonCustom!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var UsernameTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    
    let Utility = UIUtility()
    var userDefaults = UserDefaults.standard

    
    @IBAction func backToStartingPoint(segue: UIStoryboardSegue) {
    }

    @IBAction func registerUser(segue: UIStoryboardSegue) {
    }
    
    @IBAction func DoLogin(_ sender: UIButton) {
        //check if email and pass is null
        
        if (UsernameTextfield.text == ""){
            
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
            print("else")
            var request = URLRequest(url: URL(string: "http://apidev.robsjobs.co/api/v1/user/login")!)
            
            //check login
            request.httpMethod = "POST"
            let postString = "email=\((UsernameTextfield.text)!)&password=\((PasswordTextfield.text)!)"
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
                            
                            DispatchQueue.main.async {
                                print("user id = \(jsonData["id"])")

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsernameTextfield.delegate=self
        PasswordTextfield.delegate=self
        
        //set background image
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "bg_landing")
//        self.view.insertSubview(backgroundImage, at: 0)
        
        //set status bar color
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserDataFromServer(userID: String){
        var request = URLRequest(url: URL(string: "http://apidev.robsjobs.co/api/v1/user/profile/\(userID)")!)
        
        //check login
        request.httpMethod = "GET"
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
                        
                        let jsonData = (json["data"]) as! [String:Any]
                        if jsonData["city"] == nil{
                            print("userID buat di kirim = \(jsonData["id"])")
                           
                            let userDictionary: [String:Any] = ["userID": jsonData["id"],"email": jsonData["email"], "userName": jsonData["name"], "mobile_number": jsonData["mobile_number"]]
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                        }else{
                            print("inside else city != nil")

                            //  set data to UserDefault
                            var userDictionary:[String: Any] = ["userID": jsonData["id"], "birthdate": jsonData["birthdate"], "curr_employment_sector": jsonData["curr_employment_sector"], "city": jsonData["city"], "province": jsonData["province"], "edu_level":jsonData["edu_level"], "employment_type": jsonData["employment_type"], "sectors": jsonData["sectors"]]
                            
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let image = jsonData["image"]{
                                userDictionary["image"] = String(describing: image)
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let skills = jsonData["skills"]{
                                userDictionary["skills"] = skills
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let bio = jsonData["bio"]{
                                userDictionary["bio"] = bio
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let portofolio = jsonData["portofolio"]{
                                userDictionary["portofolio"] = portofolio
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let email = jsonData["email"]{
                                userDictionary["email"] = email
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let userName = jsonData["name"]{
                                userDictionary["userName"] = userName
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let mobile_number = jsonData["mobile_number"]{
                                userDictionary["mobile_number"] = String(describing: mobile_number)
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                            
                            if let salary = jsonData["salary"] {
                                userDictionary["salary"] = String(describing: salary)
                            }
                            
                            if let salarymin = jsonData["salarymin"] {
                                userDictionary["salarymin"] = String(describing: salarymin)
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let salarymax = jsonData["salarymax"]{
                                userDictionary["salarymax"] = String(describing: salarymax)
                            }
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")

                            if let distance = jsonData["distance"]{
                                userDictionary["distance"] = distance
                            }
                            
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                        }
                        DispatchQueue.main.async {
                            let userDefaults = UserDefaults.standard
                            let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
                            print("value of dict[city] = \(userDictionary?["city"])")
                            if(userDictionary?["city"] != nil){
                                //go to FirstTimeLogin Storyboard
                                self.goToNextView(storyboardName: "Core", identifier: "SwipingScene")
                            }else{
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
}

