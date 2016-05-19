//
//  Extensions.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/17/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

extension UIImage
{
    func writeAtPath(path:String) -> Bool
    {
        let result = CGImageWriteToFile(self.CGImage!, filePath: path)
        return result
    }
    
    private func CGImageWriteToFile(image:CGImageRef, filePath:String) -> Bool
    {
        let imageURL:CFURLRef = NSURL(fileURLWithPath: filePath)
        var destination:CGImageDestinationRef? = nil
        
        let ext = (filePath as NSString).pathExtension.uppercaseString
        
        if ext == "JPG" || ext == "JPEG"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeJPEG, 1, nil)
        } else if ext == "PNG" || ext == "PNGF"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypePNG, 1, nil)
        } else if ext == "TIFF" || ext == "TIF"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeTIFF, 1, nil)
        } else if ext == "GIFF" || ext == "GIF"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeGIF, 1, nil)
        } else if ext == "PICT" || ext == "PIC" || ext == "PCT" || ext == "X-PICT" || ext == "X-MACPICT"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypePICT, 1, nil)
        } else if ext == "JP2"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeJPEG2000, 1, nil)
        } else  if ext == "QTIF" || ext == "QIF"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeQuickTimeImage, 1, nil)
        } else  if ext == "ICNS"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeAppleICNS, 1, nil)
        } else  if ext == "BMPF" || ext == "BMP"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeBMP, 1, nil)
        } else  if ext == "ICO"
        {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeICO, 1, nil)
        } else
        {
            fatalError("Did not find any matching path extension to store the image")
        }
        
        if (destination == nil)
        {
            fatalError("Did not find any matching path extension to store the image")
        }
        else
        {
            CGImageDestinationAddImage(destination!, image, nil)
            
            if CGImageDestinationFinalize(destination!)
            {
                return false
            }
            return true
        }
        return true
    }

    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageWithColor(color: UIColor) -> UIImage
    {
        let rect: CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(Hex:Int)
    {
        self.init(red:(Hex >> 16) & 0xff, green:(Hex >> 8) & 0xff, blue:Hex & 0xff)
    }
    
    convenience init(rgba: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#")
        {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                if hex.characters.count == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if hex.characters.count == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                }
                else
                {
                    print("invalid rgb string, length should be 7 or 9", terminator: "")
                }
            }
            else
            {
                print("scan hex error", terminator: "")
            }
        }
        else
        {
            print("invalid rgb string, missing '#' as prefix", terminator: "")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}


