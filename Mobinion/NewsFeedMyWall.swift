//
//  NewsFeedMyWall.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/21/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import DateTools
import DBAlertController

class NewsFeedMyWall: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var newsFeed: NSMutableArray = NSMutableArray()
    
//    var jsondata:JSON = [:]
    
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        [tableView.registerClass(NewsFeedTableViewCell.self, forCellReuseIdentifier: "Polls")]
        var nib:UINib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Polls")
        
        [tableView.registerClass(NewsFeedTableViewCell2.self, forCellReuseIdentifier: "Voting")]
        nib = UINib(nibName: "NewsFeedTableViewCell2", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Voting")
        
        [tableView.registerClass(NewsFeedTableViewCell3.self, forCellReuseIdentifier: "ChooseTopics")]
        nib = UINib(nibName: "NewsFeedTableViewCell3", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ChooseTopics")
        
        [tableView.registerClass(NewsFeedTableViewCell4.self, forCellReuseIdentifier: "Follow")]
        nib = UINib(nibName: "NewsFeedTableViewCell4", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Follow")
        
        [tableView.registerClass(NewsFeedTableViewCell5.self, forCellReuseIdentifier: "Shared")]
        nib = UINib(nibName: "NewsFeedTableViewCell5", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Shared")
        
        [tableView.registerClass(NewsFeedTableViewCell6.self, forCellReuseIdentifier: "Winner")]
        nib = UINib(nibName: "NewsFeedTableViewCell6", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Winner")
        
        domyWall()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 228
        
//        tableView.layer.cornerRadius = 10
//        tableView.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        self.StartLoader()
        return self.newsFeed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       let result = UITableViewCell()
        
        if (newsFeed[indexPath.row]["type"]!!.isEqualToString("poll"))
        {
            //                    print("inside polls")
            let cell = tableView.dequeueReusableCellWithIdentifier("Polls") as! NewsFeedTableViewCell
            if (!(newsFeed[indexPath.row]["userImage"]!!.isEqualToString("")))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
//                print(url)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                
                cell.profPic.image = image
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["userName"]!!.isEqualToString("")))
            {
                cell.profName.text = (newsFeed[indexPath.row]["userName"] as! String)
            }
            
            if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isEqualToString("")))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                //                            print(newsFeed[indexPath.row]["item_createdDate"].stringValue)
                
                let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!
                //                            print(datesString)
                
                
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
//                print(datesString)
//                print(timeAgoSince(datesString))
                
                
//                cell.pollCreated.text = dateFormatter.stringFromDate(datesString)
                cell.pollCreated.text = timeAgoSince(datesString)
            }
            //
            if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isEqualToString("")))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                //                            print(datesString)
                
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
//                print(datesString)
//                print(datesString.timeIntervalSinceNow)
                
                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
            }
            //
            if (!(newsFeed[indexPath.row]["itemDescription"]!!.isEqualToString("")))
            {
                cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
            }
            
            if (!(newsFeed[indexPath.row]["itemText"]!!.isEqualToString("")))
            {
                cell.textBox.text = cell.textBox.text.stringByAppendingString("\n\n")
                cell.textBox.text = cell.textBox.text.stringByAppendingString(newsFeed[indexPath.row]["itemText"] as! String)
            }
            
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
            
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.masksToBounds = true
            
            return cell
        }
            
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("contest"))
        {
            //                    print("inside contest")
            let cell = tableView.dequeueReusableCellWithIdentifier("Voting") as! NewsFeedTableViewCell2
            //
            if (!(newsFeed[indexPath.row]["userImage"]!!.isEqualToString("")))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                //                            print(url)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                
                cell.profPic.image = image
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["itemImage"]!!.isEqualToString("")))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                //                        print(url)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                
                cell.img1.image = image
            }
            else
            {
                cell.img1.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["itemImage"]!!.isEqualToString("")))
            {
                cell.VotName.text = (newsFeed[indexPath.row]["itemText"] as! String)
            }
            //
            if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isEqualToString("")))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //                            print(newsFeed[indexPath.row]["item_createdDate"].stringValue)
                
                let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!
                //                            print(datesString)
                
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
//                cell.voCreated.text = dateFormatter.stringFromDate(datesString)
                cell.voCreated.text = timeAgoSince(datesString)
            }
            
            if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isEqualToString("")))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //                            print(newsFeed[indexPath.row]["item_expiryDate"].stringValue)
                
                let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                //                            print(datesString)
                
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
            }
            
            if (!(newsFeed[indexPath.row]["itemDescription"]!!.isEqualToString("")))
            {
                cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
            }
            
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
            
            return cell
        }
