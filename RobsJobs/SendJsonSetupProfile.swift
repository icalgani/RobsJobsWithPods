//
//  File.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/15/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class SendJsonSetupProfile{
    
    func sendDataToAPI(userDictionary: Dictionary<String, Any>){
        
        //check login
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/profile")!)
        request.httpMethod = "POST"
        
        var postString = ""
//        var postString = "userid=\(userDictionary["userID"] as? String)&name=\(userDictionary["userName"]! as? String)&birthdate=\(userDictionary["birthdate"]! as? String)&city=\(userDictionary["city"]! as? String)&province=\(userDictionary["province"] as? String)"
        
//        print("nilai userID sebelum masuk postString == \(userDictionary["userID"] as! String)")
//        if let userid = userDictionary["userID"] as? String{
//            print("userid == \(userid)")
//            postString += "userid=\(userid)"
//        } else{
//            print("userid == nil")
//            postString += "userid=542"
//        }
        
        postString += "userid=\(userDictionary["userID"]!)"

        if let username = userDictionary["userName"] as? String{
            postString += "&name=\(username)"
        } else{
            postString += "&name="
        }
        
        if let birthdate = userDictionary["birthdate"] as? String{
            postString += "&birthdate=\(birthdate)"
        } else{
            postString += "&birthdate="
        }
        
        if let city = userDictionary["city"] as? String{
            postString += "&city=\(city)"
        } else{
            postString += "&city="
        }
        
        if let province = userDictionary["province"] as? String{
            postString += "&province=\(province)"
        } else{
            postString += "&province="
        }
        
        if let salarymin = userDictionary["salarymin"] as? String{
            postString += "&salarymin=\(salarymin)"
        } else{
            postString += "&salarymin="
        }
        
        if let salarymax = userDictionary["salarymax"] as? String{
            postString += "&salarymax=\(salarymax)"
        } else{
            postString += "&salarymax="
        }
        
        if let edulevel = userDictionary["edu_level"] as? String{
            postString += "&edulevel=\(edulevel)"
        } else{
            postString += "&edulevel="
        }
        
        postString += "&interest=" //deprecated
        
        if let emptype = userDictionary["employment_type"] as? String{
            postString += "&emptype=\(emptype)"
        } else{
            postString += "&emptype="
        }
        
        if let empsector = userDictionary["sectors"] as? String{
            postString += "&empsector=\(empsector)"
        } else{
            postString += "&empsector="
        }
        
        if let distance = userDictionary["distance"] as? String{
            postString += "&distance=\(distance)"
        } else{
            postString += "&distance="
        }
        
        if let bio = userDictionary["bio"] as? String{
            postString += "&bio=\(bio)"
        } else{
            postString += "&bio="
        }
        postString += "&skill=" //deprecated
        postString += "&isemployed=" //deprecated
        postString += "&currentsector=" //deprecated
        postString += "&hasexperience=" //deprecated
                  
        if let portofolio = userDictionary["portofolio"] as? String{
            postString += "&portofolio=\(portofolio)"
        } else{
            postString += "&portofolio="
        }
        
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
                        print("status code= \(httpStatus.statusCode)")
                        let errorMessage = json["error"] as! [String:Any]
                        let currentErrorMessage = errorMessage["message"] as! String
                        
                    }else{
                     print("setup profile success")
                        print("hasil json setting profile = \(json)")
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            } // end do
        }//end request
        task.resume()
    }
}
