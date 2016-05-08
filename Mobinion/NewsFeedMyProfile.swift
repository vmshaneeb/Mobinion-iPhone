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
import Spring

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
    
    convenience init(rgba: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#")
        {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                if hex.characters.count == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if hex.characters.count == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                }
                else
                {
                    print("invalid rgb string, length should be 7 or 9", terminator: "")
                }
            }
            else
            {
                print("scan hex error", terminator: "")
            }
        }
        else
        {
            print("invalid rgb string, missing '#' as prefix", terminator: "")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

}

class NewsFeedMyProfile: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIPopoverPresentationControllerDelegate
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
    
    @IBOutlet weak var dropDownView: SpringView!
    
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var doB: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var optionsBtn: UIButton!
    
    var profile = NSMutableDictionary()
    
    var tabArray = NSMutableArray()
    
    let picker = UIImageView(image: UIImage(named: "blank_image"))
    
    struct properties
    {
        static let moods =
            [
                ["title" : "ACCOUNT", "color" : "#151A1D"],
                ["title" : "MY INTERESTS", "color": "#151A1D"],
                ["title" : "INVITE FRIENDS", "color" : "#151A1D"],
                ["title" : "SETTINGS", "color" : "#151A1D"]
        ]
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        createPicker()
        
        //        print("in NewsFeedController")
        
//        tableView.tableFooterView = UIView()
        
        tableView.registerClass(ProfileTableViewCell.self, forCellReuseIdentifier: "partstablecell")
        var nib:UINib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "partstablecell")
        
        tableView.registerClass(polls_TableViewCell.self, forCellReuseIdentifier: "pollstablecell")
        nib = UINib(nibName: "polls_TableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "pollstablecell")
        
        

        
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
                        
                        if (!(self.profile["user"]!["name"]!!.isKindOfClass(NSNull)))
                        {
                            self.profName.text = (self.profile["user"]!["name"] as! String)
                        }
                        
                        if (!(self.profile["user"]!["profile_pic"]!!.isKindOfClass(NSNull)))
                        {
                            self.profImage.sd_setImageWithURL(NSURL(string: self.profile["user"]!["profile_pic"] as! String))
                        }
                        
                        if (!(self.profile["user"]!["follow_users"]!!.isKindOfClass(NSNull)))
                        {
                            self.followNos.text = String(self.profile["user"]!["follow_users"]!!.integerValue)
                        }
                        
                        if (!(self.profile["user"]!["following_users"]!!.isKindOfClass(NSNull)))
                        {
                            self.followerNos.text = String(self.profile["user"]!["following_users"]!!.integerValue)
                        }
                        
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
        stopLoader()
        
        
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
        let result = UITableViewCell()
        
        if(tabArray[indexPath.row].containsObject("pollType"))
        {
//            print("is poll")
            let cell = tableView.dequeueReusableCellWithIdentifier("pollstablecell") as! polls_TableViewCell
            
            if (!(tabArray[indexPath.row]["type"]!!.isEqualToString("")))
            {
                cell.expType.text = (tabArray[indexPath.row]["type"] as! String)
            }
            
            if (!(tabArray[indexPath.row]["content"]!!.isEqualToString("")))
            {
                cell.pollContent.text = (tabArray[indexPath.row]["content"] as! String)
            }
            
            if (!(tabArray[indexPath.row]["pollType"]!!.isEqualToString("")))
            {
                cell.pollType.text = (tabArray[indexPath.row]["pollType"] as! String)
            }
            
            if (!(tabArray[indexPath.row]["createdAt"]!!.isEqualToString("")))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let datesString:NSDate = dateFormatter.dateFromString(tabArray[indexPath.row]["createdAt"] as! String)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
                cell.pollCreated.text = dateFormatter.stringFromDate(datesString)
            }
            
            return cell
        }
        else if(tabArray[indexPath.row].containsObject("authorName"))
        {
//            print("is parts")
            let cell = tableView.dequeueReusableCellWithIdentifier("partstablecell") as! ProfileTableViewCell
            
            // for rounded profile pic
            
            
            if (!(tabArray[indexPath.row]["authorImage"]!!.isEqualToString("")))
            {
                cell.authorImage.layer.cornerRadius = cell.authorImage.frame.size.width / 2
                cell.authorImage.clipsToBounds = true
                
                let url = NSURL(string: tabArray[indexPath.row]["authorImage"] as! String)
                cell.authorImage.sd_setImageWithURL(url!)
            }
            
            if (!(tabArray[indexPath.row]["authorName"]!!.isEqualToString("")))
            {
                cell.authorName.text = (tabArray[indexPath.row]["authorName"] as! String)
            }
            
            if (!(tabArray[indexPath.row]["text"]!!.isEqualToString("")))
            {
                cell.textView.text = (tabArray[indexPath.row]["text"] as! String)
            }
            
            if (!(tabArray[indexPath.row]["createdAt"]!!.isEqualToString("")))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let datesString:NSDate = dateFormatter.dateFromString(tabArray[indexPath.row]["createdAt"] as! String)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
                cell.createdDate.text = dateFormatter.stringFromDate(datesString)
            }
            return cell
        }
        
        return result
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
    
    //MARK:- UIPopoverPresentationControllerDelegates
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    //MARK:- Overrides
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.picker.hidden = true
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func notifyBtn(sender: AnyObject)
    {
        
    }
    
    @IBAction func optionsBtn(sender: UIButton)
    {
//        print("btton pressed")
//        picker.hidden ? openPicker() : closePicker()
        if dropDownView.hidden == true
        {
            sender.setImage(UIImage(named: "accout options"), forState: UIControlState.Normal)
            
            dropDownView.hidden = false
            dropDownView.animation = "fadeIn"
            dropDownView.animate()
        }
        else
        {
            sender.setImage(UIImage(named: "accout options expanded"), forState: UIControlState.Normal)
//
            dropDownView.hidden = true
            dropDownView.animation = "fadeOut"
            dropDownView.animate()
        }
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
    
    //MARK:- DropDown Actions
    @IBAction func drpBtnAccount(sender: AnyObject)
    {
//        print("account")
        dropDownView.hidden = !dropDownView.hidden
        optionsBtn.setImage(UIImage(named: "accout options expanded"), forState: UIControlState.Normal)
        
//        dropDownView.animation = "fadeOut"
        dropDownView.animate()
        
        navBarTitle.text = "ACCOUNT"
        
        accountView.hidden = false
        
        if (!(profile["user"]!["bio"]!!.isKindOfClass(NSNull)))
        {
            jobTitle.text = (profile["user"]!["bio"] as! String)
        }
    
        if (!(profile["user"]!["username"]!!.isKindOfClass(NSNull)))
        {
            userName.text = (profile["user"]!["username"] as! String)
        }
        
        if (!(profile["user"]!["dob"]!!.isKindOfClass(NSNull)))
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let datesString:NSDate = dateFormatter.dateFromString(profile["user"]!["dob"] as! String)!
            dateFormatter.dateFormat = "dd MMM yyyy"
            doB.text = dateFormatter.stringFromDate(datesString)
        }
        
        if (!(profile["user"]!["zipCode"]!!.isKindOfClass(NSNull)))
        {
            zipCode.text = String(profile["user"]!["zipCode"]!!.integerValue)
        }
        
        if (!(profile["user"]!["about_user"]!!.isKindOfClass(NSNull)))
        {
            bioText.text = (profile["user"]!["about_user"] as! String)
        }
    }
    
    @IBAction func drpBtnInterests(sender: AnyObject)
    {
//        print("ACTIVITIES")
        dropDownView.hidden = !dropDownView.hidden
        optionsBtn.setImage(UIImage(named: "accout options expanded"), forState: UIControlState.Normal)
        
        dropDownView.animation = "fadeOut"
        dropDownView.animate()
        
        navBarTitle.text = "MY ACTIVITIES"
        
        accountView.hidden = true
    }
    
    @IBAction func drpBtnInvite(sender: AnyObject)
    {
//        print("invites")
        dropDownView.hidden = !dropDownView.hidden
        optionsBtn.setImage(UIImage(named: "accout options expanded"), forState: UIControlState.Normal)
        
        dropDownView.animation = "fadeOut"
        dropDownView.animate()
        
        navBarTitle.text = "MY ACTIVITIES"
        
        accountView.hidden = true
    }
    
    @IBAction func drpBtnSettings(sender: AnyObject)
    {
//        print("settings")
        dropDownView.hidden = !dropDownView.hidden
        optionsBtn.setImage(UIImage(named: "accout options expanded"), forState: UIControlState.Normal)
        
        dropDownView.animation = "fadeOut"
        dropDownView.animate()
        
        navBarTitle.text = "MY ACTIVITIES"
        
        accountView.hidden = true
        
        performSegueWithIdentifier("showProfileSegue", sender: sender)
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
    
    func createPicker()
    {
        picker.frame = CGRect(x: 212, y: 50, width: 200, height: 200)
        picker.alpha = 0
        picker.hidden = true
        picker.userInteractionEnabled = true
        
        var offset = 21
        
        for (index, feeling) in properties.moods.enumerate()
        {
            let button = UIButton()
            button.frame = CGRect(x: 13, y: offset, width: 170, height: 43)
            button.setTitleColor(UIColor(rgba: feeling["color"]!), forState: .Normal)
            button.setTitle(feeling["title"], forState: .Normal)
            button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
            button.tag = index
            
            button.addTarget(self, action: #selector(NewsFeedMyProfile.DropdownPressed(_:)), forControlEvents: .TouchUpInside)
            
            picker.addSubview(button)
            
            offset += 44
        }
        
        view.addSubview(picker)
    }
    
    
    func openPicker()
    {
        self.picker.hidden = false
        
        UIView.animateWithDuration(0.3, animations:
        {
            self.picker.frame = CGRect(x: 212, y: 50, width: 200, height: 200)
            self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(0.3, animations:
        {
            self.picker.frame = CGRect(x: 212, y: 50, width: 200, height: 200)
            self.picker.alpha = 0
        },
        completion:
        { finished in
            self.picker.hidden = true
        })
    }
    
    func DropdownPressed(sender: UIButton)
    {
//        print(sender.tag)
        switch sender.tag
        {
            case 0: //Account Btn
                break
            case 1: //Interests Btn
                break
            case 2: //Invite Btn
                break
            case 3: //Settings Btn
                break
            default:
                break
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
