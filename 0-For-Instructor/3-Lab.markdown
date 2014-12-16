# 105: App Extensions, Part 3: Lab Instructions

**Complete this Lab using the simulator. The last section of the lab will address necessary steps to get the widget working properly on a device.**

At this point you have a pretty functional widget. You can view up to three count downs. If there are more than three in the app you will only see the ones with the least days remaining.

There are however three things that the widget could feature to look better and run properly on a device:

1. The widget is bigger than it needs to be when there are `0...2` timers. 
2. The app provides a nicer experience. You get to see a picture that you selected to represent your countdown! It would be great to be able to see the pictures in the widget as well.
3. The widget barely if ever works on a device! What gives? Memory constraints are tight for widgets. You must take this into consideration when building them.

## Don't be taller than necessary

If you recall, in `viewDidLoad` you set the widget's `preferredContentSize` property. At anytime you can change the size and Notification Center will expand or contract the widget! This can be useful for having a "Show All" button like Apple does with the Stocks widget. 

For the purpose of this widget you will determine how many countdown timers are configured and change the widget size to show at most three. Each row of the table view is 50 points high, so some simple math will do.

Add a new private method to `TodayViewController.swift` called `calculatePreferredSize`

	private func calculatePreferredSize() {
	  preferredContentSize = CGSize(width: 0, height: CGFloat(min(targetDays.count * 50, 150)))
	}


This method sets the `preferredContentSize` variable to be anywhere from 0 points high to 150 points high. The `min()` function ensures that the height is capped to 150 points. 

You will also notice that the width is set to 0. The width you provide is ignored and overridden to be the width of Notification Center, so using any value you prefer here is acceptable. 

If you want to affect the width of your widget, you should provide margin insets by overriding `widgetMarginInsetsForProposedMarginInsets`. For this design having no margin looks best so it was set to 0's all the way around in the demo.

Now, update `viewDidLoad` to call this new method.

	override func viewDidLoad() {
	  super.viewDidLoad()
	
	  calculatePreferredSize()
	}

Build and run the widget to see the effect. Switch to the app and add/remove timers to test that each height configuration works as expected. 

## Show me my pictures!

Now that you can resize the widget as you please, it's time to show those pictures that you painstakingly picked out. The approach that will be taken is when a user taps on a timer, that cell will expand and reveal its picture. The widget will still only ever be 150 points tall but it will give a good glimpse in a real "widgety" way. Tapping the cell again will contract back down to 50 points tall to hide the picture. 

In order to keep track of what cell has been expanded, create a variable to capture its index path in `TodayViewController.swift`

	private var expandedIndexPath: NSIndexPath?

This variable is optional because sometimes and by default there won't be any expanded cells. 

Update the `calculatePreferredSize` method.

	private func calculatePreferredSize() {
	  if expandedIndexPath == nil {
    preferredContentSize = CGSize(width: 0, height: CGFloat(min(targetDays.count * 50, 150)))
	  } else {
	    preferredContentSize = CGSize(width: 0, height: 150)
	  }
	}

This method now takes into consideration your new variable. If the variable is set the content size will be 150 points height regardless of the number of timers configured. 

Next up, implement `tableView(tableView:heightForRowAtIndexPath:)` in the class extension that conforms to the `UITableViewDataSource` and  `UITableViewDelegate` protocols. 

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
	  if let expandedIndexPath = expandedIndexPath {
        if indexPath.compare(expandedIndexPath) == .OrderedSame {
        	return 150
        }
	  }
  
	  return 50
	}

Now it is possible that some cells will be different heights than others. In your case, only one cell will ever be taller, the expanded cell. If your variable is set and it is equal to the index path being passed in, return `150` for the height. Otherwise the standard of `50`. 

