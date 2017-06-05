//
//  JobData.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class EmployerData{
    var jobID: String!
    var jobEmployer: String!
    
    var companyNameToSend: [String] = []
    
    func getDataFromServer(dataToGet: String){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/job/\(dataToGet)")!)
        //create the session object
        
        request.httpMethod = "GET"
        
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
                        print(errorMessage)
                        let currentErrorMessage = errorMessage["message"] as! String
                        print(currentErrorMessage)
                    }else{
                        
                        let jsonData = json["data"] as! [String:Any]
                        print(jsonData)
                        
                        self.jobEmployer = jsonData["company_name"] as! String
                        print(self.jobEmployer)
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setEmployerName"), object: nil)
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
