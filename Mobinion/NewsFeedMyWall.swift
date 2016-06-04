//
//  NewsFeedMyWall.swift
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
import UIScrollView_InfiniteScroll
import Spring
import DLRadioButton

class NewsFeedMyWall: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var dropdownList: UIView!
    @IBOutlet weak var dropdownList: SpringView!
    @IBOutlet weak var tableviewTopConstraints: NSLayoutConstraint!
    
    var newsFeed = NSMutableArray()
    var searchFeed = NSMutableArray()
    var users = NSMutableArray()
    var rowno:Int = 1
    
    var feedType = "all"
    var itemID = ""
    var feedID = ""
    var itemType = ""
//    var ItemSelctdId = ""
    
//    var jsondata:JSON = [:]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.registerClass(NewsFeedTableViewCell.self, forCellReuseIdentifier: "Polls")
        var nib:UINib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Polls")
        
        tableView.registerClass(NewsFeedTableViewCell2.self, forCellReuseIdentifier: "Voting")
        nib = UINib(nibName: "NewsFeedTableViewCell2", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Voting")
        
        tableView.registerClass(NewsFeedTableViewCell3.self, forCellReuseIdentifier: "ChooseTopics")
        nib = UINib(nibName: "NewsFeedTableViewCell3", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ChooseTopics")
        
        tableView.registerClass(NewsFeedTableViewCell4.self, forCellReuseIdentifier: "Follow")
        nib = UINib(nibName: "NewsFeedTableViewCell4", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Follow")
        
        tableView.registerClass(NewsFeedTableViewCell5.self, forCellReuseIdentifier: "Shared")
        nib = UINib(nibName: "NewsFeedTableViewCell5", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Shared")
        
        tableView.registerClass(NewsFeedTableViewCell6.self, forCellReuseIdentifier: "Winner")
        nib = UINib(nibName: "NewsFeedTableViewCell6", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Winner")
        
        tableView.registerClass(PollShared.self, forCellReuseIdentifier: "PollShared")
        nib = UINib(nibName: "PollSharedCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PollShared")
        
        tableView.registerClass(NewsFeedTableNoFeedsCell.self, forCellReuseIdentifier: "NoFeeds")
        nib = UINib(nibName: "NewsFeedTableNoFeedsCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "NoFeeds")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 228
        
        domyWall()
        
        // change indicator view style to white
        tableView.infiniteScrollIndicatorStyle = .White
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler
        { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            
             //fetch your data here, can be async operation,
             //just make sure to call finishInfiniteScroll in the end
            
            
            self.getFeeds()
            { value, data, error in
                if value != nil
                {
                    let json = JSON(value!)
                    print(json)
                    
                    //                        self.HideLoader()
                    
                    let titles = json["status"].stringValue
//                    let messages = json["message"].stringValue
                    
                    if titles == "error"
                    {
                        //                            self.doDBalertView(titles, msgs: messages)
                    }
                    else
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                            let newsFeedNew: NSArray = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSArray
//                            self.newsFeed.arrayByAddingObjectsFromArray(newsFeedNew.mutableCopy()) as! NSDictionary
                            let numbers = (self.newsFeed.copy() as! NSArray).arrayByAddingObjectsFromArray(newsFeedNew as [AnyObject]) as! [NSMutableArray]
//                            (responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray)
//                            print("after \(self.rowno) rows")
                            
//                            print(numbers.count)
//                            print(newsFeedNew)
                            self.newsFeed.removeAllObjects()
                            self.newsFeed=NSMutableArray(array: numbers, copyItems: true)
//                            print(self.newsFeed.count)
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
                    //                        self.HideLoader()
                    //                    print(error)
                    //                        self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                }
            }

            
            
            // make sure you reload tableView before calling -finishInfiniteScroll
//            tableView.reloadData()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
        
//        tableView.emptyDataSetSource = self
//        tableView.emptyDataSetDelegate = self
//        tableView.tableFooterView = UIView()
        
//        tableView.layer.cornerRadius = 10
//        tableView.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        self.StartLoader()
        print(newsFeed.count)
        return self.newsFeed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
//        debugPrint(newsFeed[indexPath.row])
        if (newsFeed[indexPath.row]["cardDetails"]!!.isKindOfClass(NSDictionary))
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Winner") as! NewsFeedTableViewCell6
            
            cell.text2.text = (newsFeed[indexPath.row]["cardDetails"]!!["text"]!! as! String)
            cell.text3.text = (newsFeed[indexPath.row]["cardDetails"]!!["conductedBy"]!! as! String)
            
            cell.bgImg.layer.masksToBounds = false
            cell.bgImg.layer.cornerRadius = 5
            cell.bgImg.layer.borderWidth = 2
            cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
            
            cell.selectionStyle = .None//UITableViewCellSelectionStyle.None
            
            return cell
        }
        //Cards Type
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("card"))
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChooseTopics") as! NewsFeedTableViewCell3
            
            cell.bgImg.layer.masksToBounds = false
            cell.bgImg.layer.cornerRadius = 5
            cell.bgImg.layer.borderWidth = 2
            cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
            
            cell.selectionStyle = .None
            
            return cell
        }
        //Shared Type
        else if (newsFeed[indexPath.row]["feedType"]!!.isEqualToString("shared"))
        {
            //Shared Poll
            if (newsFeed[indexPath.row]["type"]!!.isEqualToString("poll"))
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("PollShared") as! PollShared
                
                cell.BgImg.layer.masksToBounds = false
                cell.BgImg.layer.cornerRadius = 5
                cell.BgImg.layer.borderWidth = 2
                cell.BgImg.layer.borderColor = UIColor.clearColor().CGColor
                
                if (newsFeed[indexPath.row].valueForKey("sharedUserName")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["sharedUserName"]!!.isKindOfClass(NSNull)))
                    {
                        cell.nameofSharer.text = (newsFeed[indexPath.row]["sharedUserName"] as! String)
                    }
                    else
                    {
                        cell.nameofSharer.text = ""
                    }
                }
                else
                {
                    cell.nameofSharer.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("sharedOn")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["sharedOn"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["sharedOn"] as! String)!
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        
                        cell.sharedOn.text = dateFormatter.stringFromDate(datesString)
                    }
                    else
                    {
                        cell.sharedOn.text = ""
                    }
                }
                else
                {
                    cell.sharedOn.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["participants"]!!.isKindOfClass(NSNull)))
                    {
                        let no = newsFeed[indexPath.row]["participants"]!!.integerValue
                        
                        if no != 0
                        {
                            cell.voteNo.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                        }
                        else
                        {
                            cell.voteNo.text = ""
                        }
                    }
                    else
                    {
                        cell.voteNo.text = ""
                    }
                }
                else
                {
                    cell.voteNo.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("userImage")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                    {
                        let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                        //                print(url)
                        
                        cell.profPic.sd_setImageWithURL(url!)
                        
                        // for rounded profile pic
                        cell.profPic.layer.cornerRadius = cell.profPic.frame.size.width / 2
                        cell.profPic.clipsToBounds = true
                    }
                    else
                    {
                        cell.profPic.image = nil
                    }
                }
                else
                {
                    cell.profPic.image = nil
                }
                
                if (newsFeed[indexPath.row].valueForKey("userName")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                    {
                        cell.profName.text = (newsFeed[indexPath.row]["userName"] as! String)
                    }
                    else
                    {
                        
                        cell.profName.text = ""
                    }
                }
                else
                {
                    
                    cell.profName.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("item_createdDate")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC")
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                        //                            print(newsFeed[indexPath.row]["item_createdDate"].stringValue)
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!
                        //                            print(datesString)
                        
                        
                        dateFormatter.dateFormat = "dd-MMM-yyyy"
                        
                        //                cell.pollCreated.text = dateFormatter.stringFromDate(datesString)
                        cell.pollCreated.text = timeAgoSince(datesString)
                    }
                    else
                    {
                        
                        cell.pollCreated.text = ""
                    }
                }
                else
                {
                    
                    cell.pollCreated.text = ""
                }
                //
                if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                        //                            print(datesString)
                        
                        dateFormatter.dateFormat = "dd-MMM-yyyy"
                        
                        //                print(datesString)
                        //                print(datesString.timeIntervalSinceNow)
                        
                        //                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
                        cell.expiryDate.text = timeAgoSince(datesString)
                    }
                    else
                    {
                        
                        cell.expiryDate.text = ""
                    }

                }
                else
                {
                    
                    cell.expiryDate.text = ""
                }
                //
                if (newsFeed[indexPath.row].valueForKey("itemDescription")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                    {
                        cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                    }
                    else
                    {
                        
                        cell.textBox.text = ""
                    }
                }
                else
                {
                    
                    cell.textBox.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("itemText")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["itemText"]!!.isKindOfClass(NSNull)))
                    {
                        cell.textBox.text = cell.textBox.text.stringByAppendingString("\n\n")
                        cell.textBox.text = cell.textBox.text.stringByAppendingString(newsFeed[indexPath.row]["itemText"] as! String)
                    }
                    else
                    {
                        
                        cell.textBox.text = cell.textBox.text.stringByAppendingString("")
                    }
                }
                else
                {
                    
                    cell.textBox.text = cell.textBox.text.stringByAppendingString("")
                }
                
                if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
                {
                    cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                }
                else
                {
                    
                    cell.totalNos.text = "0"
                }
                
                cell.selectionStyle = .None
                
                return cell
            }
                
                //Shared Contest
            else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("contest"))
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Shared") as! NewsFeedTableViewCell5
                
                cell.bgImg.layer.masksToBounds = false
                cell.bgImg.layer.cornerRadius = 5
                cell.bgImg.layer.borderWidth = 2
                cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
                
                cell.voteIdentity.image = UIImage(named: "contest-new")
                
                if (newsFeed[indexPath.row].valueForKey("sharedUserName")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["sharedUserName"]!!.isKindOfClass(NSNull)))
                    {
                        cell.nameofSharer.text = (newsFeed[indexPath.row]["sharedUserName"] as! String)
                    }
                    else
                    {
                        cell.nameofSharer.text = ""
                    }
                }
                else
                {
                    cell.nameofSharer.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("sharedOn")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["sharedOn"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["sharedOn"] as! String)!
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        
                        cell.sharedOn.text = dateFormatter.stringFromDate(datesString)
                    }
                    else
                    {
                        cell.sharedOn.text = ""
                    }
                }
                else
                {
                    cell.sharedOn.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["participants"]!!.isKindOfClass(NSNull)))
                    {
                        let no = newsFeed[indexPath.row]["participants"]!!.integerValue
                        
                        if no != 0
                        {
                            cell.voteNo.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                        }
                        else
                        {
                            cell.voteNo.text = ""
                        }
                    }
                    else
                    {
                        cell.voteNo.text = ""
                    }
                }
                else
                {
                    cell.voteNo.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("userImage")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                    {
                        let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                        
                        cell.profilePic.sd_setImageWithURL(url!)
                        
                        // for rounded profile pic
                        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
                        cell.profilePic.clipsToBounds = true

                    }
                    else
                    {
                        cell.profilePic.image = nil
                    }
                }
                else
                {
                    cell.profilePic.image = nil
                }
                
                if (newsFeed[indexPath.row].valueForKey("itemImage")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
                    {
                        let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                        cell.IMView.sd_setImageWithURL(url!)
                    }
                    else
                    {
                        cell.IMView.image = nil
                    }
                }
                else
                {
                    cell.IMView.image = nil
                }

                
                if (newsFeed[indexPath.row].valueForKey("userName")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                    {
                        cell.userName.text = (newsFeed[indexPath.row]["userName"] as! String)
                    }
                    else
                    {
                        cell.userName.text = ""
                    }
                }
                else
                {
                    cell.userName.text = ""
                }
                //
                if (newsFeed[indexPath.row].valueForKey("item_createdDate")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //                            print(newsFeed[indexPath.row]["item_createdDate"].stringValue)
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!
                        //                            print(datesString)
                        
                        dateFormatter.dateFormat = "dd-MMM-yyyy"
                        
                        //                cell.voCreated.text = dateFormatter.stringFromDate(datesString)
                        cell.dateCreated.text = timeAgoSince(datesString)
                    }
                    else
                    {
                        cell.dateCreated.text = ""
                    }
                }
                else
                {
                    cell.dateCreated.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //                            print(newsFeed[indexPath.row]["item_expiryDate"].stringValue)
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                        //                            print(datesString)
                        
                        dateFormatter.dateFormat = "dd-MMM-yyyy"
                        
                        //                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
                        cell.poleExpiry.text = timeAgoSince(datesString)
                    }
                    else
                    {
                        cell.poleExpiry.text = ""
                    }
                }
                else
                {
                    cell.poleExpiry.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("itemDescription")?.isKindOfClass(NSNull) != nil)
                {

                    if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                    {
                        cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                    }
                    else
                    {
                        cell.textBox.text = ""
                    }

                }
                else
                {
                    cell.textBox.text = ""
                }
                //            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
                //  
                if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
                {
                    cell.totalPoles.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                }
                else
                {
                    cell.totalPoles.text = "0"
                }
                
                cell.selectionStyle = .None
                
                return cell
            }
                
            //Shared Votes
            else //if (newsFeed[indexPath.row]["type"]!!.isEqualToString("voting"))
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Shared") as! NewsFeedTableViewCell5
                
                cell.bgImg.layer.masksToBounds = false
                cell.bgImg.layer.cornerRadius = 5
                cell.bgImg.layer.borderWidth = 2
                cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
                
                cell.voteIdentity.image = UIImage(named: "voting-new")
                
                if (newsFeed[indexPath.row].valueForKey("sharedUserName")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["sharedUserName"]!!.isKindOfClass(NSNull)))
                    {
                        cell.nameofSharer.text = (newsFeed[indexPath.row]["sharedUserName"] as! String)
                    }
                    else
                    {
                        cell.nameofSharer.text = ""
                    }
                }
                else
                {
                    cell.nameofSharer.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("sharedOn")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["sharedOn"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["sharedOn"] as! String)!
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        
                        cell.sharedOn.text = dateFormatter.stringFromDate(datesString)
                    }
                    else
                    {
                        cell.sharedOn.text = ""
                    }
                }
                else
                {
                    cell.sharedOn.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["participants"]!!.isKindOfClass(NSNull)))
                    {
                        let no = newsFeed[indexPath.row]["participants"]!!.integerValue
                        
                        if no != 0
                        {
                            cell.voteNo.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                        }
                        else
                        {
                            cell.voteNo.text = ""
                        }
                    }
                    else
                    {
                        cell.voteNo.text = ""
                    }
                }
                else
                {
                    cell.voteNo.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("userImage")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                    {
                        let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                        
                        cell.profilePic.sd_setImageWithURL(url!)
                        
                        // for rounded profile pic
                        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
                        cell.profilePic.clipsToBounds = true
                    }
                    else
                    {
                        cell.profilePic.image = nil
                    }
                }
                else
                {
                    cell.profilePic.image = nil
                }
                
                if (newsFeed[indexPath.row].valueForKey("itemImage")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
                    {
                        let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                        cell.IMView.sd_setImageWithURL(url!)
                    }
                    else
                    {
                        cell.IMView.image = nil
                    }
                }
                else
                {
                    cell.IMView.image = nil
                }
                
                if (newsFeed[indexPath.row].valueForKey("userName")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                    {
                        cell.userName.text = (newsFeed[indexPath.row]["userName"] as! String)
                    }
                    else
                    {
                        cell.userName.text = ""
                    }
                }
                else
                {
                    cell.userName.text = ""
                }
                //
                if (newsFeed[indexPath.row].valueForKey("item_createdDate")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //                            print(newsFeed[indexPath.row]["item_createdDate"].stringValue)
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!
                        //                            print(datesString)
                        
                        dateFormatter.dateFormat = "dd-MMM-yyyy"
                        
                        //                cell.voCreated.text = dateFormatter.stringFromDate(datesString)
                        cell.dateCreated.text = timeAgoSince(datesString)
                    }
                    else
                    {
                        cell.dateCreated.text = ""
                    }
                }
                else
                {
                    cell.dateCreated.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //                            print(newsFeed[indexPath.row]["item_expiryDate"].stringValue)
                        
                        let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                        //                            print(datesString)
                        
                        dateFormatter.dateFormat = "dd-MMM-yyyy"
                        
                        //                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
                        cell.poleExpiry.text = timeAgoSince(datesString)
                    }
                    else
                    {
                        cell.poleExpiry.text = ""
                    }
                }
                else
                {
                    cell.poleExpiry.text = ""
                }
                
                if (newsFeed[indexPath.row].valueForKey("itemDescription")?.isKindOfClass(NSNull) != nil)
                {
                    if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                    {
                        cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                    }
                    else
                    {
                        cell.textBox.text = ""
                    }
                }
                else
                {
                    cell.textBox.text = ""
                }
                
                //            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
                //            {
                if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
                {
                    cell.totalPoles.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                }
                else
                {
                    cell.totalPoles.text = "0"
                }
                //            }
                
                cell.selectionStyle = .None
                
                return cell
            }
        }
        //Poll Type
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("poll"))
        {
            //print("inside polls")
            let cell = tableView.dequeueReusableCellWithIdentifier("Polls") as! NewsFeedTableViewCell
            
            cell.BgImg.layer.masksToBounds = false
            cell.BgImg.layer.cornerRadius = 5
            cell.BgImg.layer.borderWidth = 2
            cell.BgImg.layer.borderColor = UIColor.clearColor().CGColor
            
            if (newsFeed[indexPath.row].valueForKey("userImage")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                    //                print(url)
                    
                    cell.profPic.sd_setImageWithURL(url!)
                    
                    // for rounded profile pic
                    cell.profPic.layer.cornerRadius = cell.profPic.frame.size.width / 2
                    cell.profPic.clipsToBounds = true
                }
                else
                {
                    cell.profPic.image = nil
                }
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (newsFeed[indexPath.row].valueForKey("userName")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                {
                    cell.profName.text = (newsFeed[indexPath.row]["userName"] as! String)
                }
                else
                {
                    cell.profName.text = ""
                }
            }
            else
            {
                cell.profName.text = ""
            }
            
            if (newsFeed[indexPath.row].valueForKey("item_createdDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isKindOfClass(NSNull)))
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    dateFormatter.timeZone = NSTimeZone(name: "UTC")
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                    
                    let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!

                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    

                    cell.pollCreated.text = timeAgoSince(datesString)
                }
                else
                {
                    cell.pollCreated.text = ""
                }
            }
            else
            {
                cell.pollCreated.text = ""
            }
            //
            if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!

                    
                    dateFormatter.dateFormat = "dd-MMM-yyyy"

                    cell.expiryDate.text = timeAgoSince(datesString)
                }
                else
                {
                    cell.expiryDate.text = ""
                }
            }
            else
            {
                cell.expiryDate.text = ""
            }
            //
            if (newsFeed[indexPath.row].valueForKey("itemDescription")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                }
                else
                {
                    cell.textBox.text = ""
                }
            }
            else
            {
                cell.textBox.text = ""
            }
            
            if (newsFeed[indexPath.row].valueForKey("itemText")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["itemText"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = cell.textBox.text.stringByAppendingString("\n\n")
                    cell.textBox.text = cell.textBox.text.stringByAppendingString(newsFeed[indexPath.row]["itemText"] as! String)
                }
                else
                {
                    cell.textBox.text = cell.textBox.text.stringByAppendingString("")
                }
            }
            else
            {
                cell.textBox.text = cell.textBox.text.stringByAppendingString("")
            }
            

            if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
            {
                cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)

            }
            else
            {
                cell.totalNos.text = ""
            }
            
            cell.selectionStyle = .None
            
            return cell
        }
         
        //Contest Type
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("contest"))
        {
            //                    print("inside contest")
            let cell = tableView.dequeueReusableCellWithIdentifier("Voting") as! NewsFeedTableViewCell2
            
            cell.voteIdentifier.image = UIImage(named: "contest-new")
            
            cell.bgImg.layer.masksToBounds = false
            cell.bgImg.layer.cornerRadius = 5
            cell.bgImg.layer.borderWidth = 2
            cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
            
            //
            if (newsFeed[indexPath.row].valueForKey("userImage")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)

                    cell.profPic.sd_setImageWithURL(url!)
                    
                    // for rounded profile pic
                    cell.profPic.layer.cornerRadius = cell.profPic.frame.size.width / 2
                    cell.profPic.clipsToBounds = true
                }
                else
                {
                    cell.profPic.image = nil
                }
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (newsFeed[indexPath.row].valueForKey("itemImage")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)

                    cell.img1.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.img1.image = nil
                }
            }
            else
            {
                cell.img1.image = nil
            }

            
            if (newsFeed[indexPath.row].valueForKey("userName")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                {
                    cell.VotName.text = (newsFeed[indexPath.row]["userName"] as! String)
                }
                else
                {
                    cell.VotName.text = ""
                }
            }
            else
            {
                cell.VotName.text = ""
            }
            //
            if (newsFeed[indexPath.row].valueForKey("item_createdDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isKindOfClass(NSNull)))
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
                else
                {
                    cell.voCreated.text = ""
                }
            }
            else
            {
                cell.voCreated.text = ""
            }
            
            if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //                            print(newsFeed[indexPath.row]["item_expiryDate"].stringValue)
                    
                    let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                    //                            print(datesString)
                    
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    
                    //                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
                    cell.expiryDate.text = timeAgoSince(datesString)
                }
                else
                {
                    cell.expiryDate.text = ""
                }
            }
            else
            {
                cell.expiryDate.text = ""
            }
            
            if (newsFeed[indexPath.row].valueForKey("itemDescription")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                }
                else
                {
                    cell.textBox.text = ""
                }
            }
            else
            {
                cell.textBox.text = ""
            }
            

            if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
            {
                cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
            }
            else
            {
                 cell.totalNos.text = "0"
            }
            
            cell.selectionStyle = .None
            
            return cell
        }
            
        //Voting Type
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("voting"))
        {
            //                    print("inside voting")
            let cell = tableView.dequeueReusableCellWithIdentifier("Voting") as! NewsFeedTableViewCell2
            
            cell.bgImg.layer.masksToBounds = false
            cell.bgImg.layer.cornerRadius = 5
            cell.bgImg.layer.borderWidth = 2
            cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
            
            //
            if (newsFeed[indexPath.row].valueForKey("userImage")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                    cell.profPic.sd_setImageWithURL(url!)
                    
                    // for rounded profile pic
                    cell.profPic.layer.cornerRadius = cell.profPic.frame.size.width / 2
                    cell.profPic.clipsToBounds = true
                }
                else
                {
                    cell.profPic.image = nil
                }
            }
            
            if (newsFeed[indexPath.row].valueForKey("itemImage")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                    
                    cell.img1.sd_setImageWithURL(url!)
                    
                }
                else
                {
                    cell.img1.image = nil
                }
            }
            
            if (newsFeed[indexPath.row].valueForKey("userName")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                {
                    cell.VotName.text = (newsFeed[indexPath.row]["userName"] as! String)
                }
                else
                {
                    cell.VotName.text = ""
                }
            }
            else
            {
                cell.VotName.text = ""
            }
            //
            if (newsFeed[indexPath.row].valueForKey("item_createdDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_createdDate"]!!.isKindOfClass(NSNull)))
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
                else
                {
                    cell.voCreated.text = ""
                }
            }
            else
            {
                cell.voCreated.text = ""
            }
            
            if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    
                    let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                    
                    
                    //                            print(datesString)
                    
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    
                    //                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
                    cell.expiryDate.text = timeAgoSince(datesString)
                }
                else
                {
                    cell.expiryDate.text = ""
                }
            }
            else
            {
                cell.expiryDate.text = ""
            }
            
            if (newsFeed[indexPath.row].valueForKey("itemDescription")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                }
                else
                {
                    cell.textBox.text = ""
                }
            }
            else
            {
                cell.textBox.text = ""
            }
           
            if (newsFeed[indexPath.row].valueForKey("participants")?.isKindOfClass(NSNull) != nil)
            {
                cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
            }
            else
            {
                cell.totalNos.text = "0"
            }
            
            cell.selectionStyle = .None
            
            return cell

        }
//        //Feedback Type
//        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("feedback"))
//        {
//            let cell = tableView.dequeueReusableCellWithIdentifier("NoFeeds") as! NewsFeedTableNoFeedsCell
//            
//            return cell
//        }

        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoFeeds") as! NewsFeedTableNoFeedsCell
            
            cell.selectionStyle = .None
            
            return cell
        }
        
//        return result
        }
    
    //MARK:UITableViewDelegates
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        print("\(newsFeed[indexPath.row]["userName"] as! String) pressed")
        if (newsFeed[indexPath.row]["type"]!!.isEqualToString("poll"))
        {
            if (newsFeed[indexPath.row].valueForKey("item_expiryDate")?.isKindOfClass(NSNull) != nil)
            {
                if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
                {
                    itemID = newsFeed[indexPath.row]["itemId"] as! String
                    feedID = newsFeed[indexPath.row]["feedId"] as! String
                    itemType = newsFeed[indexPath.row]["itemType"] as! String
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                    //                            print(datesString)
                    
                    print(datesString.timeIntervalSince1970)
                    
                    
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    
                    let tdate = dateFormatter.stringFromDate(NSDate())
//                    print(tdate)
                    let date0:NSDate = dateFormatter.dateFromString(tdate)!
//                    print(date0)
                    print(date0.timeIntervalSince1970)
                    
                    if datesString < date0
                    {
                        performSegueWithIdentifier("showFeedCurrentStatus", sender: self)
                    }
                    else
                    {
                        performSegueWithIdentifier("Showpolldetailsfromfeed", sender: self)
                    }
                
                    //                print(datesString)
                    //                print(datesString.timeIntervalSinceNow)
               
                }
            }
        }
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("voting"))
        {
            itemID = newsFeed[indexPath.row]["itemId"] as! String
//            feedID = newsFeed[indexPath.row]["feedId"] as! String
            itemType = newsFeed[indexPath.row]["itemType"] as! String
            
            performSegueWithIdentifier("showVotingfromFeed", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (newsFeed[indexPath.row]["cardDetails"]!!.isKindOfClass(NSDictionary))
        {
            return 561.0
        }
        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("card"))
        {
            return 481.0
        }
        else
        {
            return 393.0
        }
    }
    
    //MARK:- UIScrollViewDelegates
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        //TODO:- check tabbar animation issues
//        if scrollView.panGestureRecognizer.translationInView(scrollView).y < 0
//        {
        
