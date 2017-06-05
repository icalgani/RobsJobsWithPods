//
//  ChatData.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/17/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation

class ChatData{
    var messageToSend: [String] = []
    var userTypeToSend: [String] = []
    var tsToSend: [String] = []
    
    //GET MESSAGE DATA
    func getDataFromServer(dataToGet: String){
        messageToSend.removeAll()
        userTypeToSend.removeAll()
        tsToSend.removeAll()
        
        print("getting data from server")
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/chat/detail/\(dataToGet)")!)
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
                        
                        let jsonData = json["chat"] as! [[String:Any]]
                        print(jsonData)
                        if(jsonData.count != 0){
                            for index in 0...(jsonData.count)-1 {
                                
                                let aObject:[String:Any] = (jsonData[index])

                                self.messageToSend.append(aObject["message"] as! String)
                                self.userTypeToSend.append(aObject["user_type"] as! String)
                                self.tsToSend.append(String(describing: aObject["ts"]!))
                                
                            }// end for

                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadChatData"), object: nil)
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
    
    //SEND MESSAGE DATA
    func postMessageData(jobAppId: String, message: String){
        let userDefaults = UserDefaults.standard
        var userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]

        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/chat")!)
        
        //check login
        request.httpMethod = "POST"
        
//        let postString = "jobappid=\(jobAppId)&userid=\(userDictionary?["userID"] as! Int)&message=\(message)"
        let postString = "jobappid=\(jobAppId)&userid=313&message=\(message)"

        request.httpBody = postString.data(using: .utf8)
        
        print("post string from chat data: \(postString)")
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
                        print("error message: \(errorMessage["message"] as! String)")
                        //set alert if email or password is wrong
                        
                    }
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()
    }
}
