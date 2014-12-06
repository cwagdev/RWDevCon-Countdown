//
//  TargetDayCell.swift
//  Countdown
//
//  Created by Chris Wagner on 12/5/14.
//  Copyright (c) 2014 Ray Wenderlich LLC. All rights reserved.
//

import UIKit
import CountdownKit

class TargetDayCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var targetDay: TargetDay? {
    didSet {
      if let targetDay = targetDay {
        nameLabel.text = targetDay.name
        dateLabel.text = targetDay.date.description
      }
    }
  }
}
