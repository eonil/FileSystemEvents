README
======
2014/11/13
Hoon H.

Provides dead-simple access to `FSEvents` framework.
Mainly written in Objective-C due to lack of support from Swift.
(lacks some flags, lacks C-callback function) 





How To Use
----------

Here's example code which waits for first event, print it and quits.

````objc

	dispatch_queue_t		q1		=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
	dispatch_semaphore_t	sema1	=	dispatch_semaphore_create(0);

	EonilFileSystemEventStream*	s1	=	[[EonilFileSystemEventStream alloc] 
		initWithCallback:^(NSArray *events) {
			NSLog(@"%@", events);
			dispatch_semaphore_signal(sema1);
		} pathsToWatch:@[@"/Users/Eonil/Temp"] watchRoot:YES queue:q1];

	NSLog(@"%@", s1);
	dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);

````


Use `EonilFileSystemEventStream` class. Required informations are
all noted as comments. Follows strict Objective-C conventions, so
should be straightforward.
Create it, and monitoring will start immediately. Deallocate it to
stop monitoring. (RAII semantics) Supplied callback block will be
notified on specified event.

You will get useful assertions when you compile in debug mode. 
These kind of assertions are essential in Objective-C to build 
robust program, so I strongly recommend to use debug mode compile
when you are writing up.





Notes
-----
This library has been tested on OSX 10.10 with Xcode 6.1.
Licensed under MIT license.







