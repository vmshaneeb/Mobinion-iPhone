//
//  FeedItemVoting.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/31/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import SDWebImage

class FeedItemVoting: UIViewController
{
    @IBOutlet weak var votingImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var profImg: UIImageView!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var expiry: UILabel!
    @IBOutlet weak var voteQuestn: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var votingImageHt: NSLayoutConstraint!
    @IBOutlet weak var tableViewHt: NSLayoutConstraint!
    
    var itemID = ""
    var feedID = ""
    var itemType = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print(itemType)
        if itemType == "mark"
        {
//            print(submitBtn.titleLabel?.text)
            submitBtn.titleLabel?.text = "SUBMIT YOUR MARKS"
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        //        self.tabBarController?.selectedIndex = 2
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitBtnAction(sender: AnyObject)
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
    
    func submitVoteAPI(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/submitVote"
        
        var parameter = [String: AnyObject]()
        
        if itemType == "mark"
        {
            parameter = ["voteId": itemID,
                         "answers": ""]
        }
        else
        {
            parameter = ["voteId": itemID,
                         "answers": ""]
        }
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
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
    
    func addCommentDetails()
    {
        self.StartLoader()
        
        submitVoteAPI()
        { value, data, error in
            if value != nil
            {
                let json = JSON(value!)
                print(json)
                
                self.HideLoader()
                
                let titles = json["status"].stringValue
                let messages = json["message"].stringValue
                
                if titles == "error"
                {
                    self.doDBalertView(titles, msgs: messages)
                    print(messages)
                }
                else
                {
                    //                    do
                    //                    {
                    //
                    //                    }
                    //                    catch
                    //                    {
                    //                        print("error in responseObject")
                    //                    }
                }
            }
            else
            {
                self.HideLoader()
                //                    print(error)
                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
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

