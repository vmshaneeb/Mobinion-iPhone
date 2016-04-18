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

class NewsFeed: UIViewController, UITabBarDelegate
{

    @IBOutlet weak var navTitle: UINavigationBar!
    
    @IBOutlet weak var nearbyFeed: UITabBarItem!
    @IBOutlet weak var scanBarcode: UITabBarItem!
    @IBOutlet weak var myWall: UITabBarItem!
    @IBOutlet weak var create_Poll: UITabBarItem!
    @IBOutlet weak var viewProfile: UITabBarItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITabBarDelegates
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
    {
        
    }
    
    //MARK:- Actions
    @IBAction func showLists(sender: AnyObject)
    {
        
    }
    
    @IBAction func notify(sender: AnyObject)
    {
        
    }
    
    @IBAction func search(sender: AnyObject)
    {
        
    }
    
}

