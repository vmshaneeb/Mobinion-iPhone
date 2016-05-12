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
import DBAlertController
import IQDropDownTextField

class CreateAccount: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var header3: UILabel!
//    @IBOutlet weak var usrSalutation: UITextField!
    @IBOutlet weak var usrSalutation: IQDropDownTextField!
    @IBOutlet weak var saltnArrow: UIImageView!
    @IBOutlet weak var usrFullname: UITextField!
    @IBOutlet weak var usrName: UITextField!
    @IBOutlet weak var zipCode: UITextField!
//    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var dobField: IQDropDownTextField!

    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var salutnPicker: UIPickerView!
    
    @IBOutlet weak var usrnameLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    
    @IBOutlet var alltextFields: [UITextField]!
    
    var popDatePicker : PopDatePicker?
    
    var salutnPickerData: [String] = [String]()
    
    let nextField = [1:2, 2:3, 3:4, 4:5, 5:1]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var returnKeyHandler = IQKeyboardReturnKeyHandler.init(viewController: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(serverdelegate.serverresponse(_:)), name: "AppdelegatePage" ,object: nil)
        
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        print(tok)
        
        salutnPickerData = ["Mr",
                            "Mrs",
                            "Mstr",
                            "Miss",
                            "Dr",
                            "Prof"]
        
        popDatePicker = PopDatePicker(forTextField: dobField)
        
        usrSalutation.isOptionalDropDown = false
        usrSalutation.itemList = ["Mr",
                                  "Mrs",
                                  "Mstr",
                                  "Miss",
                                  "Dr",
                                  "Prof"]
        
        dobField.isOptionalDropDown = false
        dobField.dropDownMode = IQDropDownMode.DatePicker
        
        let df = NSDateFormatter()
        
//        dobField.se
        
        df.dateFormat = "dd/MMM/yyyy"
        dobField.dateFormatter = df
        
        dobField.setSelectedItem(df.stringFromDate(NSDate()), animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIPickerViewDelegates
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
    }
    
    
    
//    func doneButton2(sender:UIButton)
//    {
//        dobPicker.resignFirstResponder() // To resign the inputView on clicking done.
//    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
//    {
//        if (dobField == textField)
//        {
//            dobField.resignFirstResponder()
//        }
//        else if (usrSalutation == textField)
//        {
//            usrSalutation.resignFirstResponder()
//        }
//        
//        return false
//    }
//    
    //MARK:- UITextFieldDelegates
//    func textFieldDidBeginEditing(textField: UITextField)
//    {
//        if (dobField == textField)
//        {
//            self.close_all_textfields()
//            dobPicker.hidden = false
//        }
//        else if (usrSalutation == textField)
//        {
//            self.close_all_textfields()
//            salutnPicker.hidden = false
//        }
//    }
    
//    //for popup date picker
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
//    {
//        print(textField)
//        if (dobField == textField)
//        {
//            close_all_textfields()
//            
//            let formatter = NSDateFormatter()
//            formatter.dateStyle = .MediumStyle
//            formatter.timeStyle = .NoStyle
//            
//            let initDate : NSDate? = formatter.dateFromString(dobField.text!)
//            
////            print(initDate)
//            
//            let dataChangedCallback: PopDatePicker.PopDatePickerCallback =
//            { (newDate : NSDate, forTextField : UITextField) -> () in
//                    
//                // here we don't use self (no retain cycle)
//                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
//            
//            }
//            
//            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
//            
//            return false
//        }
//        else
//        {
//            return true
//        }
//    }
    
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
//    {
//        // Create a button bar for the number pad
//        let keyboardDoneButtonView = UIToolbar()
//        keyboardDoneButtonView.sizeToFit()
//        
//        // Setup the buttons to be put in the system.
//        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CreateAccount.doneButton))
////        nextButton.width = 50.0
////        let nextButton  = UIBarButtonItem(image: UIImage(named: "keyboardNextButton"), style: .Plain, target: self, action: #selector(CreateAccount.keyboardNextButton))
////        let previousButton  = UIBarButtonItem(image: UIImage(named: "keyboardNextButton"), style: .Plain, target: self, action: #selector(CreateAccount.keyboardPreviousButton))
////        let fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
//        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
//        
////        let toolbarButtons = [previousButton, fixedSpaceButton, nextButton, flexibleSpaceButton, doneButton]
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
 
