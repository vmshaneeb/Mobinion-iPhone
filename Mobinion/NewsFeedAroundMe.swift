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
import SVProgressHUD

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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
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
        
//        StartLoader()
        SVProgressHUD.show()
        getAroundme()
        { value, data, error in
                
            if value != nil
            {
                let json = JSON(value!)
                print(json)
                
                SVProgressHUD.dismiss()
                
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
                SVProgressHUD.dismiss()
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
        
        if (aroundMe[indexPath.row].valueForKey("longitude")?.isKindOfClass(NSNull) != nil && aroundMe[indexPath.row].valueForKey("latitude")?.isKindOfClass(NSNull) != nil)
        {
            if (!(aroundMe[indexPath.row]["longitude"]!!.isKindOfClass(NSNull)) && !(aroundMe[indexPath.row]["latitude"]!!.isKindOfClass(NSNull)))
            {
                let long = aroundMe[indexPath.row]["longitude"]!!.doubleValue
                let lat = aroundMe[indexPath.row]["latitude"]!!.doubleValue
//                print("long: \(long), lat: \(lat)")
                let marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2DMake(lat, long)
                
                let type = (aroundMe[indexPath.row]["post_type"] as! String)
                
                switch type
                {
                    case "contest":
                        marker.icon = UIImage(named: "Map-contest")
                    case "poll":
                        marker.icon = UIImage(named: "Map-poll")
                    case "voting":
                        marker.icon = UIImage(named: "Map-vote")
                    default:
                        break
//                        marker.icon = UIImage(named: "")
                }
                
        //        marker.title = "Al Sebseb"
        //        marker.snippet = "Qatar"
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = mapView
            }
        }
        
        if (aroundMe[indexPath.row].valueForKey("title")?.isKindOfClass(NSNull) != nil)
        {
            if (!(aroundMe[indexPath.row]["title"]!!.isKindOfClass(NSNull)))
            {
                cell.titleLabel.text = (aroundMe[indexPath.row]["title"] as! String)
            }
            else
            {
                cell.titleLabel.text = ""
            }
        }
        else
        {
            cell.titleLabel.text = ""
        }
        
        if (aroundMe[indexPath.row].valueForKey("name")?.isKindOfClass(NSNull) != nil)
        {
            if (!(aroundMe[indexPath.row]["name"]!!.isKindOfClass(NSNull)))
            {
                cell.nameLabel.text = (aroundMe[indexPath.row]["name"] as! String)
//                print(cell.nameLabel.text)
            }
            else
            {
                cell.nameLabel.text = ""
            }
        }
        else
        {
            cell.nameLabel.text = ""
        }
        
        // for rounded profile pic
        cell.itemImage.layer.cornerRadius = cell.itemImage.frame.size.width / 2
        cell.itemImage.clipsToBounds = true
        
        if (aroundMe[indexPath.row].valueForKey("image")?.isKindOfClass(NSNull) != nil)
        {
            if (!(aroundMe[indexPath.row]["image"]!!.isKindOfClass(NSNull)))
            {
        
                let url = NSURL(string: aroundMe[indexPath.row]["image"] as! String)
                cell.itemImage.sd_setImageWithURL(url!)
            }
            else
            {
                cell.itemImage.image = nil
            }
        }
        else
        {
            cell.itemImage.image = nil
        }
        
        if (aroundMe[indexPath.row].valueForKey("post_type")?.isKindOfClass(NSNull) != nil)
        {
            if (!(aroundMe[indexPath.row]["post_type"]!!.isKindOfClass(NSNull)))
            {
                let type = (aroundMe[indexPath.row]["post_type"] as! String)
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
            }
            else
            {
                cell.contest_Image.image = nil
            }
        }
        else
        {
            cell.contest_Image.image = nil
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return tableView.dequeueReusableCellWithIdentifier("tableHeader")! 
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
    
    //MARK:- Actions
    @IBAction func notify(sender: AnyObject)
    {
        performSegueWithIdentifier("showNotificationFromAroundMe", sender: sender)
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
