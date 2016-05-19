//
//  NewsFeedCreatePoll.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/21/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import IQDropDownTextField

class NewsFeedCreatePoll: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var choose_cat: IQDropDownTextField!
    @IBOutlet weak var quest_textView: UITextView!
    @IBOutlet weak var desc_Field: UITextField!
    @IBOutlet weak var optionsType: IQDropDownTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var speical_textView: UITextView!
    @IBOutlet weak var expiryDate: IQDropDownTextField!
    @IBOutlet weak var tagstextView: UITextView!
    @IBOutlet weak var charsRemaining: UILabel!
    
    @IBOutlet weak var imagePlaceholderView: UIView!
    @IBOutlet weak var snapView: UIView!
    @IBOutlet weak var chooseView: UIView!
    
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textFieldTopSpacetoTableView: NSLayoutConstraint!
    
    var imageNames = [String]()
    var rowCount = 3

    override func viewDidAppear(animated: Bool) 
//    override func viewDidLoad()
    {
//        super.viewDidLoad()
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(CreatePollTableViewCell.self, forCellReuseIdentifier: "CreatePollTableViewCell")
        var nib:UINib = UINib(nibName: "CreatePollTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CreatePollTableViewCell")
        
        tableView.registerClass(CreatePollTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: "CreatePollTableViewFooterView")
        nib = UINib(nibName: "CreatePollTableViewFooterView", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CreatePollTableViewFooterView")
        
        //CreatePollTableViewFooterView
//        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1200)
        
        choose_cat.isOptionalDropDown = false
        
        optionsType.isOptionalDropDown = false
        optionsType.itemList = ["Text Options",
                                "Image Options"]
        
        expiryDate.isOptionalDropDown = false
        expiryDate.dropDownMode = IQDropDownMode.DatePicker
        
        getIntTopics()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 54

        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        let ht = CGFloat(1200) + tableViewHeightConst.constant
        
//        print(scrollView.contentSize)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
    }
    
    //MARK:- UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let nib:UINib = UINib(nibName: "CreatePollTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CreatePollTableViewCell")

        let cell = tableView.dequeueReusableCellWithIdentifier("CreatePollTableViewCell", forIndexPath: indexPath) as! CreatePollTableViewCell
        
        
        
        return cell
    }
    
    //MARK:- UITableViewDelegates
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {        
        let nib:UINib = UINib(nibName: "CreatePollTableViewFooterView", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CreatePollTableViewFooterView")
        
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CreatePollTableViewFooterView") as! CreatePollTableViewFooterView
        
        cell.addBtn.addTarget(self, action: #selector(addBtnResponder(_:)), forControlEvents: .TouchUpInside)
        cell.minusBtn.addTarget(self, action: #selector(minusBtnResponder(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
//    //MARK:- UIScrollViewDelegates
//    func scrollViewWillBeginDragging(scrollView: UIScrollView)
//    {
//        
//    }
    
    //MARK:- Actions
    @IBAction func checkBox(sender: UIButton)
    {
        sender.selected = !sender.selected
    }
    
    @IBAction func notifyBtn(sender: AnyObject)
    {
        performSegueWithIdentifier("showNotificationFromCreate", sender: sender)
    }
    
    @IBAction func createPoll(sender: AnyObject)
    {
        //        StartLoader()
        
        //        sendCreatePoll()
        //        { value, error in
        //
        //            if value != nil
        //            {
        //                let json = JSON(value!)
        //                print(json)
        //
        //                self.HideLoader()
        //
        //                let titles = json["status"].stringValue
        //                let messages = json["message"].stringValue
        //
        //                if titles == "error"
        //                {
        //                    self.doDBalertView(titles, msgs: messages)
        //                }
        //                else
        //                {
        //
        //                }
        //            }
        //            else
        //            {
        //                self.HideLoader()
        //                print(error)
        //                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
        //            }
        //        }
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
    
    func getinterestTopics(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/interestTopics"
        
        Alamofire.request(.POST, URL, headers: header, encoding: .JSON)
//        self.alamoFireManager.request(.POST, URL, headers: header, encoding: .JSON)
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
    
    func sendCreatePoll(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/createPoll"
        
        let parameter = ["category": "",
                         "questions": "",
                         "description": "",
                         "pollImage": "",
                         "pollType": "",
                         "regionalRes": "",
                         "expDate": "",
                         "Tags": ""]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
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
    
    func getIntTopics()
    {
        getinterestTopics()
        { value, error in
                
            if value != nil
            {
                let json = JSON(value!)
                //                    print(json)
                let titles = json["status"].stringValue
                let messages = json["message"].stringValue
                
                if titles == "error"
                {
                    print("\(titles): \(messages)")
                }
                else
                {
                    for i in 0 ..< json["data"]["interests"].count
                    {
                        if (!json["data"]["interests"][i]["imageUrl"].stringValue.isEmpty)
                        {
                            self.imageNames.append(json["data"]["interests"][i]["title"].stringValue)
                            
                            self.choose_cat.itemList = self.imageNames
                        }
                    }
                    //                        print(self.imageURL)
                }
            }
            else
            {
                print(error)
            }
        }
    }
    
    func addBtnResponder(sender: UIButton)
    {
//        print("add button pressed!!")
        rowCount += 1
        
        tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
        tableView.reloadData()
    }
    
    func minusBtnResponder(sender: UIButton)
    {
        //        print("minus button pressed!!")
        rowCount -= 1
        
        //TODO:- check scroll size when deleting rows
        tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
        tableView.reloadData()
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


