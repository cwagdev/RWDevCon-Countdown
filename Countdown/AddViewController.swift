//
//  AddViewController.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import CountdownKit

private let dateFormatter: NSDateFormatter = {
  let formatter = NSDateFormatter()
  formatter.dateStyle = NSDateFormatterStyle.MediumStyle
  return formatter
}()

protocol AddViewDelegate {
  func addViewDidSave()
}

class AddViewController: UIViewController {

  var delegate: AddViewDelegate?
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  
  private let datePicker: UIDatePicker = {
    let calendar = NSCalendar.autoupdatingCurrentCalendar()
    let components = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit, fromDate: NSDate())
    let picker = UIDatePicker()
    picker.date = calendar.dateFromComponents(components) ?? NSDate()
    picker.minimumDate = NSDate()
    picker.datePickerMode = .Date
    return picker
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateTextField.text = dateFormatter.stringFromDate(NSDate())
    dateTextField.inputView = datePicker
    datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: .ValueChanged)
  }
  
  @IBAction func save(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
    let targetDay = CoreDataController.sharedInstance.newTargetDay()
    targetDay.name = nameTextField.text
    targetDay.date = datePicker.date
    delegate?.addViewDidSave()
  }
  
  func datePickerValueChanged(picker: UIDatePicker) {
    dateTextField.text = dateFormatter.stringFromDate(datePicker.date)
  }
}
