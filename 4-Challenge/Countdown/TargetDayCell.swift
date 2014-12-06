//
//  TargetDayCell.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import CountdownKit

private let numberFormatter: NSNumberFormatter = {
  let formatter = NSNumberFormatter()
  formatter.numberStyle = .DecimalStyle
  return formatter
}()

class TargetDayCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var daysLabel: UILabel!
  @IBOutlet weak var dayImageView: UIImageView!
  
  var targetDay: TargetDay? {
    didSet {
      if let targetDay = targetDay {
        nameLabel.text = targetDay.name
        daysLabel.text = numberFormatter.stringFromNumber(targetDay.daysUntil)
        dayImageView.image = targetDay.image
      }
    }
  }
}
