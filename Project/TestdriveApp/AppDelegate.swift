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
final class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet private weak var tableView:NSTableView!
	@IBOutlet private weak var window:NSWindow!

	private struct Item {
        let isSeparator: Bool
		let	flags: String
		let	path: String
	}
	
	private var	items	=	[] as [Item]
	private var	monitor	=	nil as FileSystemEventMonitor?
	private var	queue	=	DispatchQueue.global(qos: DispatchQoS.QoSClass.background)

    private func process(events: [FileSystemEvent]) {
        items.append(Item(isSeparator: true, flags: "", path: "")) // Visual separator.
        tableView.insertRows(at: NSIndexSet(index: self.items.count-1) as IndexSet, withAnimation: [])

        for ev in events {
            items.append(Item(isSeparator: false, flags: ev.flag.description, path: ev.path))
            tableView.insertRows(at: NSIndexSet(index: self.items.count-1) as IndexSet, withAnimation: [])

            // You can filter out specific event like this.
            if ev.flag.contains(.itemModified) {
                print("Modified!: \(ev.path)")
            }
        }
        tableView.scrollToEndOfDocument(self)
    }

    @objc
    @available(*, unavailable)
	func applicationDidFinishLaunching(_ aNotification: Notification) {
        /////////////////////////////////////////////////////////////////
        //	Begin of example core.
        /////////////////////////////////////////////////////////////////
        let	onEvents = { (events:[FileSystemEvent]) -> () in
            DispatchQueue.main.async { [weak self] in self?.process(events: events) }
        }

        monitor = FileSystemEventMonitor(pathsToWatch: ["/", "/Users"], latency: 0, watchRoot: false, queue: queue, callback: onEvents)
        /////////////////////////////////////////////////////////////////
        //	End of example core.
        /////////////////////////////////////////////////////////////////
	}

    @objc
    @available(*, unavailable)
	func applicationWillTerminate(_ aNotification: Notification) {
        monitor = nil
	}

    @objc
    @available(*, unavailable)
	func numberOfRows(in tableView: NSTableView) -> Int {
		return items.count
	}
    @objc
    @available(*, unavailable)
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return items[row].isSeparator == false
    }
    @objc
    @available(*, unavailable)
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
		
		let	n1 = items[row]
		switch tableColumn!.identifier {
		case "PATH":
            if FileManager.default.fileExists(atPath: n1.path) {
                iv1.image = NSWorkspace.shared().icon(forFile: n1.path)
            }
			cv1.textField!.stringValue = n1.path
		case "TYPE":
			cv1.textField!.stringValue = n1.flags
		default:
			break
		}
		return cv1
	}
}

