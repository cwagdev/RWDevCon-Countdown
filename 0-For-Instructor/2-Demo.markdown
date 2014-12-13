# 105: App Extensions, Part 2: Demo Instructions

## 1) Configure App Group
As discussed in our overview, in order for an app and its extension(s) to share data you must take advantage of App Groups and Shared Containers. The good news is that the Countdown app is already written to take advantage of App Groups. You just need to configure one for your developer account.

1. Select the Countdown Xcode project at the top of the Project Navigator and then the Countdown Target. 
2. Switch to the Capabilities tab
3. Locate and enable "App Groups" by flipping the switch to ON
4. Press the `+` button to create a new group. 
5. Your group name must start with `group.` and can then be any reverse domain you choose. But beware, these identifiers are global and only a single developer in the Apple ecosystem can define any given name. So make it unique to your organization. For the demo I will use `group.com.raywenderlich.countdown`
6. After you pick a name and press `OK`, Xcode will communicate with the developer center and register the group. When registration succeeds the group will be selected in the list. 
7. Now you must tell one of the services in CountdownKit about this app group. Open `CoreDataController.swift` and do a text search for `group.com.raywenderlich.countdown` using `⌘+F`
8. Replace `group.com.raywenderlich.countdown` with the name of the group you created.

## 2) Build and Run!
This will be the first chance you get to play with the app because it would crash without setting up the App Group. So take it for a spin and add 3 timers.

By default the iOS simulator includes a few pictures that you can use. If you want to get more creative you can use Safari to download and save images to use. But let's not get too distracted for now :] The app will generate a random color for the timer if you do not pick an image. Countdowns cannot be edited but you can delete them by swiping it to the left, then recreate your timer.

## 4) Code Walk
Now that you've seen the app in action, let's take a moment to walk through some of the source code to understand what is happening under the hood.

1. ViewController.swift
2. CoreDataController.swift
3. TargetDay.swift
4. AddViewController.swift

## 5) Add Extension Target
Now it is time to create your Today Extension's target. 

1. Within Xcode point to **File > New Target**
2. From the iOS Group on the left choose **Application Extension**
3. Select **Today Extension** and click Next
4. Use the following values for the new target's options
	- Product Name: **Counting Down**
	- Organization Name: **Anything**
	- Language: **Swift**
	- Project: **Countdown**
	- Embed in Application: **Countdown**
5. Click **Finish**
6. When prompted, choose to Activate the target

## 6) Build and Run!
The default Xcode template for Today Extensions includes a stubbed out view controller and a storyboard. The storyboard includes a single `UILabel` of "Hello World"

1. From the Scheme selector choose **Counting Down** and click Build and Run
2. Switch to the simulator, Xcode does not automatically do this for you when running Today Extensions like it normally does when you run an app (file a radar!)
3. Depending on how quickly you got to the simulator, Notification Center will be open or will open soon and your widget should be visible, if not scroll down a bit to see it
4. You should see the "Hello World" label below the title of your widget "Counting Down" and the App's icon
5. Congrats! You've built a widget, well sort of. Time to make it useful

## 7) Configuring the Extension Target
The widget will need to do a lot of the things that the app already does. Most of that logic is already contained in the CountdownKit framework. To reuse the logic link CountdownKit framework to the Counting Down target.

1. Select the Countdown project in Project Navigator
2. Select the Counting Down target
3. With the General tab selected find the "Linked Frameworks and Libraries" section
4. Click the **+** button
5. Add **Countdownkit.framework**
6. You must also configure the Counting Down target so that it can access the App Group you created earlier, switch to the Capabilities tab
7. Turn on App Groups
8. Enable the group that you created previously, for this demo I will use `group.com.raywenderlich.countdown`
9. Your widget also needs to include the Core Data model, every target will need to include this. Open `Model.xcdatamodeld` and set Target Membership to include "Counting Down"

Great! Now the widget will have access to some of the same logic used by the app as well as the App Group.

