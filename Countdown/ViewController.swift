//
//  ViewController.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import CountdownKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Add" {
      let addViewController = segue.destinationViewController as AddViewController
      addViewController.delegate = self
    }
  }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CoreDataController.sharedInstance.targetDays.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let targetDay = CoreDataController.sharedInstance.targetDays[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("TargetDay") as TargetDayCell
    cell.targetDay = targetDay
    return cell
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    let targetDay = CoreDataController.sharedInstance.targetDays[indexPath.row]
    CoreDataController.sharedInstance.delete(targetDay)
    tableView.beginUpdates()
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    tableView.endUpdates()
  }
}

extension ViewController: AddViewDelegate {
  func addViewDidSave() {
    tableView.beginUpdates()
    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    tableView.endUpdates()
  }
}