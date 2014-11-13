//
//  main.m
//  Tester2
//
//  Created by Hoon H. on 11/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EonilFileSystemEvents.h"

static	EonilFileSystemEventStream*	s1	=	nil;

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		dispatch_semaphore_t	sema1	=	dispatch_semaphore_create(0);
		dispatch_queue_t		q1		=	dispatch_queue_create("AAA", DISPATCH_QUEUE_SERIAL);

		s1	=	[[EonilFileSystemEventStream alloc] initWithCallback:^(NSArray *events) {
			NSLog(@"%@", events);

//			dispatch_semaphore_signal(sema1);
		} pathsToWatch:@[@"/Users/Eonil/Documents", @"/Users/Eonil/Temp"] latency:1 watchRoot:YES queue:q1];

		dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
	}
    return 0;
}

//void test1() {
//
//	dispatch_queue_t		q1		=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
//	dispatch_semaphore_t	sema1	=	dispatch_semaphore_create(0);
//
//	EonilFileSystemEventstream*	s1	=	[[EonilFileSystemEventstream alloc] initWithAllocator:NULL callback:^(ConstFSEventStreamRef stream, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags *eventFlags, const FSEventStreamEventId *eventIds) {
//		NSArray*	a1	=	(__bridge NSArray*)eventPaths;
//		NSLog(@"%@", a1);
//
//		[s1 stop];
//		[s1 invalidate];
//		dispatch_semaphore_signal(sema1);
//	} pathsToWatch:@[@"/Users/Eonil/Temp"] sinceWhen:(kFSEventStreamEventIdSinceNow) latency:(1) flags:(kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes)];
//
//	[s1 setDispatchQueue:q1];
//	[s1 start];
//	dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
//}
//void test2() {
//	dispatch_queue_t		q1		=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
//	dispatch_semaphore_t	sema1	=	dispatch_semaphore_create(0);
//	
//	EonilFileSystemEventStream*	s1	=	[[EonilFileSystemEventStream alloc] initWithCallback:^(NSArray *events) {
//		NSLog(@"%@", events);
//		dispatch_semaphore_signal(sema1);
//	} pathsToWatch:@[@"/Users/Eonil/Temp"] watchRoot:YES queue:q1];
//	
//	NSLog(@"%@", s1);
//	dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
//}

