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

class UpdateProfile: UIViewController
{
    @IBOutlet weak var skipBtn: UIBarButtonItem!
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var header3: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBio: UITextField!
    @IBOutlet weak var profileBrief: UITextField!
    
//    @IBOutlet weak var updateBtn: UIButton!
    
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
    
    @IBAction func updateBtn (sender: AnyObject)
    {
        self.StartLoader()
        
        let URL = "http://vyooha.cloudapp.net:1337/updateProfile"
        
        Alamofire.request(.POST, URL, parameters: ["profilePic(url)": profilePic,
                                                   "userBio": profileBio.text!,
                                                   "aboutUser": profileBrief.text!], encoding: .JSON)
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

