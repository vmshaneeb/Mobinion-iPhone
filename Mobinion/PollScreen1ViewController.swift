//
//  PollScreen1ViewController.swift
//  Mobinion
//
//  Created by Hamdan Salim on 5/30/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import DBAlertController

class PollScreen1ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    var ItemId = ""
    var itemType = ""
    
    var PollAnswers: NSMutableArray!
    var Count: Int!
    var ImagePolCount :Int!
    
    let reuseIdentifier = "Cell"
    
    let isiPhone5orLower = UIScreen.mainScreen().bounds.size.width == 320
    let isiPhone6 = UIScreen.mainScreen().bounds.size.width == 375
    let isiPhone6plus = UIScreen.mainScreen().bounds.size.width == 414
    
    @IBOutlet weak var PolImg:UIImageView!
    @IBOutlet weak var UserName:UILabel!
    @IBOutlet weak var UserName1123:UILabel!
    @IBOutlet weak var UserImg:UIImageView!
    @IBOutlet weak var NumOfPolls:UILabel!
    @IBOutlet weak var Date:UILabel!
    @IBOutlet weak var TimePeriod1:UILabel!
    @IBOutlet weak var Topic:UILabel!
    @IBOutlet weak var PollANswersTbl:UITableView!
    @IBOutlet weak var PollANswersCollCtionView:UICollectionView!
    @IBOutlet weak var AreUSureView:UIView!
    @IBOutlet weak var SelectdTextView:UITextView!
    @IBOutlet weak var InfoView:UIView!
    @IBOutlet weak var TopicName:UILabel!
    @IBOutlet weak var ImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TopicDescp:UITextView!
    @IBOutlet weak var FollowReportView:UIView!
    @IBOutlet weak var bandImg:UIImageView!
    @IBOutlet weak var PopImage: UIImageView!
    @IBOutlet weak var ImagePolPopView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    var Dict = NSMutableDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let nib=UINib(nibName:"ItemDetail", bundle:nil)
        PollANswersTbl.registerNib(nib, forCellReuseIdentifier: "ItemDetail")
        PollAnswers = NSMutableArray()
        doPollDetails()
        Count=0
        
        PollANswersCollCtionView.registerClass(InterestsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        let nib1:UINib = UINib(nibName: "InterestsCollectionViewCell", bundle: nil)
        PollANswersCollCtionView.registerNib(nib1, forCellWithReuseIdentifier: "Cell")
//        self.FollowReportView.hidden=true
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func HidePopView(sender: UITapGestureRecognizer)
    {
        self.ImagePolPopView.hidden = true
    }
    
    @IBAction func TounchsAreUSureView()
    {
        self.AreUSureView.hidden = true
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
    
    @IBAction func InfoBtn()
    {
        self.InfoView.hidden=false
        TopicName.text = self.Dict["itemText"]! as? String
        TopicDescp.text = self.Dict["itemDescription"]! as! String
    }
    
    @IBAction func VoteImagepol(sender: AnyObject)
    {
        
    }
    
    @IBAction func PrevBtn(sender: AnyObject)
    {
        if (ImagePolCount != 0)
        {
            ImagePolCount = ImagePolCount-1
            let url = NSURL(string: (self.PollAnswers[ImagePolCount]["content"]! as? String)!)
            self.PopImage.sd_setImageWithURL(url)
        }
    }
    
    @IBAction func NextBtn(sender: AnyObject)
    {
        if (ImagePolCount != self.PollAnswers.count-1)
        {
            ImagePolCount = ImagePolCount+1
            let url = NSURL(string: (self.PollAnswers[ImagePolCount]["content"]! as? String)!)
            self.PopImage.sd_setImageWithURL(url)
        }
    }
    
    @IBAction func shareBtn(sender: AnyObject)
    {
        shareitem()
    }
    
    @IBAction func FollowBtn()
    {
        if (self.FollowReportView.hidden)
        {
            self.FollowReportView.hidden = false
        }
        else
        {
            self.FollowReportView.hidden = true
        }
    }
    
    @IBAction func ReportPoll()
    {
        ReportAPi()
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
                    }
                    else
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                            
                            if  (responseObject["status"]!.isEqualToString("success"))
                            {
                                let alertController = UIAlertController(title: "Success", message: "You are following \(self.Dict["userName"]! as! NSString).", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                    alertController .removeFromParentViewController()
                                }
                                alertController.addAction(okAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
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
                    //                    print(error)
                    self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                }
        }
    }
    
    func ReportAPi(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        
        //SHARED USER ID IS NOT AVAILABLE GIVES <null> value
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        let header = ["Authorization": toks as! String]
        let URL = "http://vyooha.cloudapp.net:1337/reportAbuse"//?rowNumber=1&showingType=all"
        
        let parameter = ["followFriend": Dict["userId"] as! String, "isFollowing": "true"]//"all"]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .URL)
            .responseJSON
            { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, response.data, nil)
                    }
                case .Failure(let error):
                    completionHandler(nil,nil, error)
                }
        }
    }
    
    @IBAction func FollowUSer()
    {
        FollowUserAPi()
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
                    }
                    else
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                            
//                            let Dict:NSMutableDictionary = responseObject["status"]!["item"]!!.mutableCopy() as! NSMutableDictionary
                            if  (responseObject["status"]!.isEqualToString("success"))
                            {
                                let alertController = UIAlertController(title: "Success", message: "You are following \(self.Dict["userName"]! as! NSString).", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                    alertController .removeFromParentViewController()
                                }
                                alertController.addAction(okAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                            
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
                    //                    print(error)
                    self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                }
        }
    }
    
    func FollowUserAPi(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        
        //SHARED USER ID IS NOT AVAILABLE GIVES <null> value
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        let header = ["Authorization": toks as! String]
        let URL = "http://vyooha.cloudapp.net:1337/followFriends"//?rowNumber=1&showingType=all"
        
        let parameter = ["followFriend": Dict["userId"] as! String, "isFollowing": "true"]//"all"]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .URL)
            .responseJSON
            { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, response.data, nil)
                    }
                case .Failure(let error):
                    completionHandler(nil,nil, error)
                }
        }
    }
    
    func shareItemAPI(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        let header = ["Authorization": toks as! String]
        
        let URL = "http://vyooha.cloudapp.net:1337/shareItem"
        
        print("ItemID:- \(ItemId)")
        print("ItemID:- \(itemType)")
        
        let parameter = ["itemId": ItemId,
                         "itemType": itemType]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
        .responseJSON
            { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, response.data, nil)
                    }
                case .Failure(let error):
                    completionHandler(nil,nil, error)
                }
            }
    }
    
    func shareitem()
    {
        StartLoader()
        shareItemAPI()
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
                }
                else
                {
                    self.doDBalertView("Success", msgs: "You successfully shared this item")
//                    do
//                    {
//                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
//                        
//                        //                            let Dict:NSMutableDictionary = responseObject["status"]!["item"]!!.mutableCopy() as! NSMutableDictionary
//                        if  (responseObject["status"]!.isEqualToString("success"))
//                        {
//                            let alertController = UIAlertController(title: "Success", message: "You are following \(self.Dict["userName"]! as! NSString).", preferredStyle: .Alert)
//                            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                                alertController .removeFromParentViewController()
//                            }
//                            alertController.addAction(okAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                        }
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
    
    
    
    @IBAction func CloseInfo()
    {
        self.InfoView.hidden=true
    }
    
    @IBAction func BackBtn()
    {
        self.navigationController!.popViewControllerAnimated(true)
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
    
    func GetPollDetails(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        let header = ["Authorization": toks as! String]
        let URL = "http://vyooha.cloudapp.net:1337/itemDetails"//?rowNumber=1&showingType=all"
        
        let parameter = ["itemType": String("poll"), "itemId": ItemId]//"all"]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .URL)
            .responseJSON
            { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, response.data, nil)
                    }
                case .Failure(let error):
                    completionHandler(nil,nil, error)
                }
        }
    }
    
    func doPollDetails()
    {
        self.StartLoader()
        
        GetPollDetails()
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
                    }
                    else
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                            self.Dict = responseObject["data"]!["item"]!!.mutableCopy() as! NSMutableDictionary
                            
                            print(self.Dict)
                            let str: String? = self.Dict.valueForKey("itemImage")! as? String
                            let url:NSURL? = NSURL(string: "\(str)")
                            self.PolImg.sd_setImageWithURL(url)
                            
                            let str1: String? = self.Dict.valueForKey("userImage")! as? String
                            let url1:NSURL? = NSURL(string: "\(str1)")
                            self.UserImg.sd_setImageWithURL(url1)
                            
                            self.UserName.text = self.Dict["userName"] as? String
                            self.UserName1123.text = self.Dict["userName"] as? String
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            dateFormatter.timeZone = NSTimeZone(name: "UTC")
                            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                            let datesString:NSDate = dateFormatter.dateFromString(responseObject["data"]!["item"]!!["item_createdDate"] as! String)!
                            
                            self.NumOfPolls.text = ("\(responseObject["data"]!["item"]!!["participants"]! as! NSInteger)")
                            
                            self.TimePeriod1.text = self.timeAgoSince(datesString)
                            
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let datesString1:NSDate = dateFormatter.dateFromString(responseObject["data"]!["item"]!!["item_expiryDate"] as! String)!
                            dateFormatter.dateFormat = "dd MMM yyyy"
                            self.Date.text = dateFormatter.stringFromDate(datesString1)
                            self.Topic.text = " \(self.Dict["questionDetails"]![self.Count]["question"] as! String)"
                            
                            self.PollAnswers = self.Dict["questionDetails"]![self.Count]["options"]!!.mutableCopy() as! NSMutableArray
                            
                            if  ((self.Dict.valueForKey("itemImage")! as? String) == nil)
                            {
                                self.ImageViewHeight.constant = 49.0
                                print(self.Dict["itemType"]!)
                                self.bandImg.layer.cornerRadius=10.0
                                self.bandImg.backgroundColor=UIColor (colorLiteralRed: 63.0/255.0, green: 175/255.0, blue: 89.0/255.0, alpha: 1.0)
                                self.bandImg.alpha=1.0
                                
                                self.infoButton.hidden = true
                            }
                            
                            if  ((self.Dict["itemType"]!.isEqualToString("img_poll")))
                            {
                                self.PollANswersCollCtionView.reloadData()
                                self.PollANswersTbl.hidden = true
//                                self.infoButton.hidden = true
                            }
                            else
                            {
                                self.PollANswersTbl .reloadData()
                                self.PollANswersCollCtionView.hidden = true
                            }
                            
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
                    //                    print(error)
