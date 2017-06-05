//
//  SwipeCardData.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/20/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class SwipeCardData{
    var idToSend: [String] = []
    var employerIDToSend: [String] = []
    var jobTitleToSend: [String] = []
    var interestToSend: [String] = []
    var employmentTypeToSend: [String] = []
    var distanceToSend: [String] = []
    var salaryToSend: [String] = []
    var endDateToSend: [String] = []
    var companyLogoToSend: [String] = []
    var experienceToSend: [String] = []
    var descriptionToSend: [String] = []
    var jobsScoreToSend: [String] = []
    var companyNameToSend: [String] = []
    
    func resetAllData(){
        idToSend.removeAll()
        employerIDToSend.removeAll()
        jobTitleToSend.removeAll()
        interestToSend.removeAll()
        employerIDToSend.removeAll()
        distanceToSend.removeAll()
        salaryToSend.removeAll()
        endDateToSend.removeAll()
        companyLogoToSend.removeAll()
        experienceToSend.removeAll()
        descriptionToSend.removeAll()
        jobsScoreToSend.removeAll()
        companyNameToSend.removeAll()
    }
    
    func getDataFromServer(dataToGet: String){
        resetAllData()
        var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/match/\(dataToGet)")!)
        //create the session object
        print("data to get = \(dataToGet)")
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
                        print("getting json data")
                        print("json[data] = \(json["data"] as! [[String:Any]])")
                        print("json = \(json)")
                        
                        let jsonData = json["data"] as! [[String:Any]]
                        
                        print(jsonData)
                        if(jsonData.count != 0){
                            for index in 0...(jsonData.count)-1 {
                                
                                let defaultValue = "logocard"
                                
                                let aObject:[String:Any] = (jsonData[index])
                                self.idToSend.append(String(describing: aObject["id"]!))
                                self.employerIDToSend.append(String(describing: aObject["employer_id"]!))
                                self.jobTitleToSend.append(aObject["job_title"] as! String)
                                self.interestToSend.append(aObject["interests"] as! String)
                                self.employmentTypeToSend.append(aObject["employment_type"] as! String)
                                self.distanceToSend.append(String(describing: aObject["distance"]!))
                                self.salaryToSend.append(aObject["salary"] as! String)
    //                            self.endDateToSend.append(aObject["end_date"] as! String)
                                let endDate = aObject["end_date"] as! String
                                self.endDateToSend.append(self.calculateEndDate(endDate: endDate))
                                
                                if let companyLogo = aObject["company_logo"] as? String{
                                    print(companyLogo != nil)
                                    print("aObject dalam if != nil \(companyLogo)")
                                    self.companyLogoToSend.append(companyLogo)
                                }else{
                                    self.companyLogoToSend.append("No Data")
                                }
                                
                                self.descriptionToSend.append(aObject["desc"] as! String)
                                self.jobsScoreToSend.append(String(describing: aObject["score"]!))
                                let experience = String(describing: aObject["has_experience"]!)
                                if(experience == "0"){
                                    self.experienceToSend.append("No")
                                }else {
                                    self.experienceToSend.append("Yes")
                                }
                                
                                self.companyNameToSend.append(aObject["company_name"] as! String)
                                
                            }// end for
                            
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
    
    func calculateEndDate(endDate: String)->String{
        let calendar = NSCalendar.current
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let end = formatter.date(from: endDate)
        
        let components = calendar.dateComponents([.day], from: date as Date, to: end!)
        
        return String(describing: components.day!)
    }
}
