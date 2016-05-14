//
//  FollowFriends.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Contacts
import Alamofire
import SwiftyJSON
import DBAlertController
import PhoneNumberKit
import DZNEmptyDataSet

class FollowFriends: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
{

    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!

    var contacts = [CNContact]()
    var nos = [String]()
    var userIDs = [String]()
    
    var suggestionsUsers = NSMutableArray()
    var fromContacts = NSMutableArray()
    var allUsers = NSMutableDictionary()
    
    var sections = [String]()
    
    let reuseIdentifier = "FollowCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sections = ["Suggestions Based On Your Interests",
                    "From Your Contacts"]
        
        [tableView.registerClass(FollowTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)]
        var nib:UINib = UINib(nibName: "FollowTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        nib = UINib(nibName: "FollowSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "FollowSectionHeader")
        
        self.StartLoader()
        self.getContacts()
        self.HideLoader()
        
        if !nos.isEmpty
        {
            nos.removeAll(keepCapacity: false)
        }
        
//        self.doDBalertView("warning", msgs: "importing contacts will take some time....")
        
        self.StartLoader()
        for contact in contacts
        {
            if (contact.isKeyAvailable(CNContactPhoneNumbersKey))
            {
                for phoneNumber:CNLabeledValue in contact.phoneNumbers
                {
                    let no = (phoneNumber.value as! CNPhoneNumber).valueForKey("digits") as! String
                    
//                    print(no)
                    do
                    {
                        let phoneNumber = try PhoneNumber(rawNumber: no)
                        nos.append(String(phoneNumber.nationalNumber))
                    }
                    catch //if no country code
                    {
                        nos.append(no)
                    }
                    
                }
            }
        }
        
        self.HideLoader()
        print(nos.count)
        
        self.StartLoader()
        
        getFriendLists()
        { value, data, error in
                
            if value != nil
            {
                let json = JSON(value!)
                print(json)
                
                self.HideLoader()
                
                let titles = json["status"].stringValue
                let messages = json["message"].stringValue
                
                if titles == "error"
                {
//                    self.doDBalertView(titles, msgs: messages)
                    print("\(titles): \(messages)")
                }
                else
                {
                    do
                    {
//                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
//                        self.suggestionsUsers = responseObject["data"]!["suggestionsUsers"]!!.mutableCopy() as! NSMutableArray
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                        self.allUsers = responseObject.objectForKey("data")?.mutableCopy() as! NSMutableDictionary
//                        print (self.suggestionsUsers)
                    }
                    catch
                    {
                        print("error in responseObject")
                    }
                    
//                    do
//                    {
//                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
//                        self.fromContacts = responseObject["data"]!["fromContacts"]!!.mutableCopy() as! NSMutableArray
//                        print (self.fromContacts)
//                    }
//                    catch
//                    {
//                        print("error in responseObject")
//                    }
                    
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 132
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return allUsers.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let Str:NSString = allUsers.allKeys[section] as! NSString
//        print(allUsers.objectForKey(Str)?.count)
        return (allUsers.objectForKey(Str)?.count)!
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
////        print(allUsers.allKeys[section] as! String)
//        
//        let header = allUsers.allKeys[section] as! String
//        
//        if header.containsString("suggestionsUsers")
//        {
//            return "Suggestions Based On your Interests"
//        }
//        else if header.containsString("fromContacts")
//        {
//            return "From your Contacts"
//        }
//        else
//        {
//            return ""
//        }
////        return (allUsers.allKeys[section] as! String)//sections[section]
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // Dequeue with the reuse identifier
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("FollowSectionHeader") as! FollowSectionHeader
        
        let header = allUsers.allKeys[section] as! String
        
        //TODO:- hide suggestion users header if empty
        if header.containsString("suggestionsUsers")
        {
            cell.titleLabel.text = "Suggestions Based On Your Interests"
            cell.followAllBtn.hidden = true
        }
        else if header.containsString("fromContacts")
        {
            cell.titleLabel.text = "From your Contacts"
            
            cell.followAllBtn.hidden = false
            cell.followAllBtn.tag = section
            //TODO:- check the erro for button tap
            cell.followAllBtn.addTarget(self, action: #selector(followAllBtnAPI(_:)), forControlEvents: .TouchUpInside)
        }
        else
        {
            cell.titleLabel.text = ""
        }

        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! FollowTableViewCell
        
//        print(allUsers.allKeys[indexPath.section])
        let Str = allUsers.allKeys[indexPath.section] as! String
        print(allUsers.objectForKey(Str) as! NSArray)
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("name"))!.isKindOfClass(NSNull)))
        {
            cell.profileName.text = (allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("name") as! String)
        }
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("bio"))!.isKindOfClass(NSNull)))
        {
            cell.profileProfession.text = (allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("bio") as! String)
        }
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("profPic"))!.isKindOfClass(NSNull)))
        {
            // for rounded profile pic
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
            cell.profileImage.clipsToBounds = true
            
            cell.profileImage.sd_setImageWithURL(NSURL(string: (allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("profPic") as! String)))
        }
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("isFollowing"))!.isKindOfClass(NSNull)))
        {
            if ((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("isFollowing"))! as! NSObject == true)
            {
                cell.followBtn.selected = true
            }
            else
            {
                cell.followBtn.selected = false
            }
        }
        
        cell.followBtn.tag = indexPath.row
        cell.followBtn.titleLabel?.tag = indexPath.section
        cell.followBtn.addTarget(self, action: #selector(followBtnAPI(_:)), forControlEvents: .TouchUpInside)
        
        if (indexPath.section == 1)
        {
            if (!((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("id"))!.isKindOfClass(NSNull)))
            {
                userIDs.append((allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("id") as! String))
            }
        }
//        else if (suggestionsUsers.count == 0 && fromContacts.count == 0)
//        {
////            let contact = contacts[indexPath.row] as CNContact
////
////            cell.profileName.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
////            cell.profileProfession.text = contact.jobTitle
////            
////            if contact.imageData != nil
////            {
////                cell.profileImage.image = UIImage(data: contact.imageData!)
////            }
////            else
////            {
////                cell.profileImage.image = nil
////            }
//        }
        return cell
    }
    
    //MARK:- DZNEmptyDataSetDelegate
    //    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    //    {
    //        let str = "Welcome"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let str = "No contacts found"
        let attrs = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 17)!]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    //        return UIImage(named: "taylor-swift")
    //    }
    
    //    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString!
    //    {
    //        let str = "Add Grokkleglob"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    //
    //
    //    func emptyDataSetDidTapButton(scrollView: UIScrollView!)
    //    {
    //        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
    //        ac.addAction(UIAlertAction(title: "Hurray", style: .Default, handler: nil))
    //        presentViewController(ac, animated: true, completion: nil)
    //    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
