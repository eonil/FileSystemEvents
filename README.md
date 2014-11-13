README
======
2014/11/13
Hoon H.

Provides dead-simple access to `FSEvents` framework.
Mainly written in Objective-C due to lack of support from Swift.
(lacks some flags, lacks C-callback function) 





How To Use
----------

Here's example code which waits for first event, print it and quits. This single statement
does everything needed to setup.

````objc

	s1	=	[[EonilFileSystemEventStream alloc] initWithCallback:^(NSArray *events) {
		NSLog(@"%@", events);
	} pathsToWatch:@[@"/Users/Eonil/Documents", @"/Users/Eonil/Temp"] latency:1 watchRoot:YES queue:q1];


````

See `TestdriveApp` target for Swift example.

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







