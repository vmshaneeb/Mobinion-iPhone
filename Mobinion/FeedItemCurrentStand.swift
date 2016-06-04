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
import SDWebImage

class FeedItemCurrentStand: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var pollHeader: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var pieInsideView: UIView!
    @IBOutlet weak var totalParts: UILabel!
    @IBOutlet weak var finalDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewComments: UITableView!
    
    @IBOutlet weak var addCommentView: UIView!
    @IBOutlet weak var addCommentLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var tableViewHt: NSLayoutConstraint!
    @IBOutlet weak var tableViewCommentsHt: NSLayoutConstraint!
    
    
    var itemID = ""
    var feedID = ""
    var itemType = ""
    
    var itemDetails = NSMutableDictionary()
    var comments = NSMutableArray()
    
    var questions = [String]()
    var options = [String]()
    var votes = [Double]()
    
    var totPart: Int?
//    var totPartstr = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var nib:UINib = UINib(nibName: "CurrentStandCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CurrentStandCell")

        nib = UINib(nibName: "CurrentStandCell4ImagePoll", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CurrentStandCell4ImagePoll")
        
        nib = UINib(nibName: "CurrentStandImgCell", bundle: nil)
        tableViewComments.registerNib(nib, forCellReuseIdentifier: "CurrentStandImgCell")
        
        nib = UINib(nibName: "CurrentStandImgCellHeader", bundle: nil)
        tableViewComments.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CurrentStandImgCellHeader")
        
//        tableViewComments.
        
        print("ItemID:- \(itemID)")
        getItemDetails()
        
//        print("FeedID:- \(feedID)")
        getCommentDetails()
        HideLoader()
        
//        totPart = 0
        
        // for rounded pieInsideView
        pieInsideView.layer.cornerRadius = pieInsideView.frame.size.width / 2
        pieInsideView.clipsToBounds = true
        
        addCommentView.layer.borderWidth = 3.0
        addCommentView.layer.cornerRadius = 25
        addCommentView.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- ChartViewDelegates
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
//        print("chartValueSelected")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase)
    {
//        print("chartValueNothingSelected")
    }
    
    //MARK:- UITableViewDataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 1
        {
            return options.count
        }
        else 
        {
            return comments.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
//        HideLoader()
        if tableView.tag == 1
        {
            if itemType == "ques_poll"
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("CurrentStandCell", forIndexPath: indexPath) as! CurrentStandCell
                //TODO:- get pollPieColor
                //            cell.pollPieColor
                cell.options.text = options[indexPath.row]
                //        cell.pollPieColor.image =
                cell.totVotes.text = String(votes[indexPath.row])
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("CurrentStandCell4ImagePoll", forIndexPath: indexPath) as! CurrentStandCell4ImagePoll
                //            cell.pollPieColor

                //        cell.pollPieColor.image =
                cell.totVotes.text = String(votes[indexPath.row])
                
                if !options[indexPath.row].isEmpty
                {
                    let url = NSURL(string: options[indexPath.row])
                    cell.pollImg.sd_setImageWithURL(url!)
                }
                else
                {
                    cell.pollImg.image = nil
                }
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentStandImgCell", forIndexPath: indexPath) as! CurrentStandImgCell
            
            if (comments[indexPath.row].valueForKey("name")?.isKindOfClass(NSNull) != nil)
            {
                if (!(comments[indexPath.row]["name"]!!.isKindOfClass(NSNull)))
                {
                    cell.userName.text = (comments[indexPath.row]["name"] as! String)
                }
                else
                {
                    cell.userName.text = ""
                }
            }
            else
            {
                cell.userName.text = ""
            }
            
            if (comments[indexPath.row].valueForKey("profilePic")?.isKindOfClass(NSNull) != nil)
            {
                if (!(comments[indexPath.row]["profilePic"]!!.isKindOfClass(NSNull)))
                {
                    let url = NSURL(string: comments[indexPath.row]["profilePic"] as! String)
                    //                print(url)
                    
                    cell.profImg.sd_setImageWithURL(url!)

                    // for rounded profile pic
                    cell.profImg.layer.cornerRadius = cell.profImg.frame.size.width / 2
                    cell.profImg.clipsToBounds = true
                }
                else
                {
                    cell.profImg.image = nil
                }
            }
            else
            {
                cell.profImg.image = nil
            }
            
            if (comments[indexPath.row].valueForKey("comment")?.isKindOfClass(NSNull) != nil)
            {
                if (!(comments[indexPath.row]["comment"]!!.isKindOfClass(NSNull)))
                {
                    cell.commentLabel.text = (comments[indexPath.row]["comment"] as! String)
                }
                else
                {
                    cell.commentLabel.text = ""
                }
            }
            else
            {
                cell.commentLabel.text = ""
            }
            
            if (comments[indexPath.row].valueForKey("commentTime")?.isKindOfClass(NSNull) != nil)
            {
                if (!(comments[indexPath.row]["commentTime"]!!.isKindOfClass(NSNull)))
                {

                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    let datesString:NSDate = dateFormatter.dateFromString(comments[indexPath.row]["commentTime"] as! String)!
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    
                    cell.dateLabel.text = dateFormatter.stringFromDate(datesString)
                }
                else
                {
                    cell.dateLabel.text = ""
                }
            }
            else
            {
                cell.dateLabel.text = ""
            }
            
            return cell
        }
    }
    
    //MARK:- UITableViewDelegates
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableViewComments.dequeueReusableHeaderFooterViewWithIdentifier("CurrentStandImgCellHeader") as! CurrentStandImgCellHeader
        
        cell.addBtn.addTarget(self, action: #selector(addCommentBtn(_:)), forControlEvents: .TouchUpInside)
        
        if tableView.tag == 1
        {
            cell.commentsLabel.hidden = true
            cell.addBtn.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
//        return UITableViewAutomaticDimension
        if tableView.tag == 1
        {
            if itemType == "ques_poll"
            {
                return 55.0
            }
            else
            {
                return 126.0
            }
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView.tag == 1
        {
            return 0.0
        }
        else
        {
            return 50.0
        }
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 50.0//UITableViewAutomaticDimension
//    }
    
    //MARK:- UIScrollViewDelegates
    func scrollViewDidScroll(scrollView: UIScrollView)
    {   //536 330
        if itemType == "ques_poll"
        {
            tableViewHt.constant = CGFloat(options.count) * 55
        }
        else
        {
            tableViewHt.constant = CGFloat(options.count) * 126
        }
        
        tableViewCommentsHt.constant = (CGFloat(comments.count) * 82) + 50
        
        let ht = CGFloat(450) + tableViewHt.constant + tableViewCommentsHt.constant
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: ht)
        
        //        print(scrollView.contentSize)
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
    
    @IBAction func addCmntBtn(sender: AnyObject)
    {
//        print("add btn pressed in view")
        addCommentView.hidden = true
        if !commentTextView.text.isEmpty
        {
            addCommentDetails()
            //TODO:- refresh the comments tableview
            getCommentDetails()
            HideLoader()
        }
        else
        {
            doalertView("Error", msgs: "Pls add a comment")
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
    
    func getlistOfComments(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/listOfComments"
        
        let parameter = ["postId": itemID]
        
        Alamofire.request(.GET, URL, headers: header, parameters: parameter, encoding: .URL)
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
    
    func addComments(completionHandler : (NSDictionary?, NSData?, NSError?) -> Void)
    {
        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token")
        //print(toks)
        
        let header = ["Authorization": toks as! String]
        //print(header)
        
        let URL = "http://vyooha.cloudapp.net:1337/addComment"
        
        let parameter = ["postId": itemID,
                         "postType": itemType,
                         "comment": commentTextView.text!]
        
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
                        print(self.votes)
                        
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
//                            self.totPartstr = self.totalParts.text!
                        self.totPart = json["data"]["item"]["participants"].int!
//                            print("Total:- \(self.totPart)")
                        self.pieInsideView.hidden = false
                        
                        self.setChart(self.options, values: self.votes)
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
                //                    print(error)
                self.doDBalertView("Error", msgs: (error?.localizedDescription)!)
            }
        }
    }
    
    func getCommentDetails()
    {
        self.StartLoader()
        
        getlistOfComments()
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
                        let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        
                        self.comments = responseObject["data"]!["comments"]!!.mutableCopy() as! NSMutableArray
                        print (self.comments)
                    
                    }
                    catch
                    {
                        print("error in responseObject")
                    }
                    self.tableViewComments.reloadData()
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
    
    func addCommentDetails()
    {
        self.StartLoader()
        
        addComments()
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
                    print(messages)
                }
                else
                {
//                    do
//                    {
//                        
//                    }
//                    catch
//                    {
//                        print("error in responseObject")
//                    }
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
//        pieChart.highlightPerTapEnabled = false
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
        
        //TODO:- check slice space arrown n text colors
        pieChartDataSet.sliceSpace = 2.0
        
//        pieChartDataSet.valueLinePart1OffsetPercentage = 0.8
//        pieChartDataSet.valueLinePart1Length = 0.2
//        pieChartDataSet.valueLinePart2Length = 0.4
//        //dataSet.xValuePosition = .OutsideSlice
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
        
        pieChartData.highlightEnabled = true
        
        pieChart.data = pieChartData
        
    }
    
    func addCommentBtn(sender: UIButton)
    {
//        print("add btn pressed")
        addCommentView.hidden = false
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