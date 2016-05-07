//
//  NewsFeedAroundMe.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/21/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import DBAlertController
import GoogleMaps
import DZNEmptyDataSet

class NewsFeedAroundMe: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var aroundMe = NSMutableArray()
    
    var lat = ""
    var long = ""
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        //        print("in NewsFeedController")
        
        tableView.registerClass(AroundMeTableViewCell.self, forCellReuseIdentifier: "aroundmecell")
        let nib:UINib = UINib(nibName: "AroundMeTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "aroundmecell")
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            mapView.camera = GMSCameraPosition.cameraWithTarget((locationManager.location?.coordinate)!, zoom: 12.0)
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.settings.compassButton = true
            mapView.settings.setAllGesturesEnabled(true)
        }
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
//        marker.title = "Al Sebseb"
//        marker.snippet = "Qatar"
//        marker.map = mapView
        
        StartLoader()
        
        getAroundme()
        { value, data, error in
                
            if value != nil
            {
                let json = JSON(value!)
                print(json)
                
                self.HideLoader()
                
                let titles = json["status"].stringValue
                let messages = json["message"].stringValue
                
                if titles == "error"
                {
//                    self.doDBalertView(titles, msgs: messages)
                    print("\(titles): \(messages)")
                }
                else
                {
                    do
                    {
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        self.aroundMe = responseObject["data"]!["results"]!!.mutableCopy() as! NSMutableArray
                        //print (self.newsFeed)
                    }
                    catch
                    {
                        print("error in responseObject")
                    }
                    self.tableView.reloadData()

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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CLLocationManagerDelegates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0]
        
        lat = String(userLocation.coordinate.latitude)
        long = String(userLocation.coordinate.longitude)
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aroundMe.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("aroundmecell") as! AroundMeTableViewCell
        
        cell.titleLabel.text = (aroundMe[indexPath.row]["title"] as! String)
        cell.nameLabel.text = (aroundMe[indexPath.row]["name"] as! String)
        
        // for rounded profile pic
        cell.itemImage.layer.cornerRadius = cell.itemImage.frame.size.width / 2
        cell.itemImage.clipsToBounds = true
        
        let url = NSURL(string: aroundMe[indexPath.row]["image"] as! String)
        cell.itemImage.sd_setImageWithURL(url!)
        
        let type = (aroundMe[indexPath.row]["subType"] as! String)
        var imgName = ""
        
        switch type
        {
            case "contest":
                imgName = "contest-new"
            case "poll":
                imgName = "poll-new"
            case "voting":
                imgName = "voting-new"
            default:
                imgName = "poll-new"
        }
        
        cell.contest_Image.image = UIImage(named: imgName)
        
        return cell
    }
    
    //MARK:- DZNEmptyDataSetDelegate
    //    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    //    {
    //        let str = "Welcome"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString!
    {
        let str = "You dont have any activities nearby"
        let attrs = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 17)!]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    //        return UIImage(named: "taylor-swift")
    //    }
    
    //    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString!
    //    {
    //        let str = "Add Grokkleglob"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    //
    //
    //    func emptyDataSetDidTapButton(scrollView: UIScrollView!)
    //    {
    //        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
    //        ac.addAction(UIAlertAction(title: "Hurray", style: .Default, handler: nil))
    //        presentViewController(ac, animated: true, completion: nil)
    //    }
    
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
    
    func getAroundme(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/aroundme"
        
        Alamofire.request(.POST, URL, headers: header, parameters: ["lat": lat, "lon": long], encoding: .JSON)
//        Alamofire.request(.POST, URL, headers: header, parameters: ["lat": "10.0082783", "lon": "76.3592398"], encoding: .JSON)
            .responseJSON { response in
                switch response.result
                {
                case .Success:
                    if let value = response.result.value
                    {
                        completionHandler(value as? NSDictionary, response.data, nil)
                    }
                    
                case .Failure(let error):
                    completionHandler(nil, nil, error)
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
