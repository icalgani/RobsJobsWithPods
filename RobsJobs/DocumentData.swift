//
//  DocumentData.swift
//  RobsJobs
//
//  Created by MacBook on 6/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import MobileCoreServices

class DocumentData{
    
    
    let API_URL = API_ROBSJOBS.api.rawValue
    
    var documentIDToSend: [String] = ["","",""]
    var documentTypeToSend: [String] = ["","",""]
    var documentPathToSend: [String] = ["","",""]
    var documentIsPickedToSend: [Bool] = [false, false, false]
    
    let userDefaults = UserDefaults.standard
    
//===================================== SENDING USER PICTURE TO SERVER ===============================================
    func uploadPictureRequest(userImage: UIImage)
    {
        var userDictionary = self.userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        let image_data = UIImageJPEGRepresentation(userImage, 0.5)!
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("\(String(describing: (userDictionary?["userID"])!))".data(using: .utf8)!, withName: "userid")
                multipartFormData.append(image_data, withName: "photo", fileName: "profile.jpeg", mimeType: "image/jpeg")
        },
            to: "\(API_URL)/user/uploadphoto",
            method: .post,
            encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let JSON = self.dataToJSON(data: response.data!) as? [String: Any]{
                            print("JSON: \(JSON)")
                            print("json dictionary data = \(JSON["data"]!)")
                            let json_data = JSON["data"] as! [String: Any]
                            print("json dictionary photo = \(String(describing: json_data["photo"]))")
                            
                            if let image = json_data["photo"]{
                                userDictionary?["image"] = image
                                print("image in dictionary= \(image)")
                                self.userDefaults.set(userDictionary, forKey: "userDictionary")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshUserImage"), object: nil)
                            }
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
//===================================== SENDING USER DOCUMENT TO SERVER ===============================================
    func uploadDocumentRequest(documentURL: URL, documentType: String){
        var userDictionary = self.userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        print("The Url is : \(documentURL)")
        var file_data = Data()
        
        do{
            file_data = try Data(contentsOf: documentURL)
            print("file data = \(file_data)")
        }catch{
            print("file data 2 = \(file_data)")
        }
        
        let file_mime = mimeTypeForPath(path: documentURL.absoluteString)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("\(String(describing: (userDictionary?["userID"])!))".data(using: .utf8)!, withName: "userid")
                multipartFormData.append("\(documentType)".data(using: .utf8)!, withName: "doctype")
                multipartFormData.append(file_data, withName: "docfile", fileName: "doc1", mimeType: file_mime)
        },
            to: "\(API_URL)/user/uploaddoc",
            method: .post,
            encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint("request: \(response.request!)")
                        debugPrint("response: \(response.response!)")
                        debugPrint("result: \(String(describing: response.result.value))")
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func getDocumentDataFromServer(){
        
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        var request = URLRequest(url: URL(string: "\(API_URL)/user/docs/\(String(describing: (userDictionary?["userID"])!))")!)
        
        print("request = \(request)")
        
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
                        print("getting json data")
                        print("json[data] = \(json["data"] as! [[String:Any]])")
                        print("json = \(json)")
                        
                        let jsonData = json["data"] as! [[String:Any]]
                        
                        print(jsonData)
                        if(jsonData.count != 0){
                            for index in 0...(jsonData.count)-1 {
                                                                
                                let aObject:[String:Any] = (jsonData[index])
                                self.documentIDToSend[index] = String(describing: aObject["id"]!)
                                self.documentTypeToSend[index] = String(describing: aObject["doc_type"]!)
                                self.documentPathToSend[index] = aObject["doc_path"] as! String
                                self.documentIsPickedToSend[index] = true
                                
                                
                            }// end for
                            
                            DispatchQueue.main.async {
                                print("loadDocument Dispatchqueue")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDocument"), object: nil)
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
    
    func deleteDocumentFromServer(docIdToDelete: String){
        
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]

        var request = URLRequest(url: URL(string: "\(API_URL)/user/deletedoc")!)
        //check login
        request.httpMethod = "POST"
        let postString = "userid=\(String(describing: (userDictionary?["userID"])!))&docid=\((docIdToDelete))"
        request.httpBody = postString.data(using: .utf8)
        print("post string delete document: \(postString)")
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
                        print("delete status code: \(httpStatus.statusCode)")
                    }else{
                    } // if else
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
}
