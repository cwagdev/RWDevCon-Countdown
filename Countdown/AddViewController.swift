//
//  AddViewController.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import CountdownKit

protocol AddViewDelegate {
  func addViewDidSave()
}

class AddViewController: UIViewController {

  var delegate: AddViewDelegate?
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  
  @IBAction func save(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
    let targetDay = CoreDataController.sharedInstance.newTargetDay()
    targetDay.name = "Test"
    targetDay.date = NSDate()
    delegate?.addViewDidSave()
  }
}
