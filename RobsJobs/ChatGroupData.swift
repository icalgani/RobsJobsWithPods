//
//  ChatGroupData.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/17/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation

class ChatGroupData{
    
    var companyImageToPass: [String] = []
    var companyNameToPass: [String] = []
    var companyUserNameToPass: [String] = []
    var chatGroupIDToPass: [String] = []
    
    func getDataFromServer(dataToGet: String){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/chat/group/\(dataToGet)")!)
        //create the session object
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else {                                                 // check for fundamental networking error
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
                        print(errorMessage)
                        let currentErrorMessage = errorMessage["message"] as! String
                        print(currentErrorMessage)
                    }else{
                        
                        let jsonData = json["data"] as! [[String:Any]]
                        print(jsonData)
                        if(jsonData.count != 0){
                            for index in 0...(jsonData.count)-1 {
                                
                                let aObject:[String:Any] = (jsonData[index])
                                
                                if let companyLogo = aObject["company_logo"] as? String{
                                    self.companyImageToPass.append(companyLogo)
                                }else{
                                    self.companyImageToPass.append("RJ_login_logo")
                                }

                                self.companyNameToPass.append(aObject["company_name"] as! String)
                                self.companyUserNameToPass.append(aObject["username"] as! String)
                                self.chatGroupIDToPass.append(String(describing: aObject["job_application_id"]!))
                                
                                
                            }// end for
                            
                            
                            DispatchQueue.main.async {
                                print("post notification")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadChatGroupData"), object: nil)
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
    
}
