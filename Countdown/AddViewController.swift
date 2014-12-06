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
  private var selectedImage: UIImage?
  
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  
  private let datePicker: UIDatePicker = {
    let calendar = NSCalendar.autoupdatingCurrentCalendar()
    let components = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit, fromDate: NSDate())
    let picker = UIDatePicker()
    picker.date = calendar.dateFromComponents(components) ?? NSDate()
    picker.minimumDate = NSDate()
    picker.datePickerMode = .Date
    return picker
  }()
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateTextField.text = dateFormatter.stringFromDate(NSDate())
    dateTextField.inputView = datePicker
    datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: .ValueChanged)
  }
  
  @IBAction func chooseImage(sender: AnyObject) {
    view.endEditing(true)
    let picker = UIImagePickerController()
    picker.sourceType = .SavedPhotosAlbum
    picker.delegate = self
    presentViewController(picker, animated: true, completion: nil)
  }
  
  @IBAction func save(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
    let targetDay = CoreDataController.sharedInstance.newTargetDay()
    targetDay.name = nameTextField.text
    targetDay.date = datePicker.date
    if let image = selectedImage {
      targetDay.image = image
    } else {
      targetDay.image = UIImage.randomColorImage()
    }
    delegate?.addViewDidSave()
  }
  
  func datePickerValueChanged(picker: UIDatePicker) {
    dateTextField.text = dateFormatter.stringFromDate(datePicker.date)
  }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let selectedImage = info[UIImagePickerControllerOriginalImage] as UIImage
    dismissViewControllerAnimated(true, completion: nil)
    self.selectedImage = selectedImage
    imageView.image = selectedImage
    
  }
}
