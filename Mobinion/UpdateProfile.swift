//
//  UpdateProfile.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import Cloudinary

class UpdateProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLUploaderDelegate
{
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var header3: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBio: UITextField!
    @IBOutlet weak var profileBrief: UITextField!
    
    @IBOutlet var allTextFields: [UITextField]!
    
    var profilePicURL = ""
    var uploadedURL = ""
    var profName = ""
    
    let cloudinary = CLCloudinary(url: "cloudinary://661939659813751:CG78z-JdF6pUl7r6HYTBhbjpxJo@epi")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        profileName.text = profName
        
        // for rounded profile pic
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        
        // for profile pic border
        profilePic.layer.borderWidth = 3.0
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: - Actions
    @IBAction func updateBtn (sender: AnyObject)
    {
        let uploader = CLUploader.init(self.cloudinary, delegate: self)
        
//        self.StartLoader()
        if (!profilePicURL.isEmpty)
        {
            self .performSelector(#selector(UpdateProfile.StartLoader), withObject: nil, afterDelay: 0.1)
            uploader.upload(self.profilePicURL, options: ["sync": true])
            self.HideLoader()
        }
        
        self.StartLoader()
        self.sendupdateProfile()
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
//                    let alertController = DBAlertController(title: titles.capitalizedString, message: messages.capitalizedString, preferredStyle: .Alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:
//                    { action in
//                        switch action.style
//                        {
//                            case .Default:
                                self.performSegueWithIdentifier("updateProfileSegue", sender: sender)
//                            default:
//                                break
//                        }
//                    })
//                    
//                    alertController.addAction(defaultAction)
//                    alertController.show()
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
    
    @IBAction func selectImage(sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func skipButton(sender: AnyObject)
    {
        performSegueWithIdentifier("updateProfileSegue", sender: sender)
    }
    
    //MARK: - Overrides
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    
    //MARK: - UIImagePickerControllerDelegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // get image path
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = (imageURL.path! as NSString).lastPathComponent //get file name
//        let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imageName)
        
//        print(imageURL)
//        print(imageName)
//        print(localPath)
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path = (path as NSString).stringByAppendingPathComponent(imageName)
        
        let result = selectedImage.writeAtPath(path)
        print(result)
        
//        profilePicURL = localPath.absoluteString
        profilePicURL = String(path)
        
        print(profilePicURL)
        
        // for rounded profile pic
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        
        // for profile pic border
        profilePic.layer.borderWidth = 3.0
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        
//        print(profilePic.image?.size.height)
//        print(profilePic.image?.size.width)
        
//        profilePic.contentMode = .ScaleAspectFill
        
        profilePic.image = selectedImage        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Unwind Segue
    @IBAction func unwindToVC(segue: UIStoryboardSegue)
    {
        print("now in update screen!!!")
//        self.navigationController?.popToRootViewControllerAnimated(true)
//        if !segue.sourceViewController.isBeingDismissed()
//        {
//            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- CLUploaderDelegate
    func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!)
    {
        let publicID = JSON(result)
        
        print("Upload Sucess.. Public ID=\(publicID["public_id"])")
        print("Full result=\(result)")
        
        uploadedURL = publicID["url"].stringValue
        print(uploadedURL)
        
    }
    
    func uploaderError(result: String!, code: Int, context: AnyObject!)
    {
        print("Upload error: \(result), Code: \(code)")
    }
    
    func uploaderProgress(bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, context: AnyObject!)
    {
        print("Upload progress: \(totalBytesWritten)/\(totalBytesExpectedToWrite), +(\(bytesWritten))")
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
    
    func sendupdateProfile(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
      let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/updateProfile"
        
//        print(uploadedURL)

            
        Alamofire.request(.POST, URL, parameters: ["profilePic": uploadedURL,
                                                   "userBio": profileBio.text!,
                                                   "aboutUser": profileBrief.text!],
                          headers: header, encoding: .JSON)
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