//    func keyboardNextButton(textField: UITextField)
//    {
//        if let nextTag = nextField[textField.tag] {
//            if let nextResponder = textField.superview!.viewWithTag(nextTag) {
//                // Have the next field become the first responder
//                nextResponder.becomeFirstResponder()
//            }
//        }
//    }
//    
//    func keyboardPreviousButton()
//    {
////        let responder: UIView = self.view.fnd
//        
//        
//    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        self.view.endEditing(true)
//        
////        if let nextTag = nextField[textField.tag]
////        {
////            if let nextResponder = textField.superview!.viewWithTag(nextTag)
////            {
////                // Have the next field become the first responder
////                nextResponder.becomeFirstResponder()
////            }
////        }
//        
//        return false
//    }
    
    //MARK:- Overrides
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        dobPicker.hidden = true
        salutnPicker.hidden = true
        
        self.view.endEditing(true)
    }
    
    //MARK:- Actions
    @IBAction func dateValueChanged(sender:UIDatePicker)
    {
        //        //Create the view
        //        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        //
        //        inputView.addSubview(dobPicker)
        //
        //
        //        let doneButton2 = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        //        doneButton2.setTitle("Done", forState: UIControlState.Normal)
        //        doneButton2.setTitle("Done", forState: UIControlState.Highlighted)
        //        doneButton2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //        doneButton2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        //
        //        inputView.addSubview(doneButton2) // add Button to UIView
        //
        //        doneButton2.addTarget(self, action: #selector(CreateAccount.doneButton2(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        
//        dobField.text = dateFormatter.stringFromDate(sender.date)
//        
//        print(dobField.text)
        
    }
    
    @IBAction func checkBox(sender: UIButton)
    {
        sender.selected = !sender.selected
    }
    
    @IBAction func createBtn (sender: UIButton)
    {
        //TODO:- check box validation
        var count = 0
        for textfield in alltextFields
        {
            
            if (textfield.text!.isEmpty)
            {
                count += 1
                print(count)
                
            }
        }
        
        if count > 0
        {
//            print("entered...")
            
            self.doalertView("No Texts Entered", msgs: "Pls enter respective texts in the fields")
//            
//            let titles = "No Texts Entered!!!"
//            let messages = "Pls enter respective texts in the fields"
//            let alertController = UIAlertController(title: titles, message: messages, preferredStyle: .Alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .Default,handler: nil)
////            {
////                UIAlertAction in self.navigationController?.popViewControllerAnimated(true)
////            }
//            
//            alertController.addAction(defaultAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
        
        
        print(usrName.text)
        print(usrFullname.text)
        print(zipCode.text)
//        print(dobField.text)
        
        self.StartLoader ()
            
        sendcheckUsernameAvail()
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
                    self.StartLoader ()
                    
                    self.sendCreateAC()
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
//                                    let alertController = DBAlertController(title: titles.capitalizedString, message: messages.capitalizedString, preferredStyle: .Alert)
//                                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:
//                                        { action in
//                                            switch action.style
//                                            {
//                                            case .Default:
                                                self.performSegueWithIdentifier("createAccountSegue", sender: sender)
//                                            default:
//                                                break
//                                            }
//                                    })
//                                    
//                                    alertController.addAction(defaultAction)
//                                    alertController.show()
//                                    
                                    
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
            else
            {
                self.HideLoader()
                print(error)
                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
            }
        }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let secondVC = segue.destinationViewController as! UpdateProfile
//        print("for segue \(usrFullname.text!)")
        secondVC.profName = usrFullname.text!
    }
    
    //MARK:- Custom Functions
    func close_all_textfields()
    {
        usrName.resignFirstResponder()
        usrFullname.resignFirstResponder()
        usrSalutation.resignFirstResponder()
        dobField.resignFirstResponder()
        zipCode.resignFirstResponder()
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
    
    func sendCreateAC(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
//        print(header)

        let URL = "http://vyooha.cloudapp.net:1337/createAccount"
//        print(usrName.text)
        Alamofire.request(.POST, URL, parameters: ["name": usrFullname.text!,
                                                   "username": usrName.text!,
                                                   "zipCode": zipCode.text!,
                                                   "dob": dobField.selectedItem!], headers: header, encoding: .JSON)
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

    func sendcheckUsernameAvail(completionHandler : (NSDictionary?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
//        print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/checkUsernameAvailability"
        
        Alamofire.request(.POST, URL, parameters: ["username": usrName.text!], headers: header, encoding: .JSON)
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



