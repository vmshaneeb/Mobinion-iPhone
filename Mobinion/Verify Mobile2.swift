//
//  Verify Mobile2.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/5/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController

class VerifyMobile2: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var heading3: UILabel!
    @IBOutlet weak var heading4: UILabel!
    @IBOutlet weak var heading5: UILabel!
    @IBOutlet weak var verifyCode: UITextField!
    
    var num: NSString!
//    var vcode: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        print(num!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
//    func textFieldDidBeginEditing(textField: UITextField)
//    {
////        verifyCode.userInteractionEnabled = false
//    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
//    {
//        // Create a button bar for the number pad
//        let keyboardDoneButtonView = UIToolbar()
//        keyboardDoneButtonView.sizeToFit()
//        
//        // Setup the buttons to be put in the system.
//        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CreateAccount.doneButton))
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
//    
//    func doneButton()
//    {
//        self.view.endEditing(true)
//    }

    
//    func textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        self.view.endEditing(true)
//        
//        return false
//    }
    
    //MARK:- Overrrides
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
//        picker?.hidden = true
        self.view.endEditing(true)
    }
    
    //MARK:- Actions
    @IBAction func verifyMobile2(sender: AnyObject)
    {
//        print(cntry)
//        print(num)
        
//        vcode = verifyCode.text!
//        print(vcode)
        
        
        if ((verifyCode.text?.isEmpty)!)
        {
            doalertView("No Verification Code Entered", msgs: "Pls enter the verification code in the field")
        }
        else
        {
            self.StartLoader()
            
            sendOTP()
            { value, error in
                
                if value != nil
                {
                    let json = JSON(value!)
                    print(json)
                    
                    let toks = json["data"]["token"].stringValue
                    
//                    print(toks)
                    
                    var token:String = "JWT "
                    token.appendContentsOf(toks)
                    print(token)

            
                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.HideLoader()
                    
                    let titles = json["status"].stringValue
                    let messages = json["message"].stringValue
                    
                    if titles == "error"
                    {
                        self.doDBalertView(titles, msgs: messages)
                    }
                    else
                    {
                        let alertController = DBAlertController(title: titles.capitalizedString, message: messages.capitalizedString, preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:
                        { action in
                            switch action.style
                            {
                                case .Default:
                                    self.performSegueWithIdentifier("verifySecondSegue", sender: sender)
                                default:
                                    break
                            }
                        })
                        
                        alertController.addAction(defaultAction)
                        alertController.show()
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
    
    func sendOTP(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let URL = "http://vyooha.cloudapp.net:1337/verifyMobileNumber"
        
        Alamofire.request(.POST, URL, parameters: ["mobile": num, "otp":verifyCode.text!], encoding: .JSON)
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

