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

class FeedItemVoting: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
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
    
    var itemDetails = NSMutableDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var nib:UINib = UINib(nibName: "FeedItemVotingMarkCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "FeedItemVotingMarkCell")
        
        nib = UINib(nibName: "FeedItemVotingNonMarkCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "FeedItemVotingNonMarkCell")
        
//        print(itemType)
        if itemType == "mark"
        {
//            print(submitBtn.titleLabel?.text)
            submitBtn.titleLabel?.text = "SUBMIT YOUR MARKS"
        }
        
        getVotes()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if itemType == "mark"
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("FeedItemVotingMarkCell", forIndexPath: indexPath) as! FeedItemVotingMarkCell
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("FeedItemVotingNonMarkCell", forIndexPath: indexPath) as! FeedItemVotingNonMarkCell
            
            return cell
        }
    }
    
    //MARK:- UITableViewDelegates
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- UIScrollViewDelegates
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        //tableViewHt.constant = CGFloat(options.count) * 50
        let ht = CGFloat(450) + tableViewHt.constant
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
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
    
    func getVoteDetails(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/itemDetails"
        
        let parameter = ["itemType": "voting",
                         "itemId": itemID,
                         "notificationId": ""]
        
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
    
    func getVotes()
    {
        self.StartLoader()
        
        getVoteDetails()
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
                    do
                    {
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                        
                        self.itemDetails = responseObject.objectForKey("data")?.mutableCopy() as! NSMutableDictionary
                        
                        print (self.itemDetails)
                        
                        
                        
                    }
                    catch
                    {
                        print("error in responseObject")
                    }
                    
                    self.tableView.reloadData()
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
    
    func submitVote()
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

