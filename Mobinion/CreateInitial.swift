//
//  CreateInitial.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Async

class CreateInitial: UIViewController
{
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var header3: UILabel!
    @IBOutlet weak var header4: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("token"))
        if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
        {
            let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
            print(toks)
            if !(toks.isEmpty)
            {
                Async.main
                {
                    self.performSegueWithIdentifier("showNewsFeedFromInitial", sender: self)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
