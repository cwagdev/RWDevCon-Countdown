//
//  TodayViewController.swift
//  Counting Down
//
//  Created by Chris Wagner on 12/6/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import NotificationCenter
import CountdownKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
      preferredContentSize = CGSize(width: 0, height: 150)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CoreDataController.sharedInstance.targetDays.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TargetDay") as TargetDayCell
    let targetDay = CoreDataController.sharedInstance.targetDays[indexPath.row]
    cell.targetDay = targetDay
    
    return cell
  }
}
