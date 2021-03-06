//
//  ViewController.swift
//  RobsJobs
//
//  Created by MacBook on 3/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var CreateAccountButton: ButtonCustom!
    @IBOutlet weak var FacebookButton: ButtonCustom!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var UsernameTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    
    let Utility = UIUtility()
    let loginData = LoginData()
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
            loginData.userLoginRequest(username: UsernameTextfield.text!, password: PasswordTextfield.text!)
        }
    }
    
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
                req.start({(connection, result) -> Void in
                    
                    switch result {
                    case .failed(let error):
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            print(responseDictionary)
                            
                            print(responseDictionary["name"]!)
                            print(responseDictionary["id"]!)
                            print(responseDictionary["email"]!)
                            print("access token = \(accessToken.authenticationToken)")
                            
                            self.loginData.userLoginWithFacebookRequest(userName: responseDictionary["name"]! as! String, userEmail: responseDictionary["email"]! as! String, userFbId: responseDictionary["id"]! as! String, userFbToken: accessToken.authenticationToken as String)
                        }
                    }
//                    print("result \(result)")
//                    print("user token = \(String(describing: AccessToken.current?.authenticationToken))")
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsernameTextfield.delegate=self
        PasswordTextfield.delegate=self
        
        //set status bar color
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickNextView), name:NSNotification.Name(rawValue: "pickNextView"), object: nil)
        
        FacebookButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickNextView(){
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if(userDictionary?["city"] != nil){
            //go to FirstTimeLogin Storyboard
            self.goToNextView(storyboardName: "Core", identifier: "SwipingScene")
        }else{
            //go to FirstTimeLogin Storyboard
            self.goToNextView(storyboardName: "FirstTimeLogin", identifier: "SetUpProfile")
            
        }
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

