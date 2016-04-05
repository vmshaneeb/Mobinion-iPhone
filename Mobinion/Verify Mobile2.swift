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

class VerifyMobile2: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var heading3: UILabel!
    @IBOutlet weak var heading4: UILabel!
    @IBOutlet weak var heading5: UILabel!
    @IBOutlet weak var verifyCode: UITextField!
    
    var num: NSString!
    var vcode: String = ""
    
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
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
//        verifyCode.userInteractionEnabled = false
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        vcode = verifyCode.text!
    
    return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
//        picker?.hidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func verifyMobile2(sender: AnyObject)
    {
        self.StartLoader()
        
//        print(cntry)
        print(num)
        
        vcode = verifyCode.text!
        print(vcode)
        
        
        let URL = "http://vyooha.cloudapp.net:1337/verifyMobileNumber"
        
        Alamofire.request(.POST, URL, parameters: ["mobile": num, "otp":verifyCode.text!], encoding: .JSON)
            .responseJSON { response in
                switch response.result
                {
                 case .Success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print(json)
                        
                        let token = json["data"]["token"].stringValue
                        print(token)
                    }
                 case .Failure(let error):
                    print("Request Failed with Error!!! \(error)")
                }
        }
        
        
//        NSUserDefaults.standardUserDefaults().setObject(json["data"]["token"].stringValue, forKey: "tocken")
//        NSUserDefaults.standardUserDefaults().synchronize()
//        NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        self.performSegueWithIdentifier("verifySecondSegue", sender: sender)
        
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

