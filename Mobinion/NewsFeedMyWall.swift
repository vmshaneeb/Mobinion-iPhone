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

class NewsFeedMyWall: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var newsFeed:NSMutableArray=NSMutableArray()
//    var newsFeed = [String: String]()
    
    var jsondata:JSON = [:]
    
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
//        array = ["hello"]
//        jsondata = ""
        
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
                //                            print(newsFeed[indexPath.row]["item_createdDate"].stringValue)
                
                let datesString:NSDate = dateFormatter.dateFromString(newsFeed[indexPath.row]["item_createdDate"] as! String)!
                //                            print(datesString)
                
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
                cell.pollCreated.text = dateFormatter.stringFromDate(datesString)
            }
            //
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
                
                cell.voCreated.text = dateFormatter.stringFromDate(datesString)
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
    func domyWall()
    {
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
        //        print(toks)
        
        let header = ["Authorization": toks ]
        
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
//                        print(json)
                        self.jsondata = json
//                        let dict:NSMutableDictionary = self.jsondata as! NSMutableDictionary
                        
//                        if let data = response.data
//                        {
//                            do {
//                                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
//                            } catch let error as NSError {
//                                print(error)
//                            }
//                        }
//                        
                        
                        do {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! [String:AnyObject]
                            self.newsFeed = responseObject["data"]!["newsFeed"]!!.mutableCopy() as! NSMutableArray
//                            print (self.newsFeed)
                        }
                        catch let error as NSError
                        {
                            print("error: \(error.localizedDescription)")
                        }
                        
//                        for i in 0 ..<  json["data"]["newsFeed"].count
//                        {
//                            if (!json["data"]["newsFeed"][i].isEmpty)
//                            {
//                                self.newsFeed.append(json["data"]["newsFeed"][i].stringValue)
//                            }
//                            self.newsFeed =  json["data"]["newsFeed"] as! NSMutableArray
                        
//                        }
                        
//                        print(self.jsondata)
                        
                        self.tableView.reloadData()
                        self.HideLoader()
                    }
                case .Failure(let error):
                    print("Request Failed with Error!!! \(error)")
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
