# 105: App Extensions, Part 4: Challenge Instructions


## Challenge A: Launching the container App
Being that widgets are very simple, one of the common things they might do is launch their containing app in order to provide more information.

For Countdown, currently if there are no timers the widget doesn't show anything which is a bit of a bummer. It would be nice if you could let the user know in some way that the widget isn't broken (because it sure looks like it with a 0 height!) and let them act on it. 

Your challenge is to add a button titled "Add a countdown" to the widget when there are no timers. When the user presses the button it launches the app and takes them to the Add form.

The desired outcome of the widget may look like the following:

![](./4-Challenge-Assets/ChallengeOutcome.png)

Adding a button to the view should be straight forward. But here are some other things to think about before you get started.

1. What will the button do? There are ways to launch apps in iOS using URL Schemes... Maybe start by setting up a URL Scheme for the app? 
	- Hint: When configuring your target there is an Info section. Within there you can add URL Types, only a URL Scheme value is required for this challenge
2. How do you open URLs in iOS? The App Delegate? Does a widget have an App delegate? 
	- Hint: Check out `NSExtensionContext`, does it have an openURL: method? All UIViewController subclasses (remember what TodayViewController is?) have an `extensionContext` property which is `nil` most of the time, but not for widgets.
3. How do you present the Add controller after the URL is handled?
	- Hint: There are some delegate methods that get called in AppDelegate for handling when the app is opened with a URL

## Challenge B: Hiding the widget

Maybe you have a different plan when there are no Countdowns configured. Maybe you'd rather your users not see your widget at all in that scenario.

Good news, there is a way to hide your widget completely when it is not relevant to the user!

This is a quick one, so take a look at the `NCWidgetController`class reference. Consider the API method that it has and determine when it would make sense to call it. 