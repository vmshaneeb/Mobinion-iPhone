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
import IQDropDownTextField

class NewsFeedCreatePoll: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var choose_cat: IQDropDownTextField!
    @IBOutlet weak var quest_textView: UITextView!
    @IBOutlet weak var desc_Field: UITextField!
    @IBOutlet weak var optionsType: IQDropDownTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var speical_textView: UITextView!
    @IBOutlet weak var expiryDate: IQDropDownTextField!
    @IBOutlet weak var tagstextView: UITextView!

    
    
    override func viewDidAppear(animated: Bool) 
    {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1400)
        
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
    
    //MARK:- Actions
    @IBAction func checkBox(sender: AnyObject)
    {
        
    }
    
    @IBAction func createPoll(sender: AnyObject)
    {
        
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


