//
//  CreateAccount.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/18/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateAccount: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var header3: UILabel!
    @IBOutlet weak var usrSalutation: UITextField!
    @IBOutlet weak var saltnArrow: UIImageView!
    @IBOutlet weak var usrFullname: UITextField!
    @IBOutlet weak var usrName: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var dobField: UITextField!

    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var salutnPicker: UIPickerView!
    
    @IBOutlet weak var usrnameLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    
    @IBOutlet weak var checkBox: UIButton!
    
    var salutnPickerData: [String] = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver( self, selector: #selector(serverdelegate.serverresponse(_:)), name: "AppdelegatePage" ,object: nil)
        
//        usrSalutation.inputView = salutnPicker
//        dobField.inputView = dobPicker
        
        salutnPickerData = ["Mr",
                            "Mrs",
                            "Mstr",
                            "Miss",
                            "Dr",
                            "Prof"]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return salutnPickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return salutnPickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        usrSalutation.text = salutnPickerData[row]
        salutnPicker.hidden = true
//        usrSalutation.userInteractionEnabled = true
    }
    
    @IBAction func dateValueChanged(sender:UIDatePicker)
    {
        dobField.text = sender.date.description
        dobPicker.hidden = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
//        usrSalutation.inputView = salutnPicker
        
        if (dobField == textField)
        {
            dobPicker.hidden = false
            salutnPicker.hidden = false
            
            dobField.resignFirstResponder()
            usrSalutation.resignFirstResponder()
        }
        
        
        
//        usrSalutation.userInteractionEnabled = false
//        dobField.userInteractionEnabled = false
    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
//    {
//        dobPicker.hidden = false
//        salutnPicker.hidden = false
//        
//        usrSalutation.userInteractionEnabled = false
//        dobField.userInteractionEnabled = false
//        
//        return false
//    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
//        dobPicker.hidden = true
//        salutnPicker.hidden = true
//        
        self.view.endEditing(true)
    }
    
    @IBAction func createBtn (sender: AnyObject)
    {
        
        self.StartLoader ()
        
        let header = ["key": "Authorization",
                      "value": "JWTtoken"]
        
        let URL = "http://vyooha.cloudapp.net:1337/createAccount"
        let URL2 = "http://vyooha.cloudapp.net:1337/checkUsernameAvailability"
        
        Alamofire.request(.POST, URL, parameters: ["name": usrName.text!,
                                                   "username": usrFullname.text!,
                                                   "zipCode": zipCode.text!,
                                                   "dob(DD/MMM/YYYY)": dobField.text!],
                          headers: header, encoding: .JSON)
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
        
        
        Alamofire.request(.POST, URL2, parameters: ["username": usrName.text!],headers: header ,encoding: .JSON)
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
        
        performSegueWithIdentifier("createAccountSegue", sender: sender)
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



