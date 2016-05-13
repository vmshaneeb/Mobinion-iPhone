//
//  ChooseInterests.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cloudinary
import DBAlertController
import SDWebImage
import DZNEmptyDataSet

class ChooseInterests: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
{
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var searchHeaderImage: UIImageView!
    @IBOutlet weak var searchBarField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let isiPhone5orLower = UIScreen.mainScreen().bounds.size.width == 320
    let isiPhone6 = UIScreen.mainScreen().bounds.size.width == 375
    let isiPhone6plus = UIScreen.mainScreen().bounds.size.width == 414
    
    var imageURLs: [String: String] = [String: String]()
    var imageNames: [String] = [String]()
    var imageURL: [String] = [String]()
    var imageIDs: [String] = [String]()
    var selected = [String: String]()
    
    let reuseIdentifier = "Cell"
    
    var selectedPhotos = [String]()
    var deselectedPhotos = [String]()
    var searchedPhotos = [String]()
    var searchedURL = [String]()
    
    var reloaded:Bool = false
    
    let baseURL = "http://res.cloudinary.com/dscw6puvr/"
    let cloudinary = CLCloudinary(url: "cloudinary://661939659813751:CG78z-JdF6pUl7r6HYTBhbjpxJo@epi")
//    let ids = CLCloudinary
//    let pubid = CLCloudinary.randomPublicId("5706096b8b9fd2636717fa20")

    var sharing: Bool = true
    {
        didSet
        {
            collectionView.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            selectedPhotos.removeAll(keepCapacity: false)
            deselectedPhotos.removeAll(keepCapacity: false)
        }
    }

    var alamoFireManager = Alamofire.Manager.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30 // seconds
        configuration.timeoutIntervalForResource = 30
        
        alamoFireManager = Alamofire.Manager(configuration: configuration)
        