Next you need to handle when the user taps on a row to expand it, implement `tableView(tableView: didSelectRowAtIndexPath:)`

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	  let cell = tableView.cellForRowAtIndexPath(indexPath) as TargetDayCell
	  // 1
	  if let expandedIndexPath = expandedIndexPath {
	    // 2
	    if indexPath.compare(expandedIndexPath) == .OrderedSame {
	      self.expandedIndexPath = nil
	    } else {
	      self.expandedIndexPath = indexPath
	    }
	  } else {
    	// 3
    	self.expandedIndexPath = indexPath
	  }
	  
	  // 4
	  calculatePreferredSize()
	  tableView.beginUpdates()
	  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	  tableView.endUpdates()
  
	  // 5
	  if expandedIndexPath == nil {
    	tableView.setContentOffset(CGPointZero, animated: true)
	  } else {
    	tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
	  }
	}

The following describes the implementation:

1. If we are already tracking an expanded cell
2. And the cell is the current cell, it should be collapsed, set the reference to `nil`. Otherwise, set it as the newly expanded cell
3. If no cell was being tracked as expanded, set the current cell as expanded
4. Calculate the preferred size of the widget based on the new information and update the table so that the height changes take affect
5. If there is no cell expanded, scroll to the top of the tableview, otherwise scroll to the expanded cell

Build and Run.

![](./3-Lab-Assets/WidgetShowsPictures.png)

Now your widget shows the pictures!

## Be efficient

At this point if you tried to run the widget on a device you would get varying results. In some instances it may work, but depending on your pictures it may fail to load entirely or crash often. 

When a widget crashes it is a very strange user experience. It is not as noticeable as an app crashing and makes it feel flat out broken. It is important to keep your widget's memory footprint low so that this does not occur. 

Currently the widget is display every timer's picture and it is blurred out using the iOS 7 glass look. This is expensive as far as memory is concerned. So to resolve the issue you are only going to show images if the cell is expanded. If the cell is collapsed than an average color of the selected image will be computed and used. 

First you need a way to hide the image from the `TargetDayCell` when it is in the collapsed state. Open `TargetDayCell.swift` and add the following computed property and setter. 

	public var imageHidden: Bool {
      get {
        return dayImageView.image == nil
      }
      set {
        if newValue == true {
          dayImageView.image = targetDay?.image.averageColorImage()
        } else {
          dayImageView.image = targetDay?.reducedImage
        }
      }
	}

Now build the project so that the CountdownKit framework is compiled and this new property is visible to the Counting Down target. You do not need to run, just use `⌘+B` to build the target.

This is a `Bool` whose getter returns `true` or `false` depending on if the cell's `dayImageView.image` property is `nil`. The setter is the interesting part, when you set this property to `true` it sets the `dayImageView.image` property to an image that is the computed average color of the `targetDay` image. Otherwise it will set the image back to the `reducedImage`. 

Now it is time to take advantage of the new `imageHidden` property on the cell.  Jump back to `TodayViewController.swift` and update the `tableView(tableView:cellForRowAtIndexPath:)` method

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
	  let cell = tableView.dequeueReusableCellWithIdentifier("TargetDay") as TargetDayCell
	  let targetDay = targetDays[indexPath.row]
	  cell.targetDay = targetDay
	  // 1
	  if let expandedIndexPath = expandedIndexPath {
        if indexPath.compare(expandedIndexPath) == .OrderedSame {
          // 2
          cell.imageHidden = false
        }
	  } else {
        // 3
        cell.imageHidden = true
	  }
	  return cell
	}

The differences in this implementation are marked by the 1, 2 and 3 comments:

1. If there is an expanded cell and it is the current cell
2. Reveal the image
3. Otherwise hide the image

Then finally, update the  `didReceiveMemoryWarning` implementation

	override func didReceiveMemoryWarning() {
	  for cell in tableView.visibleCells() as [TargetDayCell] {
	    cell.imageHidden = true
	  }
	}

Now if the widget receives a memory warning all of the images will be hidden in an attempt to free some up. 

Build and run to see the results

![](./3-Lab-Assets/WidgetShowsPictures.png)  ![](./3-Lab-Assets/WidgetAverageColorImage.png)

You can tell that the image is not being seen through the glass view when you compare the images side by side. Rather the average color is computed and displayed as low memory usage image. Using this image helps considerably when there are three countdowns in the widget. 



