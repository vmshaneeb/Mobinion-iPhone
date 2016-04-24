//
//  NewsFeedQR.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 4/21/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class NewsFeedQR: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var QRView: UIView!
    
    var captureSession:AVCaptureSession!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView
        {
            qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
        }
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        captureSession = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        do
        {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch
        {
            // If any error occurs, simply log the description of it and don't continue any more.
            //            print("\(error?.localizedDescription)")
            return
        }
        
        // Set the input device on the capture session.
        if (captureSession.canAddInput(videoInput))
        {
            captureSession.addInput(videoInput)
        }
        else
        {
            failed()
            return
        }
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput))
        {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        else
        {
            failed()
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture
        captureSession.startRunning()
        
        // Move items to top
        self.view.bringSubviewToFront(navBar)
        self.view.bringSubviewToFront(QRView)
        self.view.bringSubviewToFront(qrCodeFrameView)
        
        // Change status bar to white
        let proxyViewForStatusBar : UIView = UIView(frame: CGRectMake(0, 0,self.view.frame.size.width, 20))
        proxyViewForStatusBar.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(proxyViewForStatusBar)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true)
        {
            captureSession.stopRunning();
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- AVCaptureMetadataOutputObjectsDelegates
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        captureSession.stopRunning()
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0
        {
            qrCodeFrameView.frame = CGRectZero
            print("No QR code is detected")
            return
        }
        
        if let metadataObject = metadataObjects.first
        {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            
            if readableObject.type == AVMetadataObjectTypeQRCode
            {
                let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(readableObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                
                qrCodeFrameView.frame = barCodeObject.bounds
                
//                print(qrCodeFrameView)
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                if !readableObject.stringValue.isEmpty
                {
                    foundCode(readableObject.stringValue)
                }
            }
        }
        
//        dismissViewControllerAnimated(true, completion: nil)
    }

    
    //MARK:- Overrides
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return .Portrait
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle
//    {
//        return .Default
//    }
    
    //MARK:- Actions
    @IBAction func enterCode(sender: AnyObject)
    {
        
    }
    
    //MARK:- Custom Functions
    func failed()
    {
        let ac = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                   preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    func foundCode(code: String)
    {
        print(code)
        
        let tok = NSUserDefaults.standardUserDefaults().objectForKey("token")
        
        var toks:String = "JWT "
        
        toks.appendContentsOf(tok as! String)
        
        let header = ["Authorization": toks ]
        
        let URL = "http://vyooha.cloudapp.net:1337/itemDetails"
        
        Alamofire.request(.GET, URL,headers: header, parameters: ["qr": code], encoding: .JSON)
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
    
}
