//
//  GotMatchedViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/12/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class GotMatchedViewController: UIViewController {

    @IBOutlet weak var UserProfilePicture: UIImageView!
    @IBOutlet weak var CompanyProfilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        // rounding user profile image
        self.UserProfilePicture.layer.cornerRadius = self.UserProfilePicture.frame.size.width / 2
        self.UserProfilePicture.clipsToBounds = true
        //rounding  user age
        self.CompanyProfilePicture.layer.cornerRadius = self.CompanyProfilePicture.frame.size.width / 2
        self.CompanyProfilePicture.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