//
//                    case "photo_upload":
//
//                    case "writing":
//
//                    case "ques_poll":
        
//                    case 1:
//                        cell = tableView.dequeueReusableCellWithIdentifier("Voting") as! NewsFeedTableViewCell2
//
//                    case 2:
//                        cell = tableView.dequeueReusableCellWithIdentifier("ChooseTopics") as! NewsFeedTableViewCell3
//
//                    case 3:
//                        cell = tableView.dequeueReusableCellWithIdentifier("Follow") as! NewsFeedTableViewCell4
//
//                    case 4:
//                        cell = tableView.dequeueReusableCellWithIdentifier("Shared") as! NewsFeedTableViewCell5
//
//                    case 5:
//                        cell = tableView.dequeueReusableCellWithIdentifier("Winner") as! NewsFeedTableViewCell6

        return result
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.contentView.backgroundColor = UIColor.grayColor()
        
//        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width - 5, cell.contentView.frame.size.height - 8))

        let whiteRoundedView: UIView = UIView(frame: CGRectMake(0, 0, cell.contentView.frame.size.width - 3, cell.contentView.frame.size.height - 3))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }
    
    //MARK:- CLLocationManagerDelegates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0]
        
        lat = String(userLocation.coordinate.latitude)
        long = String(userLocation.coordinate.longitude)
    }
    
    //MARK:- Actions
    @IBAction func showLists(sender: AnyObject)
    {
        
    }
    
    @IBAction func notify(sender: AnyObject)
    {
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/getNotification"
        
        Alamofire.request(.GET, URL,headers: header ,encoding: .JSON)
            .responseJSON { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print(json)
                    }
                case .Failure(let error):
                    print("Request Failed with Error!!! \(error)")
                }
        }
        
    }
    
    @IBAction func search(sender: AnyObject)
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
    
    func domyWall()
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)

        
        let URL = "http://vyooha.cloudapp.net:1337/mobileNewsFeed"
        
        self.StartLoader()
        
        Alamofire.request(.GET, URL,headers: header ,encoding: .JSON)
            .responseJSON { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
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
                                let responseObject = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! [String:AnyObject]
                                self.newsFeed = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray
                                //print (self.newsFeed)
                            }
                        
                            catch
                            {
                                print("error in responseObject")
                            }
                        }
                        self.tableView.reloadData()
                        self.HideLoader()
                    }
                case .Failure(let error):
                    self.HideLoader()
                    print(error)
                    self.doDBalertView("Error", msgs: (error.localizedDescription))
                }
        }
    }
    
    func timeAgoSince(date: NSDate) -> String
    {
        
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfYear, .Month, .Year]
        let components = calendar.components(unitFlags, fromDate: date, toDate: now, options: [])
        
        if components.year >= 2 {
            return "\(components.year) years ago"
        }
        
        if components.year >= 1 {
            return "Last year"
        }
        
        if components.month >= 2 {
            return "\(components.month) months ago"
        }
        
        if components.month >= 1 {
            return "Last month"
        }
        
        if components.weekOfYear >= 2 {
            return "\(components.weekOfYear) weeks ago"
        }
        
        if components.weekOfYear >= 1 {
            return "Last week"
        }
        
        if components.day >= 2 {
            return "\(components.day) days ago"
        }
        
        if components.day >= 1 {
            return "Yesterday"
        }
        
        if components.hour >= 2 {
            return "\(components.hour) hours ago"
        }
        
        if components.hour >= 1 {
            return "An hour ago"
        }
        
        if components.minute >= 2 {
            return "\(components.minute) minutes ago"
        }
        
        if components.minute >= 1 {
            return "A minute ago"
        }
        
        if components.second >= 3 {
            return "\(components.second) seconds ago"
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


}
