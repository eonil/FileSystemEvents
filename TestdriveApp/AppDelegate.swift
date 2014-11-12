//
//  AppDelegate.swift
//  TestdriveApp
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa
import EonilFSEvents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet weak var	tableView:NSTableView!
	@IBOutlet weak var	window:NSWindow!

	struct Item {
		let	flags:String
		let	path:String
	}
	
	var	items	=	[] as [Item]
	
	var	monitor	=	nil as EonilFileSystemEventStream?
	
	var	queue	=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		func onEvent(path:String!, flag:EonilFileSystemEventFlag, id:FSEventStreamEventId) -> Void {
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				let	v1	=	flag.rawValue
				var	a1	=	[] as [String]
				for i:UInt32 in 0..<16 {
					let	v2	=	0b01 << i
					let	ok	=	(v2 & v1) > 0
					if ok {
						let	s	=	NSStringFromFSEventStreamEventFlags(v2)!
						a1.append(s)
					}
				}
				
				let	s1	=	join(", ", a1)
				self.items.append(Item(flags: s1, path: path!))
				self.tableView.insertRowsAtIndexes(NSIndexSet(index: self.items.count-1), withAnimation: NSTableViewAnimationOptions.EffectNone)
				self.tableView.scrollToEndOfDocument(self)
			})
		}
		monitor	=	EonilFileSystemEventStream(callback: onEvent, pathsToWatch: ["/"], watchRoot: false, queue: queue)
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

