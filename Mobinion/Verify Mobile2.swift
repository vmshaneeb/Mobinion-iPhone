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
import PhoneNumberKit

class VerifyMobile2: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var heading3: UILabel!
    @IBOutlet weak var heading4: UILabel!
    @IBOutlet weak var heading5: UILabel!
    @IBOutlet weak var verifyCode: UITextField!
    
//    var num: NSString!
    var num = String()
    var ccode = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
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
//                        let alertController = DBAlertController(title: titles.capitalizedString, message: messages.capitalizedString, preferredStyle: .Alert)
//                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:
//                        { action in
//                            switch action.style
//                            {
//                                case .Default:
                                    self.performSegueWithIdentifier("verifySecondSegue", sender: sender)
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
//        print(num)
//        print(ccode)
        
        let no = ccode + num
        var code = ""
        
        do
        {
            let phoneNumber = try PhoneNumber(rawNumber: no)
            code = String(phoneNumber.countryCode)
            
//                        print(code)
//                        print(no)
        }
        catch //if no country code
        {
            print("error in country code conversion!!!!")
        }

        
        let URL = "http://vyooha.cloudapp.net:1337/verifyMobileNumber"
        
        Alamofire.request(.POST, URL, parameters: ["mobile": num, "otp":verifyCode.text!, "countryCode": code], encoding: .JSON)
//            Alamofire.request(.POST, URL, parameters: ["mobile": num, "otp":verifyCode.text!], encoding: .JSON)
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

