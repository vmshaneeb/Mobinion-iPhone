//
//  NewsFeed.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class NewsFeed: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate
{

    @IBOutlet weak var navTitle: UINavigationBar!
    
    @IBOutlet weak var nearbyFeed: UITabBarItem!
    @IBOutlet weak var scanBarcode: UITabBarItem!
    @IBOutlet weak var myWall: UITabBarItem!
    @IBOutlet weak var create_Poll: UITabBarItem!
    @IBOutlet weak var viewProfile: UITabBarItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var array = [String]()
    
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        array = ["hello"]
        
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

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITabBarDelegates
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
    {
        switch item.tag
        {
            //Nearby
            case 1:
                print("Nearby pressed")
                donearby()
            //Barcode
            case 2:
                print("Barcode pressed")
//                doQR()
            //My wall
            case 3:
                print("My wall pressed")
//                domyWall()
            //Create Poll
            case 4:
                print("Create Poll pressed")
//                createPoll()
            //My profile
            case 5:
                print("My profile pressed")
            default:
                break
        }
    }
    
    //MARK:UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell :UITableViewCell!

        switch indexPath.row
        {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("Polls") as! NewsFeedTableViewCell
                
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("Voting") as! NewsFeedTableViewCell2
                
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("ChooseTopics") as! NewsFeedTableViewCell3
                
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier("Follow") as! NewsFeedTableViewCell4
                
            case 4:
                cell = tableView.dequeueReusableCellWithIdentifier("Shared") as! NewsFeedTableViewCell5
                
            case 5:
                cell = tableView.dequeueReusableCellWithIdentifier("Winner") as! NewsFeedTableViewCell6
                
            default:
                break
        }
        
        return cell
    }
    
    //MARK:- CLLocationManagerDelegates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0]
        
        lat = String(userLocation.coordinate.latitude)
        long = String(userLocation.coordinate.longitude)
        
//        print(lat)
//        print(long)
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
    
    //MARK: Custom functions
    func donearby ()
    {
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/aroundme"
        
        Alamofire.request(.GET, URL,headers: header, parameters: ["lat": lat, "lon": long], encoding: .JSON)
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
    
    func doQR()
    {
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/itemDetails"
        
        Alamofire.request(.GET, URL,headers: header, parameters: ["qr": ""], encoding: .JSON)
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
    
    func createPoll()
    {
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/createPoll"
        
        let parameter = ["category": "",
                         "questions": "",
                         "description": "",
                         "pollImage": "",
                         "pollType": "",
                         "regionalRes": "",
                         "expDate": "",
                         "Tags": ""]
        
        Alamofire.request(.GET, URL,headers: header, parameters: parameter, encoding: .JSON)
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
    
    func domyWall()
    {
//        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7ImlkIjoiNTcxNjdmZjM0ZWM4MDNlZGU0MjlhYzg0IiwibW9iaWxlIjoiOTAzNzQyNDI0MyIsInVzZXJUeXBlIjoiY3VzdG9tZXIifSwiaWF0IjoxNDYxMDkyMzM5LCJleHAiOjE0OTI2MjgzMzksImF1ZCI6Im1vYmluaW9uLmNvbSIsImlzcyI6Im1vYmlvbmlvbi5jb20ifQ.EZqW-ZVydbxxCMOm7OX0jRANbpM7sxSI5KgR_Hks00I"
        
//        toks.appendContentsOf(tok as! String)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/mobileNewsFeed"
        
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
}

