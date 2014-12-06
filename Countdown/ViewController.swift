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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func add(sender: AnyObject) {
    let targetDay = CoreDataController.sharedInstance.newTargetDay()
    targetDay.name = "Test"
    targetDay.date = NSDate()
    
    
    tableView.reloadData()
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
}
