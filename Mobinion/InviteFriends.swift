//
//  InviteFriends.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class InviteFriends: UIViewController
{
    
    @IBOutlet weak var navTitle: UINavigationBar!
    
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
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("NewsFeed") as! NewsFeed
        self.presentViewController(view, animated: true, completion: nil)
    }
    
    @IBAction func skipBtn(sender: AnyObject)
    {
        performSegueWithIdentifier("inviteFriendsSegue", sender: sender)
    }
    
    
    @IBAction func shareButtonClicked(sender: UIButton)
    {
        let textToShare: String = "Welcome to MOBINION, a simple easy to use interface and convey messages"
        let myWebsite = NSURL(string: "http://www.mobinion.com")
        let objectsToShare = [textToShare, myWebsite!]
        let excludeActivity: [String] = [UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList]
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludeActivity
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
}

