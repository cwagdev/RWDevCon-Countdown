//
//  TodayViewController.swift
//  Counting Down
//
//  Created by Chris Wagner on 12/15/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import NotificationCenter
import CountdownKit

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var tableView: UITableView!
  
  var targetDays = CoreDataController.sharedInstance.targetDays
  
  override func viewDidLoad() {
    super.viewDidLoad()

    preferredContentSize = CGSizeMake(0, 150)
  }
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    targetDays = CoreDataController.sharedInstance.targetDays
    tableView.reloadData()
    completionHandler(NCUpdateResult.NewData)
  }
  
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rowCount = targetDays.count
    
    return rowCount
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TargetDay") as TargetDayCell
    let targetDay = targetDays[indexPath.row]
    cell.targetDay = targetDay
    return cell
  }
  
}