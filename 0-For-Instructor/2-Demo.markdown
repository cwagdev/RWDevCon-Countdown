# 105: App Extensions, Part 2: Demo Instructions

**Complete this Demo using the simulator. The Lab portion of the session will address necessary steps to get the widget working properly on a device.**

## 1) Build and Run
Let's get familiar with the app. At first launch the app is in an empty state. Tap on the + button at the top right to add a date that you want to count down to. The form is pretty basic, fill in a name, select a date (ideally something in the future) and choose an image.

By default the iOS simulator includes a few pictures that you can use. If you want to get more creative you can use Safari to download and save images to use. But let's not get too distracted for now :] The app will generate a random color for the timer if you do not pick an image. Countdowns cannot be edited but you can delete them by swiping it to the left, then recreate your timer.

## 2) Code Walk
Now that you've seen the app in action, let's take a moment to walk through some of the source code to understand what is happening under the hood.

1. ViewController.swift
2. CoreDataController.swift
3. TargetDay.swift
4. AddViewController.swift
5. UIImageExt.swift

## 3) Setup Shared Framework

Ok, now that we've seen how the app works it is time to build a Today Extension aka Widget so that we can view our count downs from Notification Center!

In order to do things efficiently and not repeat ourselves by writing the same logic twice, we will need to bundle up some of the classes we just talked about into a shared framework so that both the App target and Extension target can share code and the database model. 

1. With the project open in Xcode, point to **File > New > Target** 
2. Choose **Framework & Library** beneath the **iOS** group on the left side of the window
3. Select **Cocoa Touch Framework** and click **Next**
4. Fill out the options with the following values
	- Product Name: **CountdownKit**
	- Company Name: **Anything**
	- Organization Identifier: Any reverse domain value, I'll use **com.raywenderlich**
	- Language: **Swift**
	- Project: **Countdown**
	- Embed in Application: **Countdown**
5. Click **Finish**

You've now added a new target that builds a custom framework that both the App target and eventual Extension target will link to. Time to add some things to the framework.

Luckily the developer of this app wrote things in a modular way, so there are a few classes that we can extract into the framework and get up to speed quickly. 

1. Select the following files
	- CoreDataController.swift
	- Model.xcdatamodeld
	- TargetDay.swift
	- TargetDayCell.swift
	- UIImageExt.swift
2. Drag them into the CountdownKit group
3. Once the files are dragged in, select
	- CoreDataController.swift
	- TargetDay.swift
	- TargetDayCell.swift
	- UIImageExt.swift
4. Set their Target Membership to CountdownKit and remove them from Countdown
5. Then individually select **Model.xcdatamodeld** and set it's Target Membership to the CountdownKit target as well, but this time leave Countdown selected. 

Now when you try to build the project you will get a lot of errors about unresolved identifiers. You will need to import the CountdownKit framework into the following files by adding 

`import CountdownKit`

1. AddViewController.swift
2. ViewController.swift

You also need to let **Main.storyboard** know that you moved **TargetDayCell.swift** into the CountdownKit framework. 

1. Open **Main.storyboard**
2. Drill down into **Countdown Scene** until you've reached **TargetDay**
3. With the **TargetDay** UITableViewCell selected switch to the Identity Inspector and set Module to **CountdownKit**

## 4) Build and Run

Now that you've got the framework setup, build and run and verify that everything is still working. Great! Your previously added countdown should still be on your list.

## 5) Configure App Group

As discussed in our overview, in order for an app and its extension(s) to share data you must take advantage of App Groups and Shared Containers. This will; require configuring one for your developer account.

