//
//  LoginData.swift
//  RobsJobs
//
//  Created by MacBook on 6/6/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginData{

    
    let API_URL = API_ROBSJOBS.api.rawValue
    var userDefaults = UserDefaults.standard

//========================================== SEND LOGIN REQUEST =======================================================
    func userLoginRequest(username: String, password: String){
        var request = URLRequest(url: URL(string: "\(API_URL)/user/login")!)
        print(API_ROBSJOBS.api)
        print(API_ROBSJOBS.api.rawValue)
        //check login
        request.httpMethod = "POST"
        let postString = "email=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        print("login post string: \(postString)")
        print("request url: \(request)")
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
//=============================== GETTING USER DATA FROM SERVER =======================================================
    func getUserDataFromServer(userID: String){
        var request = URLRequest(url: URL(string: "\(API_URL)/user/profile/\(userID)")!)
        print("get user data from server")
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
//                        if jsonData["city"] == nil{
//                            
//                            let userDictionary: [String:Any] = ["userID": jsonData["id"],"email": jsonData["email"], "userName": jsonData["name"], "mobile_number": jsonData["mobile_number"]]
//                            self.userDefaults.set(userDictionary, forKey: "userDictionary")
//                        }else{
//                            
                            //  set data to UserDefault
                        var userDictionary:[String: Any] = [:]
                        
                        if let curr_employment_sector = jsonData["curr_employment_sector"]{
                            userDictionary["curr_employment_sector"] = String(describing: curr_employment_sector)
                        }
                        
                        if let city = jsonData["city"]{
                            userDictionary["city"] = String(describing: city)
                        }
                        
                        if let province = jsonData["province"]{
                            userDictionary["province"] = String(describing: province)
                        }
                        
                        if let edu_level = jsonData["edu_level"]{
                            userDictionary["edu_level"] = String(describing: edu_level)
                        }
                        
                        if let employment_type = jsonData["employment_type"]{
                            userDictionary["employment_type"] = String(describing: employment_type)
                        }
                        
                        if let sectors = jsonData["sectors"]{
                            userDictionary["sectors"] = String(describing: sectors)
                        }
                        if let birthdate = jsonData["birthdate"]{
                            userDictionary["birthdate"] = String(describing: birthdate)
                        }
                        
                        if let id = jsonData["id"]{
                            userDictionary["userID"] = String(describing: id)
                        }
                        
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
                        
                        if let salarymin = jsonData["salary_min"] {
                            userDictionary["salary_min"] = String(describing: salarymin)
                        }
                        
                        if let salarymax = jsonData["salary_max"]{
                            userDictionary["salary_max"] = String(describing: salarymax)
                        }
                        
                        if let distance = jsonData["distance"]{
                            userDictionary["distance"] = distance
                        }
                        
                        if let employmentStatus = jsonData["emp_status"]{
                            userDictionary["employmentStatus"] = employmentStatus
                            print("employment status = \(employmentStatus)")
                        }
                        
                        if let kompetensi = jsonData["kompetensi"]{
                            userDictionary["kompetensi"] = kompetensi
                            print("kompetensi = \(kompetensi)")
                        }
                        
                        if let jurusan = jsonData["jurusan"]{
                            userDictionary["jurusan"] = jurusan
                            print("jurusan = \(jurusan)")
                        }
                        
                        if let experience = jsonData[JsonData.experience.rawValue]{
                            userDictionary[JsonData.experience.rawValue] = experience
                            print("experience = \(experience)")
                        }
                        
                        self.userDefaults.set(userDictionary, forKey: "userDictionary")
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
    
//===================================== LOGIN WITH FACEBOOK =======================================================
    func userLoginWithFacebookRequest(userName: String, userEmail: String, userFbId: String, userFbToken: String){
        var request = URLRequest(url: URL(string: "\(API_URL)/user/loginfb")!)
        
        //check login
        request.httpMethod = "POST"
        let postString = "name=\(userName)&email=\(userEmail)&fb_id=\(userFbId)&token=\(userFbToken)"
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
                    }else{
                        let jsonData = json["data"] as! [String:Any]
                        
                        DispatchQueue.main.async {
                            print("facebook login dispatch queue")
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
    
    //===================================== TEST FACEBOOK LOGIN WITH ALAMOFIRE ========================================

    func facebookLoginWithAlamofire(userName: String, userEmail: String, userFbId: String, userFbToken: String){
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: AnyObject] = [
            "client_id" : "1" as AnyObject,
            "access_token" : userFbToken as AnyObject
        ]
    }
}
