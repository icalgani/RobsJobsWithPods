//
//  CompanyCodeData.swift
//  RobsJobs
//
//  Created by MacBook on 7/12/17.
//  Copyright © 2017 MacBook. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class CompanyCodeData{
    let API_URL = API_ROBSJOBS.api.rawValue
    var userDefaults = UserDefaults.standard
    
//========================================== SEND COMPANY CODE =======================================================
    func sendCompanyCode(token: String, userid: String){
        var request = URLRequest(url: URL(string: "\(API_URL)/devjob/applytoken")!)
        print("\(API_URL)/devjob/applytoken")

        request.httpMethod = "POST"
        let postString = "token=\(token)&userid=\(userid)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data,response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
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
                        
                    } // if else
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()
    }
}
