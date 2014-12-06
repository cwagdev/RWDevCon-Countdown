//
//  CoreDataController.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import Foundation
import CoreData

private let _sharedInstance = CoreDataController()
public class CoreDataController {
  
  public class var sharedInstance: CoreDataController {
    return _sharedInstance
  }
  
  public var targetDays: [TargetDay] {
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    let fetchRequest = NSFetchRequest(entityName: "TargetDay")
    fetchRequest.sortDescriptors = [sortDescriptor]
    var error: NSError?
    if let targetDays = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) {
      return targetDays as [TargetDay]
    } else {
      return []
    }
  }
  
  public func newTargetDay() -> TargetDay {
    let targetDay = NSEntityDescription.insertNewObjectForEntityForName("TargetDay", inManagedObjectContext: managedObjectContext!) as TargetDay
    
    
    return targetDay
  }
  
  public func delete(targetDay: TargetDay) {
    managedObjectContext?.deleteObject(targetDay)
  }
  
  public func save() {
    var error: NSError?
    if let moc = managedObjectContext {
      if moc.hasChanges && moc.save(&error) == false {
        if let error = error {
          println("Error saving context: \(error)")
        }
      }
    }
  }
  
  private lazy var appGroupDirectory: NSURL = {
    if let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.raywenderlich.countdown") {
      return url
    } else {
      fatalError("Failed to get URL for app group container, check your configuration.")
    }
    }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.appGroupDirectory.URLByAppendingPathComponent("Countdown.sqlite")
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
      coordinator = nil
      // Report any error we got.
      let dict = NSMutableDictionary()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
      error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    }
    
    return coordinator
    }()
  
  private lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext()
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
}