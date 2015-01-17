//
//  AppDelegate.swift
//  TestdriveApp
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa
import EonilFileSystemEvents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet weak var	tableView:NSTableView!
	@IBOutlet weak var	window:NSWindow!

	struct Item {
		let	flags:String
		let	path:String
	}
	
	var	items	=	[] as [Item]
	var	monitor	=	nil as FileSystemEventMonitor?
	var	queue	=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
		
		/////////////////////////////////////////////////////////////////
		//	Here's the core of example.
		/////////////////////////////////////////////////////////////////
		let	onEvents	=	{ (events:[FileSystemEvent]) -> () in
			dispatch_async(dispatch_get_main_queue()) {
				self.items.append(Item(flags: "----", path: "----"))	//	Visual separator.
				self.tableView.insertRowsAtIndexes(NSIndexSet(index: self.items.count-1), withAnimation: NSTableViewAnimationOptions.EffectNone)
				
				for ev in events {
					self.items.append(Item(flags: ev.flag.description, path: ev.path))
					self.tableView.insertRowsAtIndexes(NSIndexSet(index: self.items.count-1), withAnimation: NSTableViewAnimationOptions.EffectNone)
				}
				self.tableView.scrollToEndOfDocument(self)
			}
		}
		
		monitor	=	FileSystemEventMonitor(pathsToWatch: ["/", "/Users"], latency: 0, watchRoot: false, queue: queue, callback: onEvents)
		/////////////////////////////////////////////////////////////////
		//	Here's the core of example.
		/////////////////////////////////////////////////////////////////
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return	items.count
	}
//	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
//		let	m1	=	items[row]
//		switch tableColumn!.identifier {
//			case "TYPE":	return	m1.type
//			case "PATH":	return	m1.path
//			default:		fatalError()
//		}
//	}
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let	tv1	=	NSTextField()
		let	iv1	=	NSImageView()
		let	cv1	=	NSTableCellView()
		cv1.textField	=	tv1
		cv1.imageView	=	iv1
		cv1.addSubview(tv1)
		cv1.addSubview(iv1)
		
		cv1.textField!.bordered			=	false
		cv1.textField!.backgroundColor	=	NSColor.clearColor()
		cv1.textField!.editable			=	false
		(cv1.textField!.cell() as NSCell).lineBreakMode	=	NSLineBreakMode.ByTruncatingHead
		
		let	n1	=	items[row]
		switch tableColumn!.identifier {
		case "PATH":
			iv1.image						=	NSWorkspace.sharedWorkspace().iconForFile(n1.path)
			cv1.textField!.stringValue		=	n1.path
		case "TYPE":
			cv1.textField!.stringValue		=	n1.flags
		default:
			break
		}
		return	cv1
	}
}

