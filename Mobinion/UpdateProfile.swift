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

class UpdateProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
//    @IBOutlet weak var skipBtn: UIBarButtonItem!
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var header3: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBio: UITextField!
    @IBOutlet weak var profileBrief: UITextField!
    
    @IBOutlet var allTextFields: [UITextField]!
    
    var profilePicURL = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    //MARK: - UITextFieldDelegates
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
//    {
//        // Create a button bar for the number pad
//        let keyboardDoneButtonView = UIToolbar()
//        keyboardDoneButtonView.sizeToFit()
//        
//        // Setup the buttons to be put in the system.
//        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(UpdateProfile.doneButton))
//        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
//        
//        let toolbarButtons = [flexibleSpaceButton, doneButton]
//        
//        //Put the buttons into the ToolBar and display the tool bar
//        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
//        textField.inputAccessoryView = keyboardDoneButtonView
//        
//        return true
//    }
    
//    func doneButton()
//    {
//        self.view.endEditing(true)
//    }
    
//    func textFieldDidBeginEditing(textField: UITextField)
//    {
//        animateViewMoving(true, moveValue: 150)
//    }
//    func textFieldDidEndEditing(textField: UITextField)
//    {
//        animateViewMoving(false, moveValue: 150)
//    }

    
//    func textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        self.view.endEditing(true)
//        
//        //        if let nextTag = nextField[textField.tag]
//        //        {
//        //            if let nextResponder = textField.superview!.viewWithTag(nextTag)
//        //            {
//        //                // Have the next field become the first responder
//        //                nextResponder.becomeFirstResponder()
//        //            }
//        //        }
//        
//        return false
//    }
    
//    //move keyboard to show textfields
//    func animateViewMoving (up:Bool, moveValue :CGFloat)
//    {
//        let movementDuration:NSTimeInterval = 0.3
//        let movement:CGFloat = ( up ? -moveValue : moveValue)
//        UIView.beginAnimations( "animateView", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(movementDuration )
//        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
//        UIView.commitAnimations()
//    }
    
    //MARK: - Actions
    @IBAction func updateBtn (sender: AnyObject)
    {
        self.StartLoader()
        
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
//        print(toks)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/updateProfile"
        
        Alamofire.request(.POST, URL, parameters: ["profilePic": profilePicURL,
                                                   "userBio": profileBio.text!,
                                                   "aboutUser": profileBrief.text!],
            headers: header ,encoding: .JSON)
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
                    print("Request Failed with Error!!! \(error)")
                }
        }
        
        performSegueWithIdentifier("updateProfileSegue", sender: sender)
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
        let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imageName)
        
//        print(imageURL)
//        print(imageName)
        print(localPath)
        
        profilePicURL = localPath.absoluteString
        
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
    
//    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool
//    {
//        return false
//    }
    
//    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController)
//    {
//        print("now in update screen!!!")
//    }
    
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

