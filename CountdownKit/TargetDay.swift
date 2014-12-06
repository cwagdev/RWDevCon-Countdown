//
//  TargetDay.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(TargetDay)
public class TargetDay: NSManagedObject {

    @NSManaged public var date: NSDate
    @NSManaged public var image: NSData
    @NSManaged public var name: String

}