//        performSegueWithIdentifier("unwindToInterests", sender: sender)
//        if (self.navigationController?.topViewController!.isKindOfClass(ViewController) != nil)
//        {
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//        else
//        {
            let view = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseInterests") as! ChooseInterests
            self.presentViewController(view, animated: true, completion: nil)
//        }
    }
    
    
    @IBAction func skipBtn(sender: AnyObject)
    {
        performSegueWithIdentifier("followFriendsSegue", sender: sender)
    }
    
    //MARK:- Custom Functions
    func getContacts()
    {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined
        {
            store.requestAccessForEntityType(.Contacts, completionHandler:
            { (authorized: Bool, error: NSError?) -> Void in
                if authorized
                {
                    self.retrieveContactsWithStore(store)
                }
            })
        } else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized
        {
            self.retrieveContactsWithStore(store)
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore)
    {
        do
        {
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                               CNContactPhoneNumbersKey,
                               CNContactJobTitleKey,
                               CNContactImageDataKey]
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            do
            {
                try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock:
                { (let contact, let stop) -> Void in
                    self.contacts.append(contact)
                })
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
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
    
    func getFriendLists(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/followFriendList"
        
        let parameter = ["contacts": nos]
        
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
    
    func doFollowFriends(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/followFriends"
        
        let parameter = ["followFriend": "",
                         "isFollowing": ""]
        
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
    
    func followBtnAPI(sender: UIButton)
    {
//        print(sender.tag)
//        print(sender.titleLabel?.tag)

        let index = sender.tag
        let section = sender.titleLabel?.tag
        var id = ""
        var following:Int = 0
        var sendFollow = ""
        
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/followFriends"
        
        let Str = allUsers.allKeys[section!] as! String
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("id"))!.isKindOfClass(NSNull)))
        {
            id = (allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("id") as! String)
        }
        else
        {
            id = ""
        }
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("isFollowing"))!.isKindOfClass(NSNull)))
        {
//            following = (allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("isFollowing") as! String)
            following = (allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("isFollowing")) as! Int
            print(following)
        }

        if following == 0
        {
//            following = 1
            sendFollow = "true"
            sender.selected = !sender.selected
        }
        else
        {
//            following = 0
            sendFollow = "false"
            sender.selected = !sender.selected
        }
        
//        print(id)
//        print(sendFollow)
        
        let parameter = ["followFriend": id, //"5734c7b6ef00f3aa0c15de3f",
                         "isFollowing": sendFollow] //false]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
        .responseJSON { response in
        switch response.result
        {
            case .Success:
            if let value = response.result.value
            {
                let json = JSON(value)
                print(json)
                self.tableView.reloadData()
            }
            
            case .Failure(let error):
                print(error)
        }
        }

//        allUsers
    }
    
    func followAllBtnAPI(sender: UIButton)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/followAll"
        
        print(userIDs)
        let parameter = ["followUsers": userIDs]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
        .responseJSON { response in
            switch response.result
            {
                case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print(json)
                        
                        self.tableView.reloadData()
                    }
                    
                case .Failure(let error):
                    print(error)
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