        [collectionView.registerClass(InterestsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")]
        let nib:UINib = UINib(nibName: "InterestsCollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "Cell")
        
        [collectionView.registerClass(InterestsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")]
        let nib2:UINib = UINib(nibName: "InterestsCollectionReusableView", bundle: nil)
        collectionView.registerNib(nib2, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.allowsMultipleSelection = true
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
//        print(self.imageURL.count)
//        print(self.imageURL)
        
        
        self.StartLoader()
        
        getinterestTopics()
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
//                        self.doDBalertView(titles, msgs: messages)
                        print("\(titles): \(messages)")
                    }
                    else
                    {
                        for i in 0 ..< json["data"]["interests"].count
                        {
                            if (!json["data"]["interests"][i]["imageUrl"].stringValue.isEmpty)
                            {
                                self.imageURL.append(json["data"]["interests"][i]["imageUrl"].stringValue)
                                self.imageNames.append(json["data"]["interests"][i]["title"].stringValue)
                                self.imageIDs.append(json["data"]["interests"][i]["id"].stringValue)
                                self.imageURLs.updateValue(json["data"]["interests"][i]["imageUrl"].stringValue,
                                                           forKey: json["data"]["interests"][i]["title"].stringValue)
                                self.selected.updateValue(json["data"]["interests"][i]["isSelected"].stringValue,
                                    forKey: json["data"]["interests"][i]["title"].stringValue)
                            }
                        }
                      
//                        print(self.imageURL)
                        self.collectionView.reloadData()
//                        self.collectionView.reloadEmptyDataSet()
                    }
                }
                else
                {
                    self.HideLoader()
                    print(error)
                    self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UICollectionView Delegates
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        print(imageURL.count)
//        self.StartLoader()
//        print(imageURL)
        return imageURL.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
//        self.HideLoader()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InterestsCollectionViewCell
        
        let url = NSURL(string: self.imageURL[indexPath.row])
//        print(url)
//        let data = NSData(contentsOfURL: url!)
//        let image = UIImage(data: data!)
        
        cell.viewWithTag(100)
//        cell.intImg.image = image
        cell.intImg.sd_setImageWithURL(url!)
        cell.intImg.clipsToBounds = true
        cell.intImg.layer.cornerRadius = 10.0
        
        cell.intLabel.text = self.imageNames[indexPath.row].capitalizedString
        
//        cell.in
//        print(selected)
        for (name, sel) in selected
        {
            if name == imageNames[indexPath.row]
            {
//                print(name)
//                print(sel.containsString("true"))
                if sel.containsString("true")
                {
                    cell.intSeleted.hidden = false
//                    cell.selected = true
                }
            }
        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)  as! InterestsCollectionViewCell
            if cell.selected == true
            {
                if cell.intSeleted.hidden == false
                {
                    cell.intSeleted.hidden = true
                }
                else
                {
                    cell.intSeleted.hidden = false
                    
                    let photo = imageNames[indexPath.row]
                    
                    selectedPhotos.append(photo)
                    
                    selectedPhotos = Array(Set(selectedPhotos))
                }
            }
        }
        print("selected \(selectedPhotos)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        if sharing
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)  as! InterestsCollectionViewCell
            if cell.selected == false
            {
                cell.intSeleted.hidden = true
                
                let photo = imageNames[indexPath.row]
                deselectedPhotos.removeAll(keepCapacity: false)
                deselectedPhotos.append(photo)
                deselectedPhotos = Array(Set(deselectedPhotos))
            }
          
            for photos in deselectedPhotos
            {
                if let index = selectedPhotos.indexOf(photos)
                {
                    selectedPhotos.removeAtIndex(index)
                }
            }
                       
//            print("deselected \(deselectedPhotos)")
            print("after deselection \(selectedPhotos)")
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if sharing
        {
            return true
        }
        return false
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let sample = UICollectionReusableView()
        switch kind
        {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! InterestsCollectionReusableView
                
                headerView.headerLabel.text = "CHOOSE TOPICS"
//                headerView.headerLabel.font = UIFont (name: "Helvetica Neue", size: 20.0)
                return headerView
                
            default:
                assert(false, "Unexpected data element")
                return sample
        }
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if isiPhone6
        {
            let sectionInsets = UIEdgeInsets(top: 10, left: 35, bottom: 0, right: 35)
            return sectionInsets
        }
        else if isiPhone6plus
        {
            let sectionInsets = UIEdgeInsets(top: 10, left: 45, bottom: 0, right: 45)
            return sectionInsets
        }
        else
        {
            let sectionInsets = UIEdgeInsets(top:3, left: 5, bottom: 0, right: 5)
            return sectionInsets
        }
    }

    //MARK:- UITextFieldDelegates
    func textFieldShouldClear(textField: UITextField) -> Bool
    {
//        searchBarField.resignFirstResponder()
//        self.view.endEditing(true)
        
        if imageNames.count != imageURLs.count
        {
            selectedPhotos.removeAll(keepCapacity: false)
            deselectedPhotos.removeAll(keepCapacity: false)
            imageNames.removeAll(keepCapacity: false)
            imageURL.removeAll(keepCapacity: false)
            
            for (name, url) in imageURLs
            {
                imageNames.append(name)
                imageURL.append(url)
            }
            
            StartLoader()
            collectionView.reloadData()
            HideLoader()
        }
        
        return true
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
        let str = "No interests found"
        let attrs = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 17)!]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
//    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool
//    {
//        if reloaded == false
//        {
//            return true
//        }
//        return false
//    }
    
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
    
    //MARK: - Custom Functions
    func getIndexPathForSelectedCell() -> NSIndexPath?
    {
        
        var indexPath:NSIndexPath?
        
        if collectionView.indexPathsForSelectedItems()!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems()![0]
        }
        return indexPath
    }
    
    func highlightCell(indexPath : NSIndexPath, flag: Bool)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        if flag
        {
            cell?.contentView.backgroundColor = UIColor.cyanColor()
        } else
        {
            cell?.contentView.backgroundColor = nil
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
    
    func getinterestTopics(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/interestTopics"
        
//        Alamofire.request(.POST, URL, headers: header, encoding: .JSON)
        self.alamoFireManager.request(.POST, URL, headers: header, encoding: .JSON)
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
    
    func setinterestTopics(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/addInterests"
        
        let parameter = ["interest": selectedPhotos]
        
        print(parameter)
        
        Alamofire.request(.POST, URL, parameters: parameter, headers: header, encoding: .JSON)
//        alamoFireManager.request(.POST, URL, parameters: ["interests": selectedPhotos], headers: header, encoding: .JSON)
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
    
    
    //MARK:- Unwind Segue
    @IBAction func unwindToInterests(segue: UIStoryboardSegue)
    {
        
    }
    
    //MARK: - Actions
    @IBAction func backButton(sender: AnyObject)
    {
        print("back button pressed!!!")
//        self.performSegueWithIdentifier("unwindToUpdate", sender: self)
        
        if (self.navigationController?.topViewController!.isKindOfClass(ViewController) != nil)
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("UpdateProfile") as! UpdateProfile
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func searchBtn(sender: AnyObject)
    {
//        print("pressed")
        if (!searchBarField.text!.isEmpty)
        {
//            print("inside")
            
            let searchstr = searchBarField.text?.capitalizedString
            
            let trimmedstr = searchstr?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            selectedPhotos.removeAll(keepCapacity: false)
            deselectedPhotos.removeAll(keepCapacity: false)
            searchedPhotos.removeAll(keepCapacity: false)
            searchedPhotos.append(trimmedstr!)
            searchedPhotos = Array(Set(searchedPhotos))
            
//            print(searchedPhotos)

            if (!imageNames.isEmpty)
            {
                let set = Set(searchedPhotos)
                let set2 = Set(imageNames)
//                
//                print(set)
//                print(set2)
                
                let finalset = set2.intersect(set)
                
//                print(Array(finalset))
                imageNames.removeAll(keepCapacity: false)
                imageURL.removeAll(keepCapacity: false)
                
                if (!finalset.isEmpty)
                {
                    imageNames = Array(finalset)
                    
                    for (name, url) in imageURLs
                    {
                        if name == imageNames[0]
                        {
                            imageURL.append(url)
                        }
                    }
                    
                    StartLoader()
                    collectionView.reloadData()
                    HideLoader()
                }
                else
                {
                    self.doalertView("error", msgs: "Searched interest not found!!!")
                }
           }
            else
            {
                self.doalertView("Error", msgs: "No interests to search for!!!!")
            }
        }
        else
        {
            self.doalertView("Error", msgs: "Pls enter some text in the searchbar!!!")
        }
        
    }

    @IBAction func addBtn(sender: AnyObject)
    {
        //print(selectedPhotos)
        if selectedPhotos.isEmpty
        {
            doalertView("No Interests Selected", msgs: "Pls select atleast one interest!!!")
        }
        else
        {
            self.StartLoader()
            setinterestTopics()
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
//                        let alertController = DBAlertController(title: titles.capitalizedString, message: messages.capitalizedString, preferredStyle: .Alert)
//                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:
//                        { action in
//                            switch action.style
//                            {
//                                case .Default:
                                    self.performSegueWithIdentifier("chooseInterestsSegue", sender: sender)
//                                default:
//                                    break
//                            }
//                        })
//                        
//                        alertController.addAction(defaultAction)
//                        alertController.show()
                    }
                }
                else
                {
                    self.HideLoader()
                    print(error)
//                    self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                    
                    let alertController = DBAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    
                    let skipAction = UIAlertAction(title: "Skip", style: .Cancel, handler:
                    { action in
                        switch action.style
                        {
                            case .Cancel:
                                let alertController = DBAlertController(title: "warning", message: "importing contacts will take some time....", preferredStyle: .Alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:
                                { action in
                                    
                                    switch action.style
                                    {
                                    case .Default:
                                        self.performSegueWithIdentifier("chooseInterestsSegue", sender: sender)
                                    default:
                                        break
                                    }
                                })
                                
//                                self.doDBalertView("warning", msgs: "importing contacts will take some time....")
                                alertController.addAction(defaultAction)
                                alertController.show()
                                
//                                self.performSegueWithIdentifier("chooseInterestsSegue", sender: sender)
                            default:
                                break
                        }
                    })
                    
                    alertController.addAction(defaultAction)
                    alertController.addAction(skipAction)
                    alertController.show()
                }
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