1. Select the Countdown Xcode project at the top of the Project Navigator and then the Countdown Target. 
2. On the General tab update the Bundle Identifier to be valid for your developer portal and provisioning profile
3. Switch to the Capabilities tab
4. Locate and enable "App Groups" by flipping the switch to ON
5. Press the `+` button to create a new group. 
6. Your group name must start with `group.` and can then be any reverse domain you choose. But beware, these identifiers are global and only a single developer in the Apple ecosystem can define any given name. So make it unique to your organization. For the demo I will use `group.com.raywenderlich.countdown`
7. After you pick a name and press `OK`, Xcode will communicate with the developer center and register the group. When registration succeeds the group will be selected in the list. 
8. Now you must tell one of the services in CountdownKit about this app group. Open `CoreDataController.swift` and do a text search for `group.com.raywenderlich.countdown` using `⌘+F`
9. Replace `group.com.raywenderlich.countdown` with the name of the group you created.
10. Finally you need to tell the app to use the App Group directory instead of the Application's document directory. Using Xcode's global search `⌘+SHIFT+F` locate `self.applicationDocumentsDirectory`. You should find this on or around like 91 of **CoreDataController.swift**
11. Update the line to read `let url = self.appGroupDirectory.URLByAppendingPathComponent("Countdown.sqlite")`

## 6) Build and Run!

Try things out again, you will notice that any count downs you had configured are now gone. That is because a new database file is being used. If you were in a situation where you needed to keep the database around you would have to write some code to move its location to the Shared Container. There's nothing special in that process, you'd be doing plain ole' file management so we won't be covering that. 

Add a few timers so to populate the database so that your widget can display them once we get to that point. 

## 7) Add Extension Target
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
6. If prompted, choose to Activate the Counting Down scheme

## 8) Build and Run!
The default Xcode template for Today Extensions includes a stubbed out view controller and a storyboard. The storyboard includes a single `UILabel` of "Hello World"

1. From the Scheme selector verify **Counting Down** is selected and click Build and Run
2. Choose **Today** from the App to run picker
3. Switch to the simulator, Xcode does not automatically do this for you when running Today Extensions like it normally does when you run an app (file a radar!)
4. Depending on how quickly you got to the simulator, Notification Center will be open or will open soon and your widget should be visible, if not scroll down a bit to see it
5. You should see the "Hello World" label below the title of your widget "Counting Down" and the App's icon
6. Congrats! You've built a widget, well sort of. Time to make it useful

## 9) Configuring the Extension Target
The widget will be doing a lot of the things that the app already does. So it's a good thing you created the CountdownKit framework. Now you need to link CountdownKit framework to the Counting Down target.

1. Select the Countdown project in Project Navigator
2. Select the Counting Down target
3. With the General tab selected find the "Linked Frameworks and Libraries" section
4. Click the **+** button
5. Add **Countdownkit.framework**
6. You must also configure the Counting Down target so that it can access the App Group you created earlier, switch to the Capabilities tab
7. Turn on App Groups
8. Enable the group that you created previously, for this demo I will use `group.com.raywenderlich.countdown`
9. Your widget also needs to include the Core Data model, every target will need to include this. Open `Model.xcdatamodeld` located in the "CountdownKit" group and set Target Membership to include "Counting Down"

Great! Now the widget will have access to some of the same logic used by the app as well as the App Group.

## 10) Setup the widget interface

In order to keep focused on the unique aspects of widget development we are going to forgo building out the interface. In the same folder as the starter project you will find another folder named **Secret Sauce**. This folder contains **MainInterface.storyboard**. 

1. Delete **MainInterface.storyboard** from the **Counting Down** group in Xcode and choose Move to Trash
2. Drag the storyboard file in from Secret Sauce to the Counting Down, choose to copy the file
3. Open the storyboard and let's take a look at what's going on.

**Note** You will also notice a markdown file in the directory. In the event you want to know how to build the interface step-by-step you will want to take a look at that document back in your hotel room or after the conference. For now we won't have time.

## 9) Implementing TodayViewController.swift

Open `TodayViewController.swift` and import `CountdownKit`

	import CountdownKit

Create an outlet for a table view declared in the storyboard

	@IBOutlet var tableView: UITableView!

Create a variable and assign its value to the target days persisted in Core Data

	var targetDays = CoreDataController.sharedInstance.targetDays

Set `preferredContentSize` in `viewDidLoad()`

	preferredContentSize = CGSizeMake(0, 150)

Implement `widgetMarginInsetsForProposedMarginInsets()`

	func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
	  return UIEdgeInsetsZero
	}

Replace `widgetPerformUpdateWithCompletionHandler()`

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


