//
//  FileSystemEventMonitor.swift
//  EonilFileSystemEvents
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation



///	:param:			events
///					An array of `FileSystemEvent` objects. Ordered as provided.
public typealias	FileSystemEventMonitorCallback	=	(events:[FileSystemEvent])->()
public typealias	FileSystemEventFlag				=	EonilFileSystemEventFlag


///	Tailored for use with Swift.
///	This starts monitoring automatically at creation, and stops at deallocation.
///	This notifies all events immediately on the specified GCD queue.
public final class FileSystemEventMonitor {
	public convenience init(pathsToWatch:[String], callback:FileSystemEventMonitorCallback) {
		self.init(pathsToWatch: pathsToWatch, latency: 0, watchRoot: true, queue: dispatch_get_main_queue(), callback: callback)
	}
	
	///	Creates a new instance with everything setup and starts immediately.
	///
	///	:param:		callback		
	///				Called when some events notified. See `FileSystemEventMonitorCallback` for details.
	public init(pathsToWatch:[String], latency:NSTimeInterval, watchRoot:Bool, queue:dispatch_queue_t, callback:FileSystemEventMonitorCallback) {
		_queue		=	queue
		_callback	=	callback
		
		let	fs1	=	kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagNoDefer
		let	fs2	=	fs1 | (watchRoot ? kFSEventStreamCreateFlagWatchRoot : 0)
		
		let	cb	=	{ (stream:ConstFSEventStreamRef, numEvents:Int, eventPaths:UnsafeMutablePointer<Void>, eventFlags:UnsafePointer<FSEventStreamEventFlags>, eventIds:UnsafePointer<FSEventStreamEventId>) -> Void in
			let	ps	=	unsafeBitCast(eventPaths, NSArray.self)
			var	a1	=	[] as [FileSystemEvent]
			a1.reserveCapacity(numEvents)
			for i in 0..<Int(numEvents) {
				let	path	=	ps[i] as! NSString as String
				let	flag	=	eventFlags[i]
				let	ID		=	eventIds[i]
				let	ev		=	FileSystemEvent(path: path, flag: FileSystemEventFlag(flag), ID: ID)
				a1.append(ev)
				callback(events: a1)
			}
		}
		
		let	ps2	=	pathsToWatch.map({ $0 as NSString }) as [AnyObject]
		
		_lowlevel	=	EonilJustFSEventStreamWrapper(
			allocator		:	nil,
			callback		:	cb,
			pathsToWatch	:	ps2,
			sinceWhen		:	FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
			latency			:	CFTimeInterval(latency),
			flags			:	FSEventStreamCreateFlags(fs2))
		
		EonilFileSystemEventFlag.UserDropped
		_lowlevel.setDispatchQueue(_queue)
		_lowlevel.start()
	}
	deinit {
		_lowlevel.stop()
		_lowlevel.invalidate()
	}
	
	public var queue:dispatch_queue_t {
		get {
			return	_queue
		}
	}
	
	////
	
	private let	_queue:dispatch_queue_t
	private let	_callback:FileSystemEventMonitorCallback
	private let	_lowlevel:EonilJustFSEventStreamWrapper
}



public struct FileSystemEvent {
	public var	path:String
	public var	flag:FileSystemEventFlag
	public var	ID:FSEventStreamEventId
}




















///	MARK:

extension FileSystemEvent: Printable {
	public var description:String {
		get {
			return	"(path: \(path), flag: \(flag), ID: \(ID))"
		}
	}
}

extension FileSystemEventFlag: Printable {
	public var description:String {
		get {
			let	v1	=	self.rawValue
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
			return	s1
		}
	}
}








