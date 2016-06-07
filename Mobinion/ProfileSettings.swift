//
//  ProfileSettings.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/8/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import SVProgressHUD

class ProfileSettings: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func notifyBtnTop(sender: AnyObject)
    {
        performSegueWithIdentifier("showNotificationFromSettings", sender: sender)
    }
    
    
    @IBAction func privacyBtn(sender: AnyObject)
    {
        print("privacy")
    }

    @IBAction func notifyBtn(sender: AnyObject)
    {
//        print("notify")
        performSegueWithIdentifier("showNotificationFromSettings", sender: sender)
    }
    
    @IBAction func chngpassBtn(sender: AnyObject)
    {
        print("change pass")
    }
    
    @IBAction func deleBtn(sender: AnyObject)
    {
//        print("delete")
        doDelete()
    }
    
    @IBAction func restoreBtn(sender: AnyObject)
    {
        print("restore")
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
    
    func deleteAC(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/deleteAccount"
        
        Alamofire.request(.POST, URL, headers: header, encoding: .JSON)
            .responseJSON { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, response.data, nil)
                    }
                    
                case .Failure(let error):
                    completionHandler(nil, nil, error)
                }
        }
    }
    
    func doDelete()
    {
        let alertController = DBAlertController(title: "Warning", message: "Do you want to delete your A/c?\nThis action cannot be undone", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Delete", style: .Destructive, handler:
        { action in
                switch action.style
                {
                case .Destructive:
                    SVProgressHUD.show()
                    self.deleteAC()
                    { value, data, error in
                        if value != nil
                        {
                            let json = JSON(value!)
                            print(json)
                            
                            SVProgressHUD.dismiss()
                            
                            let titles = json["status"].stringValue
                            let messages = json["message"].stringValue
                            
                            self.doDBalertView(titles, msgs: messages)
                            
//                            if titles == "error"
//                            {
//                                self.doDBalertView(titles, msgs: messages)
//                            }
//                            else
//                            {
//                                
//                            }
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                            //                    print(error)
                            self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                        }
                    }

                default:
                    break
                }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        alertController.show()
        
        
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
