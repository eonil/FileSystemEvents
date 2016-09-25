//
//  FileSystemEventMonitor.swift
//  EonilFileSystemEvents
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation




/// - parameter events:
///	An array of `FileSystemEvent` objects. Ordered as provided.
public typealias	FileSystemEventMonitorCallback	=	(_ events:[FileSystemEvent])->()
public typealias	FileSystemEventFlag				=	EonilFileSystemEventFlag


/// Tailored for use with Swift.
/// This starts monitoring automatically at creation, and stops at deallocation.
/// This notifies all events immediately on the specified GCD queue.
public final class FileSystemEventMonitor {
	public convenience init(pathsToWatch:[String], callback:@escaping FileSystemEventMonitorCallback) {
		self.init(pathsToWatch: pathsToWatch, latency: 0, watchRoot: true, queue: DispatchQueue.main, callback: callback)
	}
	
	/// Creates a new instance with everything setup and starts immediately.
	///
	/// - parameter callback:
	///				Called when some events notified. See `FileSystemEventMonitorCallback` for details.
	public init(pathsToWatch:[String], latency:TimeInterval, watchRoot:Bool, queue:DispatchQueue, callback:@escaping FileSystemEventMonitorCallback) {
		_queue		=	queue
		_callback	=	callback
		
		let	fs1	=	kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagNoDefer
		let	fs2	=	fs1 | (watchRoot ? kFSEventStreamCreateFlagWatchRoot : 0)
		
        let	cb	=	{ (
            _ stream: ConstFSEventStreamRef?,
            _ numEvents: Int,
            _ eventPaths: UnsafeMutableRawPointer?,
            _ eventFlags: UnsafePointer<FSEventStreamEventFlags>?,
            _ eventIds: UnsafePointer<FSEventStreamEventId>?) -> Void in
                guard numEvents > 0 else { return }
                guard let eventFlags = eventFlags else { return }
                guard let eventIds = eventIds else { return }
                let	ps	=	unsafeBitCast(eventPaths, to: NSArray.self)
                var	a1	=	[] as [FileSystemEvent]
                a1.reserveCapacity(numEvents)
                for i in 0..<Int(numEvents) {
                    let	path	=	ps[i] as! NSString as String
                    let	flag	=	eventFlags[i]
                    let	ID		=	eventIds[i]
                    let	ev		=	FileSystemEvent(path: path, flag: FileSystemEventFlag(rawValue: flag), ID: ID)
                    a1.append(ev)
                }
                callback(a1)
		}

		let	ps2	=	pathsToWatch.map({ $0 as NSString }) as [AnyObject]

		_lowlevel	=	EonilJustFSEventStreamWrapper(
			allocator		:	nil,
			callback		:	cb,
			pathsToWatch	:	ps2,
			sinceWhen		:	FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
			latency			:	CFTimeInterval(latency),
			flags			:	FSEventStreamCreateFlags(fs2))
		
		_lowlevel.setDispatchQueue(_queue)
		_lowlevel.start()
	}
	deinit {
		_lowlevel.stop()
		_lowlevel.invalidate()
	}
	
	public var queue:DispatchQueue {
		get {
			return	_queue
		}
	}
	
	////
	
	fileprivate let	_queue:DispatchQueue
	fileprivate let	_callback:FileSystemEventMonitorCallback
	fileprivate let	_lowlevel:EonilJustFSEventStreamWrapper
}



public struct FileSystemEvent {
	public var	path:String
	public var	flag:FileSystemEventFlag
	public var	ID:FSEventStreamEventId
}




















/// MARK:

extension FileSystemEvent: CustomStringConvertible {
	public var description:String {
		get {
			return	"(path: \(path), flag: \(flag), ID: \(ID))"
		}
	}
}

extension FileSystemEventFlag: CustomStringConvertible {
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

			let	s1	=	a1.joined(separator: ", ")
			return	s1
		}
	}
}








