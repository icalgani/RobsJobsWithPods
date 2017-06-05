//
//  JsonRequest.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/19/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation

class JsonRequest{
    var salaryToSend: [String] = []
    var salaryMinToSend: [String] = []
    var salaryMaxToSend: [String] = []
    var provinceToSend: [String] = []
    var cityToSend: [String] = []
    var characterToSend: [String] = []
    var educationToSend: [String] = []
    var desiredEmploymentToSend: [String] = []
    var employmentSectorToSend: [String] = []
    var skillToSend: [String] = []

    func getDataFromServer(dataToGet: String){
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/init/\(dataToGet)")!)
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
                        let jsonData = json["data"] as! [[String:Any]]
                        for index in 0...jsonData.count-1 {
                            
                            let aObject = jsonData[index]
                            if (dataToGet.range(of: "city") != nil){ //if dataToGet include city
                                self.cityToSend.append(aObject["city"] as! String)
                            }else{
                                switch dataToGet{
                                    case "salary":
                                        self.salaryToSend.append(aObject["label"] as! String)
                                        self.salaryMaxToSend.append(String(describing: aObject["salary_max"]))
                                        self.salaryMinToSend.append(String(describing: aObject["salary_min"]))
                                        break
                            
                                    case "province":
                                        self.provinceToSend.append(aObject["province_name"] as! String)
                                        break
                                    
                                    case "interest":
                                        self.characterToSend.append(aObject["interest"] as! String)
                                        break
                                    case "education":
                                        self.educationToSend.append(aObject["education"] as! String)
                                        break
                                    
                                    case "employmenttype":
                                        self.desiredEmploymentToSend.append(aObject["employment_type"] as! String)
                                        break
                                    
                                    case "employmentsector":
                                        self.employmentSectorToSend.append(aObject["sector"] as! String) //sector id is NOT sorted
                                        break
                                    
                                    case "skill":
                                        self.skillToSend.append(aObject["skill"] as! String) //skill id is NOT sorted
                                        break
                                    
                                    default:
                                        print("switch default")
                                        break
                                
                                } //end switch
                            } //end if else
                        }// end for
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    
    

    
    func getProvinceFromServer() -> Array<String>{
        var arrayToPass: [String]=["province"]
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/init/province")!)
        //create the session object
        
        request.httpMethod = "GET"
//        let postString = "province"
//        request.httpBody = postString.data(using: .utf8)
        
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
                        let jsonData = json["data"] as! [[String:Any]]
                        var arrayTemp: [String] = []
                        
                        for index in 0...jsonData.count-1 {
                            
                            let aObject = jsonData[index] 
                            
                            arrayTemp.append(aObject["province_name"] as! String)
                        }
                        arrayToPass = arrayTemp
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        print("test after resume:\(arrayToPass.joined(separator: ", "))")

        return arrayToPass
    }
}
