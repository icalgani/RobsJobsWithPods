//
//  Page4ViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/11/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class Page4ViewController: UIViewController {

    @IBAction func ExitFromTutorial(_ sender: UIButton) {
    
    }
    
    @IBAction func FinishTutorial(_ sender: ButtonCustom) {
        //go to tutorial page
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    @IBOutlet weak var FinishButton: ButtonCustom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set white border
        FinishButton.whiteBorder()
        
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
