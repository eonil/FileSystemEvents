//
//  EonilFileSystemEventsTests.m
//  EonilFileSystemEventsTests
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <EonilFileSystemEvents/EonilFileSystemEvents.h>

@interface EonilFileSystemEventsTests : XCTestCase

@end

@implementation EonilFileSystemEventsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)testStream1 {
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
}
- (void)testStream2 {
	dispatch_queue_t		q1		=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
	dispatch_semaphore_t	sema1	=	dispatch_semaphore_create(0);
	
	EonilFileSystemEventStream*	s1	=	[[EonilFileSystemEventStream alloc] initWithCallback:^(NSArray *events) {
		NSLog(@"%@", events);
		dispatch_semaphore_signal(sema1);
	} pathsToWatch:@[@"/Users/Eonil/Temp"] watchRoot:YES queue:q1];
	
	NSLog(@"%@", s1);
	dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
}

@end



















