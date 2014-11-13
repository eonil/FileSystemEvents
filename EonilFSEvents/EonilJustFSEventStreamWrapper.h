//
//  Stream.h
//  EonilFileSystemEvents
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	<CoreServices/CoreServices.h>


typedef void(^EonilJustFSEventStreamWrapperCallback)(ConstFSEventStreamRef stream,
										  size_t numEvents,
										  void *eventPaths,
										  const FSEventStreamEventFlags eventFlags[],
										  const FSEventStreamEventId eventIds[]
										  );


/*!
 Just wrapped interface to FSEvents stream.
 Not recommended to use.
 */
@interface EonilJustFSEventStreamWrapper : NSObject
- (FSEventStreamRef)raw;
- (EonilJustFSEventStreamWrapperCallback)callback;
- (instancetype)initWithAllocator:(CFAllocatorRef)allocator
						 callback:(EonilJustFSEventStreamWrapperCallback)callback
					 pathsToWatch:(NSArray*)pathsToWatch
						sinceWhen:(FSEventStreamEventId)sinceWhen
						  latency:(CFTimeInterval)latency
							flags:(FSEventStreamCreateFlags)flags;

- (void)flushAsync;
- (void)flushSync;
- (dev_t)deviceBeingWatched;
- (FSEventStreamEventId)latestEventId;
- (void)invalidate;
- (void)scheduleWithRunLoop:(CFRunLoopRef)runLoop runLoopMode:(CFStringRef)runLoopMode;
- (void)setDispatchQueue:(dispatch_queue_t)q;
- (void)start;
- (void)stop;
- (void)unscheduleFromRunLoop:(CFRunLoopRef)runLoop runLoopMode:(CFStringRef)runLoopMode;

- (void)show;

@end