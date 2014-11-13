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