//                    self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                }
        }
    }

    func timeAgoSince(date: NSDate) -> String
    {
        
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfYear, .Month, .Year]
        let components = calendar.components(unitFlags, fromDate: date, toDate: now, options: [])
        var rcomp:Int
        
        //        print(components)
        
        if components.year >= 2
        {
            return "\(components.year) years ago"
        }
        
        if components.year >= 1
        {
            return "Last year"
        }
        
        if components.year <= -2
        {
            rcomp = abs(components.year)
            return "\(rcomp) years"
        }
        
        if components.year <= -1
        {
            return "Next year"
        }
        
        if components.month >= 2
        {
            return "\(components.month) months ago"
        }
        
        if components.month >= 1
        {
            return "Last month"
        }
        
        if components.month <= -2
        {
            rcomp = abs(components.month)
            return "\(rcomp) months"
        }
        
        if components.month <= -1
        {
            return "Next month"
        }
        
        if components.weekOfYear >= 2
        {
            return "\(components.weekOfYear) weeks ago"
        }
        
        if components.weekOfYear >= 1
        {
            return "Last week"
        }
        
        if components.weekOfYear <= -2
        {
            rcomp = abs(components.weekOfYear)
            return "\(rcomp) weeks"
        }
        
        if components.weekOfYear <= -1
        {
            return "Next week"
        }
        
        if components.day >= 2
        {
            return "\(components.day) days ago"
        }
        
        if components.day >= 1
        {
            return "Yesterday"
        }
        
        if components.day <= -2
        {
            rcomp = abs(components.day)
            return "\(rcomp) days"
        }
        
        if components.day <= -1
        {
            return "Tomorrow"
        }
        
        if components.hour >= 2
        {
            return "\(components.hour) hours ago"
        }
        
        if components.hour >= 1
        {
            return "An hour ago"
        }
        
        if components.hour <= -2
        {
            rcomp = abs(components.hour)
            return "\(rcomp) hours"
        }
        
        if components.hour <= -1
        {
            return "In an hour"
        }
        
        if components.minute >= 2
        {
            return "\(components.minute) minutes ago"
        }
        
        if components.minute >= 1
        {
            return "A minute ago"
        }
        
        if components.minute <= -2
        {
            rcomp = abs(components.minute)
            return "\(rcomp) minutes"
        }
        
        if components.minute <= -1
        {
            return "In a minute"
        }
        
        if components.second >= 3
        {
            return "\(components.second) seconds ago"
        }
        
        if components.second <= -3
        {
            rcomp = abs(components.second)
            return "\(rcomp) seconds"
        }
        
        return "Just now"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func YesBtn ()
    {
        print(Dict["questionDetails"]!.count)
        if (self.Dict["questionDetails"]?.count > self.Count+1)
        {
            self.Count = self.Count+1
            self.Topic.text = " \(self.Dict["questionDetails"]![self.Count]["question"] as! String)"
            
            self.PollAnswers = self.Dict["questionDetails"]![self.Count]["options"]!!.mutableCopy() as! NSMutableArray
            self.PollANswersTbl .reloadData()
        }
        AreUSureView.hidden = true
    }
    
    
    //MARK:- UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.PollAnswers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:ItemDetail = self.PollANswersTbl.dequeueReusableCellWithIdentifier("ItemDetail" , forIndexPath: indexPath)as! ItemDetail
