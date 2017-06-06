//
//  LoginData.swift
//  RobsJobs
//
//  Created by MacBook on 6/6/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class LoginData{

    let API_URL = "http://apidev.robsjobs.co/api/v1"
    var userDefaults = UserDefaults.standard

    func userLoginRequest(username: String, password: String){
        var request = URLRequest(url: URL(string: "\(API_URL)/user/login")!)
        
        //check login
        request.httpMethod = "POST"
        let postString = "email=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        print("login post string: \(postString)")
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
                        print("error message: \(currentErrorMessage)")
                        
                        //set alert if email or password is wrong
                        let ac = UIAlertController(title: "Alert", message:                            currentErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                        ac.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
                        let rootVC = UIApplication.shared.keyWindow?.rootViewController
                        rootVC?.present(ac, animated: true){}
                        
                    }else{
                        let jsonData = json["data"] as! [String:Any]
                        
                        DispatchQueue.main.async {
                            print("user id = \(String(describing: jsonData["id"]!))")
                            
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
    
    func getUserDataFromServer(userID: String){
        var request = URLRequest(url: URL(string: "\(API_URL)/user/profile/\(userID)")!)
        
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
                            
                            let userDictionary: [String:Any] = ["userID": jsonData["id"],"email": jsonData["email"], "userName": jsonData["name"], "mobile_number": jsonData["mobile_number"]]
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                        }else{
                            
                            //  set data to UserDefault
                            var userDictionary:[String: Any] = ["userID": jsonData["id"], "birthdate": jsonData["birthdate"], "curr_employment_sector": jsonData["curr_employment_sector"], "city": jsonData["city"], "province": jsonData["province"], "edu_level":jsonData["edu_level"], "employment_type": jsonData["employment_type"], "sectors": jsonData["sectors"]]
                            
                            if let image = jsonData["image"]{
                                userDictionary["image"] = String(describing: image)
                            }
                            
                            if let skills = jsonData["skills"]{
                                userDictionary["skills"] = skills
                            }
                            
                            if let bio = jsonData["bio"]{
                                userDictionary["bio"] = bio
                            }
                            
                            if let portofolio = jsonData["portofolio"]{
                                userDictionary["portofolio"] = portofolio
                            }
                            
                            if let email = jsonData["email"]{
                                userDictionary["email"] = email
                            }
                            
                            if let userName = jsonData["name"]{
                                userDictionary["userName"] = userName
                            }
                            
                            if let mobile_number = jsonData["mobile_number"]{
                                userDictionary["mobile_number"] = String(describing: mobile_number)
                            }
                            
                            if let salary = jsonData["salary"] {
                                userDictionary["salary"] = String(describing: salary)
                            }
                            
                            if let salarymin = jsonData["salarymin"] {
                                userDictionary["salarymin"] = String(describing: salarymin)
                            }
                            
                            if let salarymax = jsonData["salarymax"]{
                                userDictionary["salarymax"] = String(describing: salarymax)
                            }
                            
                            if let distance = jsonData["distance"]{
                                userDictionary["distance"] = distance
                            }
                            
                            if let employmentStatus = jsonData["emp_status"]{
                                userDictionary["employmentStatus"] = employmentStatus
                                print("employment status = \(employmentStatus)")
                            }
                            
                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pickNextView"), object: nil)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
