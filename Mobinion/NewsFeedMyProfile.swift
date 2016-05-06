//
//  NewsFeedMyProfile.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/21/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import SDWebImage
import DZNEmptyDataSet

class NewsFeedMyProfile: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var profImage: UIImageView!
    
    @IBOutlet weak var followNos: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followerNos: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pollView: UIView!
    @IBOutlet weak var pollViewLabel: UILabel!
    
    @IBOutlet weak var partView: UIView!
    @IBOutlet weak var partViewLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var profile = NSMutableDictionary()
    var tabArray = [String]()
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        //        print("in NewsFeedController")
        
//        tableView.tableFooterView = UIView()
        
        StartLoader()
        
        getmyAccount()
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
//                    self.doDBalertView(titles, msgs: messages)
                    print("\(titles): \(messages)")
                }
                else
                {
                    do
                    {
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

                        self.profile = responseObject.objectForKey("data")?.mutableCopy() as! NSMutableDictionary
                       
//                         print(self.profile)
//                        print(self.profile["user"]!["about_user"])
//                        print(self.profile)
                        
                        self.profName.text = (self.profile["user"]!["name"] as! String)
                        self.profImage.sd_setImageWithURL(NSURL(string: self.profile["user"]!["profile_pic"] as! String))
                        self.followNos.text = String(self.profile["user"]!["follow_users"]!!.integerValue)
                        self.followerNos.text = String(self.profile["user"]!["following_users"]!!.integerValue)
                        
                        // for rounded profile pic
                        self.profImage.layer.cornerRadius = self.profImage.frame.size.width / 2
                        self.profImage.clipsToBounds = true
                        
                        // for profile pic border
                        self.profImage.layer.borderWidth = 3.0
                        self.profImage.layer.borderColor = UIColor.cyanColor().CGColor

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
                print(error)
                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tabArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
//        let cell = tableView.dequeueReusableCellWithIdentifier(<#identifier#>, forIndexPath: indexPath) as UITableViewCell
//        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
  
    //MARK:- DZNEmptyDataSetDelegate
//    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
//    {
//        let str = "Welcome"
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let str = "You haven't created any polls till now"
        let attrs = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 17)!]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
//    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "taylor-swift")
//    }
    
//    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString!
//    {
//        let str = "Add Grokkleglob"
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
//    
//    func emptyDataSetDidTapButton(scrollView: UIScrollView!)
//    {
//        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "Hurray", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
//    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        
    }
    
    @IBAction func notifyBtn(sender: AnyObject)
    {
        
    }
    
    @IBAction func optionsBtn(sender: AnyObject)
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
    
    func getmyAccount(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/myAccount"
        
        Alamofire.request(.GET, URL, headers: header, encoding: .JSON)
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
