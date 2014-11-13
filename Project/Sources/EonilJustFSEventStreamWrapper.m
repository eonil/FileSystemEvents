//
//  Stream.m
//  EonilFileSystemEvents
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import "EonilJustFSEventStreamWrapper.h"


static void
TheFSEventStreamCallback(ConstFSEventStreamRef streamRef,
						 void *clientCallBackInfo,
						 size_t numEvents,
						 void *eventPaths,
						 const FSEventStreamEventFlags eventFlags[],
						 const FSEventStreamEventId eventIds[]
						 );



static inline BOOL isArrayOfString(NSArray* a) {
	for (NSObject* s in a) {
		if ([s isKindOfClass:[NSString class]] == NO) {
			return	NO;
		}
	}
	return	YES;
}



@implementation EonilJustFSEventStreamWrapper {
	FSEventStreamRef			_raw;
	EonilJustFSEventStreamWrapperCallback	_callback;
}
- (FSEventStreamRef)raw {
	return	_raw;
}
- (EonilJustFSEventStreamWrapperCallback)callback {
	return	_callback;
}
- (instancetype)initWithAllocator:(CFAllocatorRef)allocator
						 callback:(EonilJustFSEventStreamWrapperCallback)callback
					 pathsToWatch:(NSArray*)pathsToWatch
						sinceWhen:(FSEventStreamEventId)sinceWhen
						  latency:(CFTimeInterval)latency
							flags:(FSEventStreamCreateFlags)flags {

	////
	
	NSAssert(callback != nil, @"Parameter `callback` shouldn't be `nil`.");
	NSAssert([pathsToWatch isKindOfClass:[NSArray class]], @"Parameter `pathsToWatch` must be an array.");
	NSAssert(isArrayOfString(pathsToWatch), @"Parameter `pathsToWatch` must be an array of `NSString`.");
	
	////
	
	self	=	[super init];
	if (self) {
		FSEventStreamContext	ctx1	=	{0};
		ctx1.info				=	(__bridge void*)self;
		ctx1.copyDescription	=	NULL;
		ctx1.release			=	NULL;
		ctx1.retain				=	NULL;
		ctx1.version			=	0;
		
		_raw			=	FSEventStreamCreate(NULL, &TheFSEventStreamCallback, &ctx1, (__bridge CFArrayRef)pathsToWatch, sinceWhen, latency, flags);
		_callback		=	callback;
		
		if (_raw == nil) {
			@throw [NSException exceptionWithName:@"EonilFileSystemEvents" reason:@"Could not create a `FSEventStreamRef` object instance. Reason unknown." userInfo:nil];
		}
	}
	return	self;
}
- (void)dealloc {
	FSEventStreamRelease(_raw);
}



static void
TheFSEventStreamCallback(ConstFSEventStreamRef streamRef,
						 void *clientCallBackInfo,
						 size_t numEvents,
						 void *eventPaths,
						 const FSEventStreamEventFlags eventFlags[],
						 const FSEventStreamEventId eventIds[]
						 ) {
	////
	
	EonilJustFSEventStreamWrapper*	self	=	(__bridge EonilJustFSEventStreamWrapper*)clientCallBackInfo;
	self->_callback(streamRef, numEvents, eventPaths, eventFlags, eventIds);
}




- (void)flushAsync {
	FSEventStreamFlushAsync(_raw);
}
- (void)flushSync {
	FSEventStreamFlushSync(_raw);
}
- (dev_t)deviceBeingWatched {
	return	FSEventStreamGetDeviceBeingWatched(_raw);
}
- (FSEventStreamEventId)latestEventId {
	return	FSEventStreamGetLatestEventId(_raw);
}
- (void)invalidate {
	FSEventStreamInvalidate(_raw);
}
- (void)scheduleWithRunLoop:(CFRunLoopRef)runLoop runLoopMode:(CFStringRef)runLoopMode {
	FSEventStreamScheduleWithRunLoop(_raw, runLoop, runLoopMode);
}
- (void)setDispatchQueue:(dispatch_queue_t)q {
	FSEventStreamSetDispatchQueue(_raw, q);
}
- (void)start {
	FSEventStreamStart(_raw);
}
- (void)stop {
	FSEventStreamStop(_raw);
}
- (void)unscheduleFromRunLoop:(CFRunLoopRef)runLoop runLoopMode:(CFStringRef)runLoopMode {
	FSEventStreamUnscheduleFromRunLoop(_raw, runLoop, runLoopMode);
}


- (void)show {
	FSEventStreamShow(_raw);
}
@end