## 7) Designing your widget's interface
1. Open **MainInterface.storyboard** located in the "Counting Down" group
2. Delete the Hello World label
3. Select **Today View Controller** in the Document Outline
4. In the Utilities pane switch to the Size Inspector
5. Set the Height property to **150**
6. Drag a **Table View** into the scene (not a Table View Controller)
7. With the table view selected, use Auto-Layout to **pin all sides to 0** and verify that "Constrains to Margins" is turned off and choose **Items of new Constraints** for Update Frames
8. With the Table View selected switch to the Size Inspector and set **Row Height to 50**
8. Drag a **Table View Cell** into your table view
9. Drag an **Image View** into your table view cell
10. With the image view selected, use Auto-Layout to **pin all sides to 0** and verify that "Constrains to Margins" is turned off and choose **Items of new Constraints** for Update Frames
9. Drag a **Visual Effect View with Blur** into your table view cell to sit above the image view
10. With the effect view selected, use Auto-Layout to **pin all sides to 0** and verify that "Constrains to Margins" is turned off and choose **Items of new Constraints** for Update Frames
11. Drag a second **Visual Effect View with Blur** into your table view cell to be a sub view of the previous. To ensure that it is a sub view it will be best to drag the new one to the **View** within the previous view effect view in the Document Outline
12. With the second effect view selected, use Auto-Layout to **pin all sides to 0** and verify that "Constrains to Margins" is turned off and choose **Items of new Constraints** for Update Frames
13. With the second effect view selected, switch to the Attributes Inspector. Set Blur Style to **Dark** and enable **Vibrancy**
13. Drag a label into the view of the second effect view and position it to the left side.  Again you may find it easiest to drag the label to the outline rather than the scene to ensure proper z-index placement as a subview. 
14. Set the label to **Name** and font to **System Bold** at **17 points** and color to **White**.
15. Pin the Name label's **leading space to 8** and set it's **vertical alignment to center in the container** with 0 offset. Using "Update Frames" in the resolve menu to let Xcode properly position the label.
16. With the Name label selected use ⌘+D to duplicate it. Position it to the right of the cell and change it's value to "Days"
17. Pin the Days label's **trailing space to 8** and set it's **vertical alignment to center** in the container with 0 offset. Using "Update Frames" in the resolve menu to let Xcode properly position the label.

At this point your user interface design is finished, but next you need to wire up the dynamic elements. Specifically the table view's delegate and datasource; the image view and both labels.

## 8) Wire up the interface
1. Select "Table View" in the Document Outline and CTRL+Drag to "Today View Controller", release and choose "dataSource" from the menu. Repeat this process and choose "delegate" as well.
2. Now your table view cell needs a custom class so that the labels and image view can be wired up. Fortunately there is already one in the Countdown target named `TargetDayCell.swift`. You can re-use this cell but first you must include it in the Counting Down target as well. But an even better solution would be to include it in the CountdownKit framework. Locate `TargetDayCell.swift` in the Project Navigator
3. Change the Target Membership from "Countdown" to "CountdownKit"  
 ***Note**: You can optionally move the file from the Countdown group to CountdownKit but it is not necessary for things to work. Ideally you'd want your project to be organized so it would make sense to do this "in the real world"*
4. Because you changed the target you need to update the app's storyboard. Open **Main.storyboard**
5. Locate and select **TargetDay** cell in the Document Outline
6. Switch to the Identity Inspector in the Utilities Pane
7. Set Module to **CountdownKit**
8. Now, back to the widget. Open **MainInterface.storyboard**
9. Select **Table View Cell** in the Document Outline
10. From the Identity Inspector set the class to **TargetDayCell**, by default Xcode should pick CountdownKit as the module, if not set it yourself.
11. Switch to Attributes Inspector and set Identifier to **TargetDay**
12. Open the Assistant Editor and verify that `TodayViewController.swift` is opened
13.  Create an outlet for your table view named `tableView`
14. In the Assistant Editor switch to `TargetDayCell.swift`
15. Wire up both labels and the image view
	- Name Label to `nameLabel`
	- Days Label to `daysLabel`
	- Image View to `dayImageView`

![](./2-Demo-Assets/FinalWidgetStoryboard.png)

Great work! Your interface is laid out and wired up! Time to move on to the code.

## 9) Implementing TodayViewController.swift

Open `TodayViewController.swift`

Create a variable and assign its value to the target days persisted in Core Data

	var targetDays = CoreDataController.sharedInstance.targetDays

Set `preferredContentSize` in `viewDidLoad()`

	preferredContentSize = CGSizeMake(0, 150)

Implement `widgetMarginInsetsForProposedMarginInsets()`

	func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
	  return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

Implement `widgetPerformUpdateWithCompletionHandler()`

	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
	  targetDays = CoreDataController.sharedInstance.targetDays
	  tableView.reloadData()
	  completionHandler(NCUpdateResult.NewData)
	}

Create class extension to implement UITableViewDataSource and UITableViewDelegate

	extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
	}

Implement `tableView(tableView:numberOfRowsInSection)`

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	  let rowCount = targetDays.count
  	
	  return rowCount
	}

Implement `tableView(tableView:cellForRowAtIndexPath)`

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
	  let cell = tableView.dequeueReusableCellWithIdentifier("TargetDay") as TargetDayCell
	  let targetDay = targetDays[indexPath.row]
	  cell.targetDay = targetDay
	  return cell
	}

Congratulations! Your widget now shows the same data that is available in your app. The widget is designed to show at most 3 countdown timers. In the lab you will make it so that when you select a row in the widget it shows the image you chose. 


