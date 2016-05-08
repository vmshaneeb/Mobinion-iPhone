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
                    
                    do
                    {
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        self.fromContacts = responseObject["data"]!["fromContacts"]!!.mutableCopy() as! NSMutableArray
                        print (self.fromContacts)
                    }
                    catch
                    {
                        print("error in responseObject")
                    }
                    
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
//        return 1
//        return sections.count
        return allUsers.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        return contacts.count
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
        
        if header.containsString("suggestionsUsers")
        {
            cell.titleLabel.text = "Suggestions from your Interests"
        }
        else if header.containsString("fromContacts")
        {
            cell.titleLabel.text = "From your Contacts"
        }
        else
        {
            cell.titleLabel.text = ""
        }

        return cell
    }
    
//    func  table
    //-(UITableViewCell *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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
            cell.profileImage.sd_setImageWithURL(NSURL(string: (allUsers.objectForKey(Str)?.objectAtIndex(indexPath.row).objectForKey("profPic") as! String)))
        }
            
        cell.followBtn.tag = indexPath.row
        cell.followBtn.titleLabel?.tag = indexPath.section
        cell.followBtn.addTarget(self, action: #selector(followBTNAPI(_:)), forControlEvents: .TouchUpInside)
        
//              [allUsers.allKeys[indexPath.section].!)//("%@", )
//        cell.profileName.text = (allUsers[allUsers.allKeys[indexPath.section] as! String]![indexPath.row]!!["name"] as! String)
//        cell.profileProfession.text = (allUsers["suggestionsUsers"]![indexPath.row]!!["bio"] as! String)
//        cell.profileImage.sd_setImageWithURL(NSURL(string: allUsers["suggestionsUsers"]![indexPath.row]!["profPic"] as! String))
        
//        if (!(allUsers[indexPath.row]["name"]!!.isEqualToString("")))
//        {
//        if indexPath.section == all
//        {
//            cell.profileName.text = (allUsers["suggestionsUsers"]![indexPath.row]!!["name"] as! String)
////        }
//        
////        if (!(suggestionsUsers[indexPath.row]["bio"]!!.isEqualToString("")))
////        {
//            cell.profileProfession.text = (allUsers["suggestionsUsers"]![indexPath.row]!!["bio"] as! String)
////        }
//        
////        if (!(suggestionsUsers[indexPath.row]["profPic"]!!.isEqualToString("")))
////        {
//            cell.profileImage.sd_setImageWithURL(NSURL(string: allUsers["suggestionsUsers"]![indexPath.row]!["profPic"] as! String))
////        }
////        else
////        {
////            cell.profileImage.image = nil
////        }
//        }
//        else
//        {
////            if (!(fromContacts[indexPath.row]["name"]!!.isEqualToString("")))
//            //            {
//                            cell.profileName.text = (allUsers["fromContacts"][indexPath.row]["name"] as! String)
//            //            }
//            //
//            //            if (!(fromContacts[indexPath.row]["bio"]!!.isEqualToString("")))
//            //            {
//                            cell.profileProfession.text = (allUsers[indexPath.row]["bio"] as! String)
//            //            }
//            //
//            //            if (!(fromContacts[indexPath.row]["profPic"]!!.isEqualToString("")))
//            //            {
//                            cell.profileImage.sd_setImageWithURL(NSURL(string: allUsers[indexPath.row]["profPic"] as! String))
//            //            }
//            //            else
//            //            {
//            //                cell.profileImage.image = nil
//            //            }
//
//            
//        }
        
//        if (suggestionsUsers.count != 0)
//        {
//            if (!(suggestionsUsers[indexPath.row]["name"]!!.isEqualToString("")))
//            {
//                cell.profileName.text = (suggestionsUsers[indexPath.row]["name"] as! String)
//            }
//            
//            if (!(suggestionsUsers[indexPath.row]["bio"]!!.isEqualToString("")))
//            {
//                cell.profileProfession.text = (suggestionsUsers[indexPath.row]["bio"] as! String)
//            }
//            
//            if (!(suggestionsUsers[indexPath.row]["profPic"]!!.isEqualToString("")))
//            {
//                cell.profileImage.sd_setImageWithURL(NSURL(string: suggestionsUsers[indexPath.row]["profPic"] as! String))
//            }
//            else
//            {
//                cell.profileImage.image = nil
//            }
//        }
//        else if (fromContacts.count != 0)
//        {
//            if (!(fromContacts[indexPath.row]["name"]!!.isEqualToString("")))
//            {
//                cell.profileName.text = (fromContacts[indexPath.row]["name"] as! String)
//            }
//            
//            if (!(fromContacts[indexPath.row]["bio"]!!.isEqualToString("")))
//            {
//                cell.profileProfession.text = (fromContacts[indexPath.row]["bio"] as! String)
//            }
//            
//            if (!(fromContacts[indexPath.row]["profPic"]!!.isEqualToString("")))
//            {
//                cell.profileImage.sd_setImageWithURL(NSURL(string: fromContacts[indexPath.row]["profPic"] as! String))
//            }
//            else
//            {
//                cell.profileImage.image = nil
//            }
//        }
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
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseInterests") as! ChooseInterests
        self.presentViewController(view, animated: true, completion: nil)
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
    
    func followBTNAPI(sender: UIButton)
    {
//        print(sender.tag)
//        print(sender.titleLabel?.tag)
        
        let index = sender.tag
        let section = sender.titleLabel?.tag
        var id = ""
        var following = ""
        
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/followFriends"
        
        let Str = allUsers.allKeys[section!] as! String
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("name"))!.isKindOfClass(NSNull)))
        {
            id = (allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("id") as! String)
        }
        else
        {
            id = ""
        }
        
        if (!((allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("name"))!.isKindOfClass(NSNull)))
        {
            following = (allUsers.objectForKey(Str)?.objectAtIndex(index).objectForKey("isFollowing") as! String)
        }

        if following.containsString("false")
        {
            following = "true"
        }
        else
        {
            following = "false"
        }
        
        let parameter = ["followFriend": id,
                         "isFollowing": following]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
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
                        print(error)
                }
        }

//        allUsers
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

