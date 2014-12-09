/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import NotificationCenter
import CountdownKit

class TodayViewController: UIViewController, NCWidgetProviding {
  
  private var expandedIndexPath: NSIndexPath?
  @IBOutlet weak var tableView: UITableView!
  var targetDays = CoreDataController.sharedInstance.targetDays
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    calculatePreferredSize()
  }
  
  override func didReceiveMemoryWarning() {
    for cell in tableView.visibleCells() as [TargetDayCell] {
      cell.imageHidden = true
    }
  }
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
  }
    
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    targetDays = CoreDataController.sharedInstance.targetDays
    calculatePreferredSize()
    tableView.reloadData()
    completionHandler(NCUpdateResult.NewData)
  }
  
  private func calculatePreferredSize() {
    if expandedIndexPath == nil {
      preferredContentSize = CGSize(width: 0, height: min(targetDays.count * 50, 150))
    } else {
      preferredContentSize = CGSize(width: 0, height: 150)
    }
  }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rowCount = targetDays.count
    
    return rowCount
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if let expandedIndexPath = expandedIndexPath {
      if indexPath.compare(expandedIndexPath) == .OrderedSame {
        return 150
      }
    }
    
    return 50
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TargetDay") as TargetDayCell
    let targetDay = targetDays[indexPath.row]
    cell.targetDay = targetDay
    if let expandedIndexPath = expandedIndexPath {
      if indexPath.compare(expandedIndexPath) == .OrderedSame {
        cell.imageHidden = false
      }
    } else {
      cell.imageHidden = true
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as TargetDayCell
    if let expandedIndexPath = expandedIndexPath {
      if indexPath.compare(expandedIndexPath) == .OrderedSame {
        self.expandedIndexPath = nil
      } else {
        self.expandedIndexPath = indexPath
      }
    } else {
      self.expandedIndexPath = indexPath
    }
    
    calculatePreferredSize()
    tableView.beginUpdates()
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    tableView.endUpdates()
    if expandedIndexPath == nil {
      tableView.setContentOffset(CGPointZero, animated: true)
    } else {
      tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
  }
}
