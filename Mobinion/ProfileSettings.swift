//
//  ProfileSettings.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/8/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class ProfileSettings: UIViewController
{
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
    @IBAction func privacyBtn(sender: AnyObject)
    {
        print("privacy")
    }

    @IBAction func notifyBtn(sender: AnyObject)
    {
        print("notify")
    }
    
    @IBAction func chngpassBtn(sender: AnyObject)
    {
        print("change pass")
    }
    
    @IBAction func deleBtn(sender: AnyObject)
    {
        print("delete")
    }
    
    @IBAction func restoreBtn(sender: AnyObject)
    {
        print("restore")
    }
    
}
