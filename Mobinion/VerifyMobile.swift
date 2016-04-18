//
//  VerifyMobile.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/18/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VerifyMobile: UIViewController, CountryPhoneCodePickerDelegate, UITextFieldDelegate
{
 
    @IBOutlet weak var heading1: UILabel!
    @IBOutlet weak var heading2: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var picker: CountryPicker!
    
    @IBOutlet var allTextFields: [UITextField]!
//    var cntry:String = ""
//    var num:String = ""
//    var vcode: String = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
//        country.inputView = picker
//        NSNotificationCenter.defaultCenter().addObserver( self, selector: "serverresponse:", name: "AppdelegatePage" ,object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver( self, selector: #selector(serverdelegate.serverresponse(_:)), name: "AppdelegatePage" ,object: nil)
        
        let locale = NSLocale.currentLocale()
        let code = locale.objectForKey(NSLocaleCountryCode) as! String
        picker?.setCountry("IN")
        
        picker?.countryPhoneCodeDelegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func countryPhoneCodePicker(picker: CountryPicker, didSelectCountryCountryWithName name: String, countryCode: String, phoneCode: String)
    {
        country.text = phoneCode
        print(country.text)
    }

    
    @IBAction func VerifyMobile(sender:AnyObject)
    {
        //MARK: - Alamofire
        
        
        
        self.StartLoader()
        
//        print(country?.text, number?.text)
        
//        cntry = country.text!
//        num = number.text!
//
//        
//        print(cntry)
//        print(num)
        
        let URL = "http://vyooha.cloudapp.net:1337/generateOtp"
        
        Alamofire.request(.POST, URL, parameters: ["mobile": number.text!], encoding: .JSON)
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
//                print("original URL request")
//                print(response.request)  // original URL request
//                print("URL response")
//                print(response.response) // URL response
//                print("server data")
//                print(response.data)     // server data
//                print("result of response serialization")
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value
//                {
//                    print("JSON: \(JSON)")
//                }
        }

        performSegueWithIdentifier("verifyFirstSegue", sender: sender)
        
        
        //MARK: - Hamdan Code
        //WE need to check if the textfield has numbers first and then call this function...once the respose comes in the below function then push to the new view...
//        let Functionname : NSString = NSString(string: "generateOtp")
////        let Postdata : NSString = NSString(string: "\(Functionname),{\"mobile\":\"9037424243\"}")
//        
//        let backSlash:Character = "\\"
//        var mobno:String = number!.text as String
////        mobno.append(backSlash)
//        
//        let Postdata : NSString = NSString(string: "\(Functionname),{\"mobile\":\()\"}")
//        print(Postdata)
////        let myCell = ServerRequests()
//        self.StartLoader()
//        let ocObject = ServerRequests()
//        let theDelegate=ocObject.delegate
//        theDelegate.self
////        myCell.delegate=self
//        ocObject.serverrequest(Postdata as String)
    }
    
    
        
    func serverresponse(str: NSString)
    {
        self.stopLoader()
        print(str)
    }
    
//    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat{
//        return 0.0
//    }
    

    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if (country == textField)
        {
            picker?.hidden = false
            country?.resignFirstResponder()
        }
    }
    
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
    
//    func doneButton()
//    {
//        self.view.endEditing(true)
//    }
    

//    func  textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        self.view.endEditing(true)
//        
//        return false
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        picker?.hidden = true
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        if identifier == "verifyFirstSegue"
        {
            if ((number.text?.isEmpty) != nil)
            {
                let titles = "No Phone# Entered!!!"
                let messages = "Pls enter a phone number in the field"
                let alertController = UIAlertController(title: titles, message: messages, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return false
            }
            else
            {
                return true
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let secondVC = segue.destinationViewController as! VerifyMobile2
        secondVC.num = number.text!
        
//        print(secondVC.num)
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