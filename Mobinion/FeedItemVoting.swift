//
//  FeedItemVoting.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/31/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import SDWebImage

class FeedItemVoting: UIViewController
{
    @IBOutlet weak var votingImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var profImg: UIImageView!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var expiry: UILabel!
    @IBOutlet weak var voteQuestn: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var votingImageHt: NSLayoutConstraint!
    @IBOutlet weak var tableViewHt: NSLayoutConstraint!
    
    var itemID = ""
    var feedID = ""
    var itemType = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(itemType)
        if itemType == "mark"
        {
            print(submitBtn.titleLabel?.text)
            submitBtn.titleLabel?.text = "SUBMIT YOUR MARKS"
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        //        self.tabBarController?.selectedIndex = 2
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitBtnAction(sender: AnyObject)
    {
        
    }
}

