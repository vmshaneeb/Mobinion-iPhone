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

class FollowFriends: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!

    var contacts = [CNContact]()
    var nos = [String]()
    
    let reuseIdentifier = "FollowCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        [tableView.registerClass(FollowTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)]
        let nib:UINib = UINib(nibName: "FollowTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        self.StartLoader()
        self.getContacts()
        self.HideLoader()
        
        
        self.StartLoader()
        
        getFriendLists()
        { value, error in
                
            if value != nil
            {
                let json = JSON(value!)
                print(json)
                
                self.HideLoader()
                
                let titles = json["status"].stringValue
                let messages = json["message"].stringValue
                
                if titles == "error"
                {
                    self.doDBalertView(titles, msgs: messages)
                }
                else
                {
                    
                }
            }
            else
            {
                self.HideLoader()
                print(error)
                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
            }
        }

        
//        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
//        
//        var toks:String = "JWT "
//        
//        toks.appendContentsOf(tok as! String)
//        
//        let header = ["Authorization": toks ]
//        
//        let URL = "http://vyooha.cloudapp.net:1337/followFriendList"
//        
//        Alamofire.request(.POST, URL,headers: header ,encoding: .JSON)
//            .responseJSON { response in
//                switch response.result
//                {
//                    case .Success:
//                        if let value = response.result.value
//                        {
//                            let json = JSON(value)
//                            print(json)
//                            
//                            self.tableView.reloadData()
//                        }
//                    case .Failure(let error):
//                        print("Request Failed with Error!!! \(error)")
//                }
//        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 132

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return contacts.count
//        let count = contacts.count
//        
//        return (count == 0) ? 1: count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! FollowTableViewCell
//        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FollowTableViewCell
        
        let contact = contacts[indexPath.row] as CNContact
//        let formatter = CNContactFormatter()
        
        cell.profileName.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
        cell.profileProfession.text = contact.jobTitle
        
        if contact.imageData != nil
        {
            cell.profileImage.image = UIImage(data: contact.imageData!)
        }
        else
        {
            cell.profileImage.image = nil
        }
        
        return cell
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 132.0
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
//            let groups = try store.groupsMatchingPredicate(nil)
//            let predicate = CNContact.predicateForContactsInGroupWithIdentifier(groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                               CNContactPhoneNumbersKey,
                               CNContactJobTitleKey,
                               CNContactImageDataKey]
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            
//            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
            
//            self.contacts = contacts
            
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
//        catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
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
    
    func getFriendLists(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/followFriendList"
        
        Alamofire.request(.POST, URL, headers: header, encoding: .JSON)
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

