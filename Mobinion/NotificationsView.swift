//
//  NotificationsView.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/9/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import SDWebImage
import TextAttributes

class NotificationsView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var notifyArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBarController?.tabBar.hidden = true
        
        tableView.registerClass(NotificationTableViewCell.self, forCellReuseIdentifier: "notifyCell")
        let nib:UINib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "notifyCell")
        
        doNotify()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 144
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
        return notifyArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        // for rounded profile pic
        cell.profImage.layer.cornerRadius = cell.profImage.frame.size.width / 2
        cell.profImage.clipsToBounds = true
        
        if (!(notifyArray[indexPath.row]["actorImage"]!!.isKindOfClass(NSNull)))
        {
            let url = NSURL(string: notifyArray[indexPath.row]["actorImage"] as! String)
            
//            print(url!)
            
            cell.profImage.sd_setImageWithURL(url!)
        }
        
        if (!(notifyArray[indexPath.row]["createdAt"]!!.isKindOfClass(NSNull)))
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let datesString:NSDate = dateFormatter.dateFromString(notifyArray[indexPath.row]["createdAt"] as! String)!
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            
//            print(datesString)
            
            cell.timeText.text = timeAgoSince(datesString)
        }
        
        
        let para = NSMutableAttributedString()
        var actorName = NSAttributedString()
        var content = NSAttributedString()
        var text = NSAttributedString()
        let space = NSAttributedString(string: " ")
        let hiphen = NSAttributedString(string: " - ")
        
        if (!(notifyArray[indexPath.row]["actorName"]!!.isKindOfClass(NSNull)))
        {
            let attrs = TextAttributes()
                .font(name: "Roboto-Medium", size: 16)
            
            actorName = NSAttributedString(string: notifyArray[indexPath.row]["actorName"] as! String, attributes: attrs)
            para.appendAttributedString(actorName)
            para.appendAttributedString(space)
//            cell.detailsText.attributedText = NSAttributedString(string: "The quick brown fox jumps over the lazy dog", attributes: attrs)
        }
        
        if (!(notifyArray[indexPath.row]["content"]!!.isKindOfClass(NSNull)))
        {
            let attrs = TextAttributes()
                .font(name: "Roboto-Regular", size: 15)
            
            content = NSAttributedString(string: notifyArray[indexPath.row]["content"] as! String, attributes: attrs)
            para.appendAttributedString(content)
            para.appendAttributedString(hiphen)
        }
        
        if (!(notifyArray[indexPath.row]["text"]!!.isKindOfClass(NSNull)))
        {
            let attrs = TextAttributes()
                .font(name: "Roboto-Regular", size: 15)
//                .foregroundColor(red: 15, green: 194, blue: 196, alpha: 1)
            .foregroundColor(UIColor.cyanColor())
            
//            print(notifyArray[indexPath.row]["text"] as! String)
            
            text = NSAttributedString(string: notifyArray[indexPath.row]["text"] as! String, attributes: attrs)
            para.appendAttributedString(text)
        }
        
        cell.detailsText.attributedText = para
        
//        let sizeThatFitsTextView: CGSize = cell.detailsText.sizeThatFits(CGSizeMake(cell.detailsText.frame.size.width, CGFloat(MAXFLOAT)))
//        cell.textViewHeightConstraint.constant = sizeThatFitsTextView.height
        
        cell.textViewHeightConstraint.constant = cell.detailsText.intrinsicContentSize().height
//        cell.detailsText.height
//        cell.detailsText.sizeToFit()
        
        return cell
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("newsFeedMain") as! NewsFeedMyProfile
        self.presentViewController(view, animated: false, completion: nil)
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
    
    func getNotification(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/getNotification"
        
//        let parameter = ["search_text" : ""]
        
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
    
    func doNotify()
    {
        StartLoader()
        getNotification()
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
                            self.notifyArray = responseObject["data"]!["notifications"]!!.mutableCopy() as! NSMutableArray
                            //print (self.newsFeed)
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

}