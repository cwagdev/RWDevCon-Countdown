//
//  TargetDay.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import Foundation
import CoreData

private let _calendar = NSCalendar.autoupdatingCurrentCalendar()

@objc(TargetDay)
public class TargetDay: NSManagedObject {

    @NSManaged public var date: NSDate
    @NSManaged public var imageData: NSData
    @NSManaged public var name: String

}

public extension TargetDay {
  public var daysUntil: Int {
    let todayComponents = _calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit, fromDate: NSDate())
    let todayMidnight = _calendar.dateFromComponents(todayComponents) ?? NSDate()


    let components = _calendar.components(NSCalendarUnit.DayCalendarUnit, fromDate: todayMidnight, toDate: date, options: nil)
    return components.day
  }
  
  public var image: UIImage {
    get {
      if let image = UIImage(data: imageData) {
        return image
      } else {
        return UIImage.randomColorImage()
      }
    }
    set {
      imageData = UIImageJPEGRepresentation(newValue, 0.8)
    }
  }
}