//            changeTabBar(true, animated: true)
            
//            getFeeds()
//                { value, data, error in
//                    
//                    if value != nil
//                    {
//                        let json = JSON(value!)
//                        print(json)
//                        
////                        self.HideLoader()
//                        
//                        let titles = json["status"].stringValue
//                        let messages = json["message"].stringValue
//                        
//                        if titles == "error"
//                        {
////                            self.doDBalertView(titles, msgs: messages)
//                        }
//                        else
//                        {
//                            do
//                            {
//                                let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
////                                self.newsFeed = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray
//                                self.newsFeed.addObject(responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray)
//                                //                            print (self.newsFeed)
//                            }
//                            catch
//                            {
//                                print("error in responseObject")
//                            }
//                            self.tableView.reloadData()
//                        }
//                    }
//                    else
//                    {
////                        self.HideLoader()
//                        //                    print(error)
////                        self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
//                    }
//            }

//        }
//        else
//        {
//            changeTabBar(false, animated: true)
//        }
    }

//    //MARK:- DZNEmptyDataSetDelegate
//    //    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
//    //    {
//    //        let str = "Welcome"
//    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
//    //        return NSAttributedString(string: str, attributes: attrs)
//    //    }
//    
//    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
//    {
//        let str = "You dont have any feeds\n\nPlease check back later"
//        let attrs = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 17)!]
//        
//        return NSAttributedString(string: str, attributes: attrs)
//    }
    
    //MARK:- Actions
    @IBAction func showLists(sender: AnyObject)
    {
        //TODO:- put animation delay
        if tableviewTopConstraints.constant == 0
        {
            tableviewTopConstraints.constant = 147
            
//            dropdownList.animation = "fadeOut"
//            dropdownList.animate()

        }
        else
        {
            tableviewTopConstraints.constant = 0
        }
    }
    
    @IBAction func notify(sender: AnyObject)
    {
        performSegueWithIdentifier("showNotificationFromFeed", sender: sender)
        
//        let view = self.storyboard!.instantiateViewControllerWithIdentifier("notifications") as! NotificationsView
//        self.presentViewController(view, animated: true, completion: nil)
    }
    
    @IBAction func search(sender: AnyObject)
    {
        StartLoader()
        getSearch()
        { value, data, error in
                
            if value != nil
            {
                let json = JSON(value!)
//                print(json)
                
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
                        self.searchFeed = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray
                        self.users = responseObject["data"]!["users"]!!.mutableCopy() as! NSMutableArray
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
    
    
    @IBAction func checkSelectedButton(sender: DLRadioButton)
    {
        for button in sender.selectedButtons()
        {
//            print(button.tag)
            switch button.tag
            {
                case 1:
                    feedType = "all"
                case 2:
                    feedType = "polls"
                case 3:
                    feedType = "votings"
                case 4:
                    feedType = "contests"
    //            case 5:
    //                feedType = "feedbacks"
                default:
                    break
            }
            
        }
        
        tableviewTopConstraints.constant = 0
        domyWallafterSelection()
//        print("Before Removal:- \(newsFeed)")
//        newsFeed.removeAllObjects()
//        domyWall()
//        print("After Removal:- \(newsFeed)")
//        print(feedType)
    }
    
    //MARK:- Overrides
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
//        print(segue.identifier)
        if segue.identifier == "showFeedCurrentStatus"
        {
            let secondVC = segue.destinationViewController as! FeedItemCurrentStand
            secondVC.itemID = itemID
            secondVC.feedID = feedID
            secondVC.itemType = itemType
        }
        else if segue.identifier == "Showpolldetailsfromfeed"
        {
            let secondVC = segue.destinationViewController as! PollScreen1ViewController
            secondVC.ItemId = itemID
            secondVC.itemType = itemType
        }
        else if segue.identifier == "showVotingfromFeed"
        {
            let secondVC = segue.destinationViewController as! FeedItemVoting
            secondVC.itemID = itemID
            secondVC.feedID = feedID
            secondVC.itemType = itemType
        }
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
        self.StartLoader()
        
        getFeeds()
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
                        self.newsFeed = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray
                        print (self.newsFeed)
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
    
    func domyWallafterSelection()
    {
        self.StartLoader()
        
        print("Before Removal:- \(newsFeed)")
//        newsFeed.removeAllObjects()
        
        getFeeds()
            { value, data, error in
                if value != nil
                {
                    let json = JSON(value!)
                    print(json)
                    
                    self.HideLoader()
                    
                    let titles = json["status"].stringValue
//                    let messages = json["message"].stringValue
                    
                    if titles == "error"
                    {
//                        self.doDBalertView(titles, msgs: messages)
                    }
                    else
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                            self.newsFeed = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray
//                            print (self.newsFeed)
                            print("After Removal:- \(self.newsFeed)")

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
    
    func getFeeds(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
//        print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/mobileNewsFeed"//?rowNumber=1&showingType=all"
        
        let parameter = ["rowNumber": String(rowno), "showingType": feedType]//"all"]
        
        Alamofire.request(.GET, URL, headers: header, parameters: parameter, encoding: .URL)
//        Alamofire.request(.GET, URL, headers: header, encoding: .JSON)
        .responseJSON { response in
            switch response.result
            {
                case .Success:
                if let value = response.result.value
                {
                    completionHandler(value as? NSDictionary, response.data, nil)
                    
                    self.rowno += 1
                }
                case .Failure(let error):
                    completionHandler(nil,nil, error)
            }
        }
    }
    
    func getNotifications(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/getNotification"
        
        Alamofire.request(.GET, URL, headers: header, encoding: .JSON)
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
    
    func getSearch(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
            let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
            //print(toks)
            
            let header = ["Authorization": toks as! String]
            //print(header)
            
            let URL = "http://vyooha.cloudapp.net:1337/service/search"
            
            let parameter = ["search_text" : ""]
            
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
    
    func changeTabBar(hidden:Bool, animated: Bool)
    {
        let tabBar = self.tabBarController?.tabBar
        if tabBar!.hidden == hidden{ return }
        let frame = tabBar?.frame
//        frame.
        let offset = (hidden ? (frame?.size.height)! : -(frame?.size.height)!)
        let duration:NSTimeInterval = (animated ? 0.5 : 0.0)
        
        tabBar?.hidden = false
        
        if frame != nil
        {
            UIView.animateWithDuration(duration,
                                       animations: {tabBar!.frame = CGRectOffset(frame!, 0, offset)},
                                       completion: {
//                                        print($0)
                                        if $0 {tabBar?.hidden = hidden}
            })
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
