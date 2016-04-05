//
//  NewsFeed.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NewsFeed: UIViewController
{
    @IBOutlet weak var showLists: UIBarButtonItem!
    @IBOutlet weak var navTitle: UINavigationBar!
    @IBOutlet weak var notify: UIBarButtonItem!
    @IBOutlet weak var search: UIBarButtonItem!
    
    @IBOutlet weak var nearbyFeed: UITabBar!
    @IBOutlet weak var scanBarcode: UITabBar!
    @IBOutlet weak var myWall: UITabBar!
    @IBOutlet weak var create_Poll: UITabBar!
    @IBOutlet weak var viewProfile: UITabBar!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

