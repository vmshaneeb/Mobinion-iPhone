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

class NewsFeedMyWall: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var newsFeed = NSMutableArray()
    var searchFeed = NSMutableArray()
    var users = NSMutableArray()
    
//    var jsondata:JSON = [:]
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.

        tableView.registerClass(NewsFeedTableViewCell.self, forCellReuseIdentifier: "Polls")
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
        
        tableView.registerClass(PollShared.self, forCellReuseIdentifier: "PollShared")
        nib = UINib(nibName: "PollSharedCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PollShared")
        
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
        print(newsFeed.count)
        return self.newsFeed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       let result = UITableViewCell()
        
        //Shared Type
//        print(newsFeed[indexPath.row])
        if (newsFeed[indexPath.row]["feedType"]!!.isEqualToString("shared"))
        {
            //            //Shared Poll
            if (newsFeed[indexPath.row]["type"]!!.isEqualToString("poll"))
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("PollShared") as! PollShared
                
                cell.BgImg.layer.masksToBounds = false
                cell.BgImg.layer.cornerRadius = 5
                cell.BgImg.layer.borderWidth = 2
                cell.BgImg.layer.borderColor = UIColor.clearColor().CGColor
                
                if (!(newsFeed[indexPath.row]["sharedUserId"]!!.isKindOfClass(NSNull)))
                {
                    cell.nameofSharer.text = (newsFeed[indexPath.row]["sharedUserId"] as! String)
                }
                else
                {
                    cell.nameofSharer.text = ""
                }
                
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
                
                if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                    //                print(url)
                    
                    cell.profPic.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.profPic.image = nil
                }
                
                if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                {
                    cell.profName.text = (newsFeed[indexPath.row]["userName"] as! String)
                }
                
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
                //
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
                //
                if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                }
                
                if (!(newsFeed[indexPath.row]["itemText"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = cell.textBox.text.stringByAppendingString("\n\n")
                    cell.textBox.text = cell.textBox.text.stringByAppendingString(newsFeed[indexPath.row]["itemText"] as! String)
                }
                
                cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                
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
                
                if (!(newsFeed[indexPath.row]["sharedUserId"]!!.isKindOfClass(NSNull)))
                {
                    cell.nameofSharer.text = (newsFeed[indexPath.row]["sharedUserId"] as! String)
                }
                else
                {
                    cell.nameofSharer.text = ""
                }
                
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
                
                if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                    
                    cell.profilePic.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.profilePic.image = nil
                }
                
                if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                    cell.IMView.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.IMView.image = nil
                }
                
                if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                {
                    cell.userName.text = (newsFeed[indexPath.row]["userName"] as! String)
                }
                //
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
                
                if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                }
                
                //            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
                //            {
                cell.totalPoles.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                //            }
                
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
                
                if (!(newsFeed[indexPath.row]["sharedUserId"]!!.isKindOfClass(NSNull)))
                {
                    cell.nameofSharer.text = (newsFeed[indexPath.row]["sharedUserId"] as! String)
                }
                else
                {
                    cell.nameofSharer.text = ""
                }
                
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
                
                if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                    
                    cell.profilePic.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.profilePic.image = nil
                }
                
                if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                    cell.IMView.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.IMView.image = nil
                }
                
                if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
                {
                    cell.userName.text = (newsFeed[indexPath.row]["userName"] as! String)
                }
                //
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
                
                if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
                {
                    cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
                }
                
                //            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
                //            {
                cell.totalPoles.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
                //            }
                
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
            
            if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
//                print(url)

                cell.profPic.sd_setImageWithURL(url!)
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
            {
                cell.profName.text = (newsFeed[indexPath.row]["userName"] as! String)
            }
            
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
            //
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
            //
            if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
            {
                cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
            }
            
            if (!(newsFeed[indexPath.row]["itemText"]!!.isKindOfClass(NSNull)))
            {
                cell.textBox.text = cell.textBox.text.stringByAppendingString("\n\n")
                cell.textBox.text = cell.textBox.text.stringByAppendingString(newsFeed[indexPath.row]["itemText"] as! String)
            }
            
//            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
//            {
//                print("\(newsFeed[indexPath.row]["participants"])")
                cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
//                print(cell.totalNos.text)
//            }
            
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
            if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                //                            print(url)
//                let data = NSData(contentsOfURL: url!)
//                let image = UIImage(data: data!)
                
//                cell.profPic.image = image
                cell.profPic.sd_setImageWithURL(url!)
