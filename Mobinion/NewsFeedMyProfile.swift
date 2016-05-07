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

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(Hex:Int)
    {
        self.init(red:(Hex >> 16) & 0xff, green:(Hex >> 8) & 0xff, blue:Hex & 0xff)
    }
}

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
    
    var tabArray = NSMutableArray()
    
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
                }
            }
            else
            {
                self.HideLoader()
                print(error)
                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
            }
        }
        
        
        fetchpolls()
        
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
    
    @IBAction func selectPolls(sender: UITapGestureRecognizer)
    {
//        print("Polls selected!!!")
        partViewLabel.textColor = UIColor.blackColor()
        partViewLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        partView.backgroundColor = UIColor(Hex: 0xDFF8FF)
        
        pollView.backgroundColor = UIColor.whiteColor()
        pollViewLabel.textColor = UIColor(Hex: 0x0FC2C4)
        pollViewLabel.font = UIFont(name: "Roboto-Medium", size: 17)
        
        tabArray.removeAllObjects()
        fetchpolls()
    }
    
    @IBAction func selectPart(sender: UITapGestureRecognizer)
    {
//        print("Particiations selected!!!")
        pollViewLabel.textColor = UIColor.blackColor()
        pollViewLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        pollView.backgroundColor = UIColor(Hex: 0xDFF8FF)
        
        partView.backgroundColor = UIColor.whiteColor()
        partViewLabel.textColor = UIColor(Hex: 0x0FC2C4)
        partViewLabel.font = UIFont(name: "Roboto-Medium", size: 17)
        
        tabArray.removeAllObjects()
        fetchparts()
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
    
    func getmyPolls(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/myPolls"
        
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

    
    func getmyParts(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/myParticipations"
        
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
    
    func fetchpolls()
    {
        StartLoader()
        getmyPolls()
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
//                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
//                        
//                        self.tabArray = responseObject.objectForKey("data")?.mutableCopy() as! NSMutableArray
                        
                        
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        
                        self.tabArray = responseObject["data"]!["polls"]!!.mutableCopy() as! NSMutableArray
                        print(self.tabArray)
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

    func fetchparts()
    {
        StartLoader()
        getmyParts()
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
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        
                        self.tabArray = responseObject["data"]!["participations"]!!.mutableCopy() as! NSMutableArray
                        print(self.tabArray)
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
