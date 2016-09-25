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
	var	queue	=	DispatchQueue.global(qos: DispatchQoS.QoSClass.background)

	func applicationDidFinishLaunching(_ aNotification: Notification) {
        /////////////////////////////////////////////////////////////////
        //	Here's the core of example.
        /////////////////////////////////////////////////////////////////
        let	onEvents	=	{ (events:[FileSystemEvent]) -> () in
            DispatchQueue.main.async {
                self.items.append(Item(flags: "----", path: "----"))	//	Visual separator.
                self.tableView.insertRows(at: NSIndexSet(index: self.items.count-1) as IndexSet, withAnimation: [])

                for ev in events {
                    self.items.append(Item(flags: ev.flag.description, path: ev.path))
                    self.tableView.insertRows(at: NSIndexSet(index: self.items.count-1) as IndexSet, withAnimation: [])
                }
                self.tableView.scrollToEndOfDocument(self)
            }
        }

        monitor	=	FileSystemEventMonitor(pathsToWatch: ["/", "/Users"], latency: 0, watchRoot: false, queue: queue, callback: onEvents)
        /////////////////////////////////////////////////////////////////
        //	Here's the core of example.
        /////////////////////////////////////////////////////////////////
	}

	func applicationWillTerminate(_ aNotification: Notification) {
        monitor	=	nil
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
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
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let	tv1	=	NSTextField()
		let	iv1	=	NSImageView()
		let	cv1	=	NSTableCellView()
		cv1.textField	=	tv1
		cv1.imageView	=	iv1
		cv1.addSubview(tv1)
		cv1.addSubview(iv1)
		
		cv1.textField!.isBordered		=	false
		cv1.textField!.backgroundColor	=	NSColor.clear
		cv1.textField!.isEditable		=	false
		cv1.textField!.lineBreakMode	=	NSLineBreakMode.byTruncatingHead
		
		let	n1	=	items[row]
		switch tableColumn!.identifier {
		case "PATH":
			iv1.image = NSWorkspace.shared().icon(forFile: n1.path)
			cv1.textField!.stringValue = n1.path
		case "TYPE":
			cv1.textField!.stringValue = n1.flags
		default:
			break
		}
		return	cv1
	}
}

