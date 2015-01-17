//
//  AppDelegate.swift
//  InternalTester4
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EonilFileSystemEvents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	
	let	s1		=	FileSystemEventMonitor(
		pathsToWatch: ["~/Documents".stringByExpandingTildeInPath, "~/Temp".stringByExpandingTildeInPath],
		latency: 1,
		watchRoot: true,
		queue: dispatch_get_main_queue()) { (events:[FileSystemEvent])->() in
			println(events)
		}
	
}

