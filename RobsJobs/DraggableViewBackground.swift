//
//  DraggableViewBackground.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class DraggableViewBackground: UIView, DraggableViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    let swipeCardData = SwipeCardData()
    let employerData = EmployerData()
    
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!
    
    var idArray: [String] = []
    var employerIDArray: [String] = []
    var companyNameArray: [String] = []
    var jobTitleArray: [String] = []
    var interestArray: [String] = []
    var employmentTypeArray: [String] = []
    var distanceArray: [String] = []
    var salaryArray: [String] = []
    var endDateArray: [String] = []
    var companyLogoArray: [String] = []
    var experienceArray: [String] = []
    var descriptionArray: [String] = []
    var companyImageArray: [UIImage] = []
    var jobsScoreArray: [String] = []

    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 300
    let CARD_WIDTH: CGFloat = 290

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    
    var xButtonView: UIView!
    var checkButtonView: UIView!
    
    var cardsSum: Int = 10
    var cardsStartID: Int = 1
    
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
        
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if let locValue:CLLocationCoordinate2D = locationManager.location?.coordinate {
            if let userid = userDictionary?["userID"]{
                swipeCardData.getDataFromServer(dataToGet: "\(String(describing: (userDictionary?["userID"])!))/1/\(cardsSum)/\(locValue.latitude)/\(locValue.longitude)")
            } else{
                print("cant get userid")
            }
        }
    }

    func setupView() -> Void {
//        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)

        //create pass button
        xButtonView = UIView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2 + 35,y: (self.frame.size.height/2) + CARD_HEIGHT/2 + 10,width: 50,height: 50))
        xButtonView.backgroundColor = UIColor.white
        xButtonView.layer.cornerRadius = xButtonView.frame.size.width / 2
        xButtonView.layer.shadowRadius = 3
        xButtonView.layer.shadowOpacity = 0.6
        xButtonView.layer.shadowOffset = CGSize(width: 1,height: 1)
        
        xButton = UIButton(frame: CGRect(x:0 , y: 0,width: 50,height: 50))
        xButton.setImage(UIImage(named: "RJ_pass_icon_col"), for: UIControlState.normal)
        xButton.addTarget(self, action: #selector(self.swipeLeft), for: UIControlEvents.touchUpInside)
        self.addSubview(xButtonView)
        
        //create ok button
        checkButtonView = UIView(frame: CGRect(x: self.frame.size.width/2 + CARD_WIDTH/2 - 85,y: (self.frame.size.height/2) + CARD_HEIGHT/2 + 10,width: 50,height: 50))
        checkButtonView.backgroundColor = UIColor.white
        checkButtonView.layer.cornerRadius = checkButtonView.frame.size.width / 2
        checkButtonView.layer.shadowRadius = 3
        checkButtonView.layer.shadowOpacity = 0.6
        checkButtonView.layer.shadowOffset = CGSize(width: 1,height: 1)
        self.addSubview(checkButtonView)
        
        checkButton = UIButton(frame: CGRect(x:0 , y: 0,width: 50,height: 50))
        checkButton.setImage(UIImage(named: "RJ_apply_icon_col"), for: UIControlState.normal)
        checkButton.addTarget(self, action: #selector(self.swipeRight), for: UIControlEvents.touchUpInside)

        xButtonView.addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: xButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: xButtonView,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant:0.0).isActive = true
        
        NSLayoutConstraint(item: xButton,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: xButtonView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant:0.0).isActive = true
        
        checkButtonView.addSubview(checkButton)
        NSLayoutConstraint(item: checkButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: checkButtonView,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant:0.0).isActive = true
        
        NSLayoutConstraint(item: checkButton,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: checkButtonView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant:0.0).isActive = true
        
    }

    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2,y: (self.frame.size.height - CARD_HEIGHT - 50)/2,width: CARD_WIDTH,height: CARD_HEIGHT))
        
        //set new data
        //set Job Title
        draggableView.jobOfferLabel.text = jobTitleArray[index]
        draggableView.jobOfferLabel.font = UIFont.boldSystemFont(ofSize: 16)
        draggableView.jobOfferLabel.numberOfLines = 1
        
//        draggableView.requiredSkillLabel.text = interestArray[index]
        draggableView.typeLabel.text = employmentTypeArray[index]
        draggableView.typeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        draggableView.appliedNumberLabel.text = "\(distanceArray[index]) Km"
        draggableView.salaryLabel.text = "IDR. \(salaryArray[index])"
        draggableView.experienceLabel.text = experienceArray[index]
        draggableView.offerTimeLabel.text = "end in \(endDateArray[index]) days"
        draggableView.jobDescriptionLabel.text = descriptionArray[index]
        draggableView.companyNameLabel.text = companyNameArray[index]
        
        //download image from url
        for index in 0...companyLogoArray.count-1 {
            if(companyLogoArray[index] != "No Data"){
                if let checkedUrl = URL(string: companyLogoArray[index]) {
                    downloadImage(url: checkedUrl,imageIndex: index)
                }
            }
        }
        
        draggableView.delegate = self
        return draggableView
    }
    
    func downloadImage(url: URL, imageIndex: NSInteger) {
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.allCards[imageIndex].companyLogoView.image = UIImage(data: data)
                self.companyImageArray.append(UIImage(data: data)!)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func loadCards() -> Void {
        if jobTitleArray.count > 0 {
            let numLoadedCardsCap = jobTitleArray.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : jobTitleArray.count
            for i in 0 ..< jobTitleArray.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(index: i)
                allCards.append(newCard)
                print("all cards append = \(allCards.count)")
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            //if loaded cards is 0 put 2 cards in loaded cards, if loaded cards is 1 put 1 loaded cards
            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }

    func loadNewCards(){
        
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        cardsSum = 10
        cardsLoadedIndex = 0
        idArray.removeAll()
        employerIDArray.removeAll()
        jobTitleArray.removeAll()
        interestArray.removeAll()
        employmentTypeArray.removeAll()
        distanceArray.removeAll()
        salaryArray.removeAll()
        endDateArray.removeAll()
        companyLogoArray.removeAll()
        experienceArray.removeAll()
        descriptionArray.removeAll()
        companyImageArray.removeAll()
        jobsScoreArray.removeAll()
        allCards.removeAll()
        loadedCards.removeAll()
        swipeCardData.resetAllData()
        companyNameArray.removeAll()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        var locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        swipeCardData.getDataFromServer(dataToGet: "\(String(describing: (userDictionary?["userID"])!))/1/\(cardsSum)/\(locValue.latitude)/\(locValue.longitude)")
    }

    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.remove(at: 0)

        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        if loadedCards.isEmpty{
            loadNewCards()
        }else{
        cardIsSwiped(requestType: "reject", indexToSend: (10 - cardsSum), jobScoreToSend: "job_score=\(jobsScoreArray[10 - cardsSum])")
        }
        
        cardsSum -= 1
    }
    
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
            print(cardsSum)
        }
        
        if loadedCards.isEmpty{
            loadNewCards()
        }else{
        
            cardIsSwiped(requestType: "apply", indexToSend: (10 - cardsSum), jobScoreToSend: "jobscore=\(jobsScoreArray[10 - cardsSum])")
        }
        
        cardsSum -= 1
    }

    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        print(cardsSum)
        dragView.rightClickAction()
    }

    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        print(cardsSum)
        dragView.leftClickAction()
    }
    
    func loadList(notification: NSNotification){
        //load data here
        jobTitleArray = swipeCardData.jobTitleToSend
        interestArray = swipeCardData.interestToSend
        employmentTypeArray = swipeCardData.employmentTypeToSend
        distanceArray = swipeCardData.distanceToSend
        salaryArray = swipeCardData.salaryToSend
        companyLogoArray = swipeCardData.companyLogoToSend
        experienceArray = swipeCardData.experienceToSend
        endDateArray = swipeCardData.endDateToSend
        descriptionArray = swipeCardData.descriptionToSend
        jobsScoreArray = swipeCardData.jobsScoreToSend
        idArray = swipeCardData.idToSend
        employerIDArray = swipeCardData.employerIDToSend
        companyNameArray = swipeCardData.companyNameToSend
        
        self.loadCards()
    }
    
    func cardIsSwiped(requestType: String, indexToSend: Int, jobScoreToSend: String){
        var request = URLRequest(url: URL(string: "http://apidev.robsjobs.co/api/v1/job/\(requestType)")!)
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        request.httpMethod = "POST"
        
        let postString = "userid=\(String(describing: (userDictionary?["userID"])!))&jobid=\((idArray[indexToSend]))&\(jobScoreToSend)"
        print("post string card is swiped = \(postString)")
        request.httpBody = postString.data(using: .utf8)
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
                    }else{
                        let jsonData = json["data"] as! [String:Any]
                    } // if else
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()
    }
    
    func tapForMorePressed(button:UIButton) -> Void {
        print("button is pressed")
        let viewController = JobSwipingViewController()
        let indexToSend = 10 - cardsSum
        viewController.doTapForMore(jobTitle: jobTitleArray[indexToSend], interest: interestArray[indexToSend], employmentType: employmentTypeArray[indexToSend], distance: distanceArray[indexToSend], salary: salaryArray[indexToSend], endDate: endDateArray[indexToSend], companyLogo: companyImageArray[indexToSend], experience: experienceArray[indexToSend], descriptionJob: descriptionArray[indexToSend], idJob: idArray[indexToSend], employerID: employerIDArray[indexToSend], companyName: companyNameArray[indexToSend])
    }
}
