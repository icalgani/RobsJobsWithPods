//
//  UserRegisterData.swift
//  RobsJobs
//
//  Created by MacBook on 6/8/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class UserRegisterData{
    
    let API_URL = "http://api.robsjobs.co/api/v1"
    
    func doRegisterUserToServer(targetViewController: UIViewController, userEmail: String, userPassword: String, userName: String, userMobileNo: String){
        //check login
        var request = URLRequest(url: URL(string: "\(API_URL)/user/signup")!)
        request.httpMethod = "POST"
        let postString = "email=\(userEmail)&password=\(userPassword)&name=\(userName)&mobile_no=\(userMobileNo)"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
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
                        DispatchQueue.main.async {
                            //set alert if email or password is wrong
                            self.showRegisterFailed(targetVC: targetViewController, alertMessage: currentErrorMessage)
                        }
                    }else{
                        DispatchQueue.main.async {
                            //go to FirstTimeLogin Storyboard
                            self.showRegisterSucceed(targetVC: targetViewController)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        }//end request
        task.resume()
    }
    
    func showRegisterFailed(targetVC: UIViewController, alertMessage: String){
        // Create the alert controller
        let alertController = UIAlertController(title: "Register", message: alertMessage, preferredStyle: .alert)
        
        // Create the actions
        // delete action
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        targetVC.present(alertController, animated: true, completion: nil)
    }
    
    func showRegisterSucceed(targetVC: UIViewController){
        // Create the alert controller
        let alertController = UIAlertController(title: "Register", message: "Registration Succeed", preferredStyle: .alert)
        
        // Create the actions
        // delete action
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as! ViewController
            targetVC.present(nextViewController, animated:true, completion:nil)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        targetVC.present(alertController, animated: true, completion: nil)
    }
}