//                cell.profPic.hnk_setImageFromURL(url!, format: Format<UIImage>(name: "original"))
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)
                //                        print(url)
//                let data = NSData(contentsOfURL: url!)
//                let image = UIImage(data: data!)
                
//                cell.img1.image = image
                cell.img1.sd_setImageWithURL(url!)
//                cell.img1.sd_setImageWithURL(url!, placeholderImage: UIImage(named: ""))
//                cell.img1.hnk_setImageFromURL(url!, format: Format<UIImage>(name: "original2"))
                
            }
            else
            {
                cell.img1.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
            {
                cell.VotName.text = (newsFeed[indexPath.row]["userName"] as! String)
            }
            //
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
            
            if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
            {
                cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
            }
            
//            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
//            {
                cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
//            }
            
            return cell
        }
        
//        //Feedback Type
//        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("feedback"))
//        {
//
//        }
        
        //Voting Type
        else
//            if (newsFeed[indexPath.row]["type"]!!.isEqualToString("voting"))
        {
            //                    print("inside voting")
            let cell = tableView.dequeueReusableCellWithIdentifier("Voting") as! NewsFeedTableViewCell2
            
            cell.bgImg.layer.masksToBounds = false
            cell.bgImg.layer.cornerRadius = 5
            cell.bgImg.layer.borderWidth = 2
            cell.bgImg.layer.borderColor = UIColor.clearColor().CGColor
            
            //
            if (!(newsFeed[indexPath.row]["userImage"]!!.isKindOfClass(NSNull)))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["userImage"] as! String)
                cell.profPic.sd_setImageWithURL(url!)
            }
            else
            {
                cell.profPic.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["itemImage"]!!.isKindOfClass(NSNull)))
            {
                let url = NSURL(string: newsFeed[indexPath.row]["itemImage"] as! String)

                cell.img1.sd_setImageWithURL(url!)

            }
            else
            {
                cell.img1.image = nil
            }
            
            if (!(newsFeed[indexPath.row]["userName"]!!.isKindOfClass(NSNull)))
            {
                cell.VotName.text = (newsFeed[indexPath.row]["userName"] as! String)
            }
            //
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
            
            if (!(newsFeed[indexPath.row]["item_expiryDate"]!!.isKindOfClass(NSNull)))
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                print ("hello")
//                print(newsFeed[indexPath.row])
                
//                print(newsFeed[indexPath.row]["item_expiryDate"]!! as! String)
                
//                print(newsFeed[indexPath.row]["item_expiryDate"].intere)
                let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_expiryDate"] as! String)!
                //                            print(datesString)
                
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
                //                cell.expiryDate.text = dateFormatter.stringFromDate(datesString)
                cell.expiryDate.text = timeAgoSince(datesString)
            }
            
            if (!(newsFeed[indexPath.row]["itemDescription"]!!.isKindOfClass(NSNull)))
            {
                cell.textBox.text = newsFeed[indexPath.row]["itemDescription"] as! String
            }
            
            //            if (!(newsFeed[indexPath.row]["participants"]!!.isEqualToNumber(0)))
            //            {
            cell.totalNos.text = String(newsFeed[indexPath.row]["participants"]!!.integerValue)
            //            }
            
            return cell

        }
//            else
//        {
//            let cell = tableView.dequeueReusableCellWithIdentifier("PollShared") as! PollShared
//            return cell
//            
//        }
//        //Cards Type
//        else if (newsFeed[indexPath.row]["type"]!!.isEqualToString("card"))
//        {
//        
//        }
        
//        return result
        }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        print("\(newsFeed[indexPath.row]["userName"] as! String) pressed")
//    }
    
    //MARK:- UIScrollViewDelegates
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        if scrollView.panGestureRecognizer.translationInView(scrollView).y < 0
        {
            changeTabBar(true, animated: true)
        }
        else
        {
            changeTabBar(false, animated: true)
        }
    }

    
    //MARK:- Actions
    @IBAction func showLists(sender: AnyObject)
    {
        
    }
    
    @IBAction func notify(sender: AnyObject)
    {
//        performSegueWithIdentifier("showNotification", sender: sender)
        
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("notifications") as! NotificationsView
        self.presentViewController(view, animated: true, completion: nil)
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
//                    print(json)
                    
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
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/mobileNewsFeed"
        
//        let parameter = ["rowNumber": "1", "showingType": "all"]
        
//        Alamofire.request(.GET, URL, headers: header, parameters: parameter, encoding: .JSON)
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
