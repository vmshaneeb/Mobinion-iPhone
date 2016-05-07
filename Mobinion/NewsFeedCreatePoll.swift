//
//  NewsFeedCreatePoll.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/21/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController

class NewsFeedCreatePoll: UIViewController
{
    override func viewDidAppear(animated: Bool) 
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        //        print("in NewsFeedController")
        
//        StartLoader()
        
//        sendCreatePoll()
//        { value, error in
//                
//            if value != nil
//            {
//                let json = JSON(value!)
//                print(json)
//                
//                self.HideLoader()
//                
//                let titles = json["status"].stringValue
//                let messages = json["message"].stringValue
//                
//                if titles == "error"
//                {
//                    self.doDBalertView(titles, msgs: messages)
//                }
//                else
//                {
//                    
//                }
//            }
//            else
//            {
//                self.HideLoader()
//                print(error)
//                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
//            }
//        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Custom Functions
    func doalertView (tit: String, msgs: String)
    {
        let titles = tit.capitalizedString
        let messages = msgs.capitalizedString
        let alertController = UIAlertController(title: titles, message: messages, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func doDBalertView (tit: String, msgs: String)
    {
        let titles = tit.capitalizedString
        let messages = msgs.capitalizedString
        let alertController = DBAlertController(title: titles, message: messages, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.show()
    }
    
    func sendCreatePoll(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/createPoll"
        
        let parameter = ["category": "",
                         "questions": "",
                         "description": "",
                         "pollImage": "",
                         "pollType": "",
                         "regionalRes": "",
                         "expDate": "",
                         "Tags": ""]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
        .responseJSON { response in
            switch response.result
            {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, nil)
                    }
                    
                case .Failure(let error):
                    completionHandler(nil, error)
            }
        }
    }
    
    // MARK: - Loader
    func StartLoader()
    {
        let objOfHUD:MBProgressHUD=MBProgressHUD .showHUDAddedTo(self.view, animated: true)
        objOfHUD.labelText="Loading.."
    }
    
    func stopLoader()
    {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func HideLoader()
    {
        self.stopLoader()
    }

}


