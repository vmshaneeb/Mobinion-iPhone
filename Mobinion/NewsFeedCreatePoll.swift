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

class NewsFeedCreatePoll: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ImagePickerDelegate
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
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var snapView: UIView!
    @IBOutlet weak var chooseView: UIView!
    
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textFieldTopSpacetoTableView: NSLayoutConstraint!
    
    var imageNames = [String]()
    var rowCount = 3
    
    var cellImgPicker:Bool!
    
    struct imagesCell
    {
        //        var indexP: Int?
        var image: UIImage?
    }
    
//    var imagesInCell = [imagesCell]()
    var imagesInCell = [Int: UIImage]()
    
    var lastSelectedIndex: NSIndexPath?

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
    
//    override func viewDidLayoutSubviews()
//    {
//        super.viewDidLayoutSubviews()
//        
//        let ht = CGFloat(1200) + tableViewHeightConst.constant
//        
//        print(scrollView.contentSize)
////        scrollView.setNeedsLayout()
////        scrollView.layoutIfNeeded()
//        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
//    }
    
    //MARK:- UITableViewDataSources
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //TODO:- fix issue when displaying the tableview initially
        if optionsType.selectedItem == nil
        {
            return 0
        }
        else
        {
            return rowCount
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
//        print("Options:- \(optionsType.selectedItem)")
//        if optionsType.selectedItem == nil || optionsType.selectedItem == "Text Options"
        if optionsType.selectedItem == "Text Options"
        {
            let nib:UINib = UINib(nibName: "CreatePollTableViewCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "CreatePollTableViewCell")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CreatePollTableViewCell", forIndexPath: indexPath) as! CreatePollTableViewCell
//            tableView.rowHeight = 54
            
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            cell.count.text = formatter.stringFromNumber(indexPath.row + 1)
            cell.count.text = cell.count.text! + "."
            
            return cell
        }
        else
        {
            let nib:UINib = UINib(nibName: "CreatePollPicOptionCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "CreatePollPicOptionCell")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CreatePollPicOptionCell", forIndexPath: indexPath) as! CreatePollPicOptionCell
//            tableView.rowHeight = 180
            
            cell.delegate = self
            
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            cell.countField.text = formatter.stringFromNumber(indexPath.row + 1)
            cell.countField.text = cell.countField.text! + "."
            
            
            if imagesInCell.indexForKey(indexPath.row) != nil
            {
                cell.imagePlaceHolderImageView.image = imagesInCell[indexPath.row]
            }
            
            return cell
        }
    }
    
    //MARK:- UITableViewDelegates
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {        
        let nib:UINib = UINib(nibName: "CreatePollTableViewFooterView", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CreatePollTableViewFooterView")
        
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CreatePollTableViewFooterView") as! CreatePollTableViewFooterView
        
        cell.addBtn.addTarget(self, action: #selector(addBtnResponder(_:)), forControlEvents: .TouchUpInside)
        cell.minusBtn.addTarget(self, action: #selector(minusBtnResponder(_:)), forControlEvents: .TouchUpInside)
//        cell.
        
//        if rowCount == 1
//        {
//            cell.minusBtn.enabled = false
//            cell.minusBtn.userInteractionEnabled = false
//            cell.minusBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.grayColor()), forState: .Normal)
//        }
//        else
//        {
//            cell.minusBtn.enabled = true
//            cell.minusBtn.userInteractionEnabled = false
////            cell.minusBtn.se
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        lastSelectedIndex = indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if optionsType.selectedItem == nil || optionsType.selectedItem == "Text Options"
        {
            return 54
        }
        else
        {
            return 180
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
//        return UITableViewAutomaticDimension
        if optionsType.selectedItem == nil || optionsType.selectedItem == "Text Options"
        {
            return 54
        }
        else
        {
            return 180
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 54
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        return 54
    }
    
    //MARK:- UIScrollViewDelegates
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let ht = CGFloat(1200) + tableViewHeightConst.constant
        
//        print(scrollView.contentSize)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
    }
    
    //MARK: - UIImagePickerControllerDelegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
////         get image path
//        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
//        let imageName = (imageURL.path! as NSString).lastPathComponent //get file name
        //        let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imageName)
        
        //        print(imageURL)
        //        print(imageName)
        //        print(localPath)
        
//        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        path = (path as NSString).stringByAppendingPathComponent(imageName)
//        
//        let result = selectedImage.writeAtPath(path)
//        print(result)
        print(cellImgPicker)
        print(placeholderImageView.image)
        print(selectedImage)
        if (cellImgPicker == true || placeholderImageView.image != nil)
        {
            cellImgPicker = false
//            imagesInCell[(lastSelectedIndex?.row)!].image = selectedImage
            imagesInCell.updateValue(selectedImage, forKey: lastSelectedIndex!.row)
            tableView.reloadData()
        }
        else
        {
            placeholderImageView.image = selectedImage
            stackView.hidden = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UITextFieldDelegates
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == optionsType
        {
            rowCount = 3
            
            if optionsType.selectedItem == "Text Options"// || optionsType.selectedItem == nil
            {
                tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
            }
            else
            {
                tableViewHeightConst.constant = (CGFloat(rowCount) * 180) + 54
            }
            
            tableView.reloadData()
        }
    }
    
    
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
    @IBAction func tapSnapView(sender: UITapGestureRecognizer)
    {
//        print("snap view tapped!!")
        self.view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .Camera
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    @IBAction func tapChooseView(sender: UITapGestureRecognizer)
    {
//        print("choose view tapped!!")
        self.view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    
    @IBAction func delImageBtn(sender: UIButton)
    {
        placeholderImageView.image = nil
        
        stackView.hidden = false
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
        
        if optionsType.selectedItem == "Text Options"// || optionsType.selectedItem == nil
        {
            tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
        }
        else
        {
            tableViewHeightConst.constant = (CGFloat(rowCount) * 180) + 54
        }
//        print(tableViewHeightConst.constant)
        tableView.reloadData()
    }
    
    func minusBtnResponder(sender: UIButton)
    {
        //        print("minus button pressed!!")
        if rowCount > 1
        {
            rowCount -= 1

//            tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
            if optionsType.selectedItem == "Text Options"// || optionsType.selectedItem == nil
            {
                tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
            }
            else
            {
                tableViewHeightConst.constant = (CGFloat(rowCount) * 180) + 54
            }
//            print(tableViewHeightConst.constant)
            //        tableView.layoutIfNeeded()
            tableView.reloadData()
        }
    }

    func delBtninCellResponder(sender: UIButton)
    {
        
    }
    
    func tapSnapViewinCell(cell: CreatePollPicOptionCell)//(sender: UIButton)
    {
        cellImgPicker = true
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .Camera
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func tapChooseViewinCell(cell: CreatePollPicOptionCell)//(sender: UIButton)
    {
        cellImgPicker = true
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
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


