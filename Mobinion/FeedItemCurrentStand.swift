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

class FeedItemCurrentStand: UIViewController, ChartViewDelegate
{
    @IBOutlet weak var pollHeader: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var pieInsideView: UIView!
    @IBOutlet weak var totalParts: UILabel!
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
        
        // for rounded pieInsideView
        pieInsideView.layer.cornerRadius = pieInsideView.frame.size.width / 2
        pieInsideView.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- ChartViewDelegates
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("chartValueSelected")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
    }
    
    //MARK:- Actions
    @IBAction func backBtn(sender: AnyObject)
    {
//        self.tabBarController?.selectedIndex = 2
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func searchBtn(sender: AnyObject)
    {
        
    }
    
    @IBAction func notifyBtn(sender: AnyObject)
    {
        performSegueWithIdentifier("showNotificationsfromCurrent", sender: sender)
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
                            
                            for i in 0 ..< json["data"]["item"]["questionDetails"].count
                            {
//                                print(json["data"]["item"]["questionDetails"])
                                self.questions.append(json["data"]["item"]["questionDetails"][i]["question"].string!)
                            }
//                            print(self.questions)
                            
                            for i in 0 ..< json["data"]["item"]["questionDetails"][0]["options"].count
                            {
//                                print(json["data"]["item"]["questionDetails"][0]["options"][i]["content"])
                                self.options.append(json["data"]["item"]["questionDetails"][0]["options"][i]["content"].string!)
                                self.votes.append(json["data"]["item"]["questionDetails"][0]["options"][i]["numberOfVotes"].double!)
                            }
//                            print(self.options)
//                            print(self.votes)
                            
                            self.pollHeader.text = json["data"]["item"]["itemText"].string!
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let sdate = json["data"]["item"]["item_expiryDate"].string!
//                            print(sdate)
                            let datesString:NSDate = dateFormatter.dateFromString(sdate)!
//                            print(datesString)
                            dateFormatter.dateFormat = "dd MMM yyyy"
//                            print(dateFormatter.stringFromDate(datesString))
                            self.finalDate.text = dateFormatter.stringFromDate(datesString)
                            
                            self.totalParts.text = String(json["data"]["item"]["participants"].int!)
                            
                            self.setChart(self.options, values: self.votes)
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
//        pieChart.setExtraOffsets(left: 20.0, top: 0.0, right: 20.0, bottom: 0.0)
//        pieChart.noDataText = "You need to provide data for the chart."
        pieChart.legend.enabled = false
        pieChart.drawSliceTextEnabled = false
        pieChart.centerText = " "
        pieChart.descriptionText = ""
        
        pieChart.delegate = self
        
        pieChart.animate(yAxisDuration: 1.4, easingOption: ChartEasingOption.EaseOutBack)
        
//        pieChart.
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Votes")
        
        pieChartDataSet.sliceSpace = 2.0
        
//        pieChartDataSet.valueLinePart1OffsetPercentage = 0.8
//        pieChartDataSet.valueLinePart1Length = 0.2
//        pieChartDataSet.valueLinePart2Length = 0.4
        //dataSet.xValuePosition = .OutsideSlice
        pieChartDataSet.yValuePosition = .OutsideSlice

        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count
        {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colors.append(color)
        }
        
        
//        let colors = NSMutableArray()
//        colors.addObjectsFromArray(ChartColorTemplates.vordiplom())
//        colors.addObjectsFromArray(ChartColorTemplates.joyful())
//        colors.addObjectsFromArray(ChartColorTemplates.colorful())
//        colors.addObjectsFromArray(ChartColorTemplates.liberty())
//        colors.addObjectsFromArray(ChartColorTemplates.pastel())
//        colors.addObjectsFromArray(UIColor(red: 51/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1.0))
        
        pieChartDataSet.colors = colors
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = "%"
        
        pieChartData.setValueFormatter(pFormatter)
        pieChartData.setValueFont(UIFont(name: "Roboto-Medium", size: 13.0))
        pieChartData.setValueTextColor(UIColor.whiteColor())
        
        pieChartData.highlightEnabled = false
        
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