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
import Cloudinary

class NewsFeedCreatePoll: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ImagePickerDelegate, CLUploaderDelegate
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
    
    var cellImgPicker: Bool!
    
    let isiPhone5orLower = UIScreen.mainScreen().bounds.size.width == 320
    let isiPhone6 = UIScreen.mainScreen().bounds.size.width == 375
    let isiPhone6Plus = UIScreen.mainScreen().bounds.size.width == 414
    
//    struct imagesCell
//    {
//        //        var indexP: Int?
//        var image: UIImage?
//    }
//    
////    var imagesInCell = [imagesCell]()
    var imagesInCell = [Int: UIImage]()
    var URLsInCell = [Int: String]()
    var uploadURLsInCell = [String]()
    var pollImageURL = ""
    var pollImageUploadURL = ""
    var pollImageUploaded: Bool!
    
    var lastSelectedIndex: NSIndexPath?

    let cloudinary = CLCloudinary(url: "cloudinary://661939659813751:CG78z-JdF6pUl7r6HYTBhbjpxJo@epi")
    
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
        
        let df = NSDateFormatter()
        
        df.dateFormat = "dd-MMM-yyyy"
        expiryDate.dateFormatter = df
        expiryDate.setSelectedItem(df.stringFromDate(NSDate()), animated: true)
        
        getIntTopics()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 54
        

        let ht = CGFloat(1200) + tableViewHeightConst.constant
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
        
        if optionsType.selectedItem == "Text Options" || optionsType.selectedItem == nil
        {
            tableViewHeightConst.constant = (CGFloat(rowCount) * 54) + 54
        }
        else
        {
            tableViewHeightConst.constant = (CGFloat(rowCount) * 180) + 54
        }
        
//        placeholderImageView.image = nil
        pollImageUploaded = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        print("Options:- \(optionsType.selectedItem)")
        if optionsType.selectedItem == nil || optionsType.selectedItem == "Text Options"
//        if optionsType.selectedItem == "Text Options"
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
                cell.stackView.hidden = true
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
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        lastSelectedIndex = indexPath
//    }
    
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
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
       
//        print(scrollView.contentSize)
    }
    
    //MARK: - UIImagePickerControllerDelegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if ((cellImgPicker) != false)// || placeholderImageView.image != nil)
        {
//            print(lastSelectedIndex)
            cellImgPicker = false
            imagesInCell.updateValue(selectedImage, forKey: lastSelectedIndex!.row)
//            print(imagesInCell)

            var imageName:String = String(lastSelectedIndex!.row)
            imageName.appendContentsOf(".JPG")
//            print(imageName)
            
            var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            path = (path as NSString).stringByAppendingPathComponent(imageName)
            URLsInCell.updateValue(path, forKey: lastSelectedIndex!.row)
//            print(URLsInCell)
            let result = selectedImage.writeAtPath(path)
            print("File write status:- \(result)")
            
            tableView.reloadData()
        }
        else
        {
            placeholderImageView.image = selectedImage
            stackView.hidden = true
            
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let imageName = (imageURL.path! as NSString).lastPathComponent //get file name
            var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            path = (path as NSString).stringByAppendingPathComponent(imageName)
            
            let result = selectedImage.writeAtPath(path)
            print("File write status:- \(result)")
            
            pollImageURL = path
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
    
    //MARK:- CLUploaderDelegate
    func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!)
    {
        let publicID = JSON(result)
        
        print("Upload Sucess.. Public ID=\(publicID["public_id"])")
        print("Full result=\(result)")
        
        var imageName = ""
        
//        print(publicID["original_filename"].stringValue)
//        print(pollImageUploaded)
        
        if (!pollImageURL.isEmpty && pollImageUploaded == false)
        {
//            let imageURL = NSURL(string: pollImageURL)
//            print(imageURL)
//            
//            imageName = ((imageURL?.path!)! as NSString).lastPathComponent
//            imageName = imageName.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString:".JPG"))
//            print(imageName)
            
            imageName = pollImageURL.lastPathComponent.stringByDeletingPathExtension
//            print(imageName)
        }
        
        if (publicID["original_filename"].stringValue == imageName && pollImageUploaded == false)
        {
            pollImageUploadURL = publicID["url"].stringValue
            pollImageUploaded = true
            print("Poll Image:-\(pollImageUploadURL)")
        }
        else
        {
            uploadURLsInCell.append(publicID["url"].stringValue)
            print("Cell Images:-\(uploadURLsInCell)")
        }
    }
    
    func uploaderError(result: String!, code: Int, context: AnyObject!)
    {
        print("Upload error: \(result), Code: \(code)")
    }
    
    func uploaderProgress(bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, context: AnyObject!)
    {
        print("Upload progress: \(totalBytesWritten)/\(totalBytesExpectedToWrite), +(\(bytesWritten))")
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
        let uploader = CLUploader.init(self.cloudinary, delegate: self)
        
//        performSelector(#selector(StartLoader), withObject: nil, afterDelay: 0.1)
        
        if !(pollImageURL.isEmpty)
        {
            uploader.upload(pollImageURL, options: ["sync": true])
        }
        
        if !(URLsInCell.isEmpty)
        {
            for url in URLsInCell.values
            {
//                print(url)
                uploader.upload(url, options: ["sync": true])
            }
        }
        
        
        
//        HideLoader()
        
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
        
        cellImgPicker = false
        
        placeholderImageView.image = nil
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .Camera
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    @IBAction func tapChooseView(sender: UITapGestureRecognizer)
    {
//        print("choose view tapped!!")
        self.view.endEditing(true)
        
        cellImgPicker = false
        
        placeholderImageView.image = nil
        
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
        
        if optionsType.selectedItem == "Text Options" || optionsType.selectedItem == nil
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
            if optionsType.selectedItem == "Text Options" || optionsType.selectedItem == nil
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
        
        lastSelectedIndex = tableView.indexPathForCell(cell)
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .Camera
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func tapChooseViewinCell(cell: CreatePollPicOptionCell)//(sender: UIButton)
    {
        cellImgPicker = true
        
//        cell.
        lastSelectedIndex = tableView.indexPathForCell(cell)
//        print(lastSelectedIndex)
        
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