//        cell.PrdctDescp.text = "Option\(indexPath.row+1):\(self.PollAnswers[indexPath.row]["content"]! as! String)"
        cell.PrdctDescp.text = "\(indexPath.row+1): \(self.PollAnswers[indexPath.row]["content"]! as! String)"
        cell.ChckBtn.tag = indexPath.row
        cell.ChckBtn .addTarget(self, action: #selector(VoteBtn(_:)), forControlEvents:.TouchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    //MARK:- UITableViewDelegates
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44.0
    }
    
    func VoteBtn (sender: UIButton)
    {
        sender.setImage(UIImage(named: "vote-selected-button-w-txt.png"), forState: UIControlState.Normal)
        AreUSureView.hidden = false
        SelectdTextView.text = "Option \(sender.tag+1): \(self.PollAnswers [sender.tag]["content"]! as! String)"
    }
    
    //MARK:- UICollectionViewDataSources
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        print(PollAnswers)
        return PollAnswers.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InterestsCollectionViewCell
        
        self.Dict.valueForKey("itemImage")! as? String
        
        let url = NSURL(string: (self.PollAnswers[indexPath.row]["content"]! as? String)!)
        cell.intImg.sd_setImageWithURL(url)
        cell.intImg.layer.cornerRadius = 10.0
        cell.intImg.clipsToBounds = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!,layout collectionViewLayout: UICollectionViewLayout!,insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if isiPhone6
        {
            let sectionInsets = UIEdgeInsets(top: 10.0, left: 25.0, bottom: 0.0, right: 25.0)
            return sectionInsets
        }
        else if isiPhone6plus
        {
            let sectionInsets = UIEdgeInsets(top: 10.0, left: 35.0, bottom: 0.0, right: 35.0)
            return sectionInsets
        }
        else
        {
            let sectionInsets = UIEdgeInsets(top:3.0, left: 8.0, bottom: 0.0, right: 8.0)
            return sectionInsets
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if  isiPhone5orLower
        {
            return CGSizeMake(153, 111)
        }
        else
        {
            return CGSizeMake(163, 121)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.ImagePolPopView.hidden = false
        let url = NSURL(string: (self.PollAnswers[indexPath.row]["content"]! as? String)!)
        self.PopImage.sd_setImageWithURL(url)
        ImagePolCount=indexPath.row as Int
        
    }
    
}
