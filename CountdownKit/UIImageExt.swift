//
//  UIImageExt.swift
//  Countdown
//
//  Created by Chris Wagner on 12/6/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit

public extension UIImage {
  
  public class func randomColorImage() -> UIImage {
    let goldenRatioConjugate = 0.618033988749895
    var h = Double(arc4random_uniform(100))/100.0
    h += goldenRatioConjugate
    h %= 1
    
    let color = UIColor(hue: CGFloat(h), saturation: 0.5, brightness: 0.95, alpha: 1.0)
    return image(color)
  }
  
  public class func image(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}