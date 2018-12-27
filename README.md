ARCHIVED
=========
As like noted below, this project has been archived, and no longer be maintained.
For new projects, I recommend you to use my new implementation.

- https://github.com/eonil/fsevents-unofficial-wrapper





README
======
2014/11/13
2015/01/17
2015/04/04
2016/09/25
Hoon H.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Provides dead-simple access to `FSEvents` framework for Swift.
Low level core is written in Objective-C due to lack of support from Swift.
(lacks some flags, lacks C-callback function) 





How To Use
----------

First, you need to add this framework to your Xcode project.
If you're not sure how to add this framework to your existing Xcode project, please see this
video posting.

- [A proper way to add a subproject to another Xcode project](http://eonil-observatory.tumblr.com/post/117205738262/a-proper-way-to-add-a-subproject-to-another-xcode)

Here's a minimal example code which waits for events and prints them. This single statement
does everything all needed jobs to setup. Just keep the created object as long as you want
to receive the events.

````swift

	import Cocoa
	import EonilFileSystemEvents

	@NSApplicationMain
	class AppDelegate: NSObject, NSApplicationDelegate {

		@IBOutlet weak var window: NSWindow!
		
		let	s1 = FileSystemEventMonitor(
			pathsToWatch: [
				"~/Documents".stringByExpandingTildeInPath, 
				"~/Temp".stringByExpandingTildeInPath],
			latency: 1,
			watchRoot: true,
			queue: dispatch_get_main_queue()) { (events: [FileSystemEvent])->() in
				println(events)
			}
	}


````

If you want to stop monitoring, just remove all the strong references.


````swift

	var m: FileSystemEventMonitor? = FileSystemEventMonitor( /* arguments omitted */ )
	// Now it started.

	m = nil 
	// Now it stopped. Because it's dead. 

````

Please take care that object reference can be shared in Swift, so you need to ensure no 
other object to reference the monitor object. If you're not familiar with reference-counting, 
please see this: [Automatic Reference Counting](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html)



See `TestdriveApp` target for another fully fledged Swift example. The example app starts
monitoring when it becomes active, and stops monitoring when it becomes inactive. Try it!









Explanation
-----------
Use `FileSystemEventMonitor` class. Required informations are
all noted as comments.
Create it, and monitoring will start immediately. Deallocate it to
stop monitoring. (RAII semantics) Supplied callback block will be
notified on specified event.

Unfortunately, as Swift does not support static library target, you
cannot link this as a library to a command-line programs currently.
So examples had to written as an AppKit application target.

For Objective-C programs, use `EonilFileSystemEventStream` class.
Required informations are all noted as comments. This class follows
strict Objective-C conventions, so should be straightforward.
It is unclear how long I will keep the Objective-C version.





Note
-----
This library requires macOS 10.10 to run and Xcode 8.0 to build.

I also have another version of file-system watcher library.
It's not extensively tested, but you can check it out if you're interested.
This is clean-slated Swift3 implementation with directing binding to C API
without Objective-C stuffs.

- https://github.com/eonil/fsevents-unofficial-wrapper





License
-------
This library is written by Hoon H. and licensed under "MIT License".







