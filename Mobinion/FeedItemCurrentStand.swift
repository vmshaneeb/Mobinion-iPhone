//
//  FeedItemCurrentStand.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/31/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DBAlertController
import Charts

class FeedItemCurrentStand: UIViewController
{
    @IBOutlet weak var pollHeader: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var finalDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var itemID = ""
    var itemDetails = NSMutableDictionary()
    var questions = [String]()
    var options = [String]()
    var votes = [Double]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print(itemID)
        getItemDetails()
        
        setChart(options, values: votes)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
        
    }

    @IBAction func searchBtn(sender: AnyObject)
    {
        
    }
    
    @IBAction func notifyBtn(sender: AnyObject)
    {
        
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
    
    func getCurrentStand(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/itemDetails"
        
        let parameter = ["itemType": "poll", "itemId": itemID, "notificationId": ""]
        
        Alamofire.request(.POST, URL, headers: header, parameters: parameter, encoding: .JSON)
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
    
    func getItemDetails()
    {
        self.StartLoader()
        
        getCurrentStand()
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
                        self.doDBalertView(titles, msgs: messages)
                    }
                    else
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                            
                            self.itemDetails = responseObject.objectForKey("data")?.mutableCopy() as! NSMutableDictionary
                            
                            print (self.itemDetails)
                            
                            for i in 0 ..< json["data"]["questionDetails"].count
                            {
                                print(json["data"]["questionDetails"])
                                self.questions.append(json["data"]["questionDetails"][i]["question"].string!)
                            }
                            print(self.questions)
                            
                            for i in 0 ..< json["data"]["questionDetails"][0]["options"].count
                            {
                                self.options.append(json["data"]["questionDetails"][0]["options"][i]["content"].string!)
                                self.votes.append(json["data"]["questionDetails"][0]["options"][i]["numberOfVotes"].double!)
                            }
                            print(self.options)
                            print(self.votes)
                        }
                        catch
                        {
                            print("error in responseObject")
                        }
//                        self.tableView.reloadData()
                    }
                }
                else
                {
                    self.HideLoader()
                    //                    print(error)
                    self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
                }
        }
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        pieChart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Votes")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        pieChart.data = pieChartData
    }
    
    //MARK: - Loader
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