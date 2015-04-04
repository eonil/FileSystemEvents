//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "EonilJustFSEventStreamWrapper.h"
#import "EonilFileSystemEventStream.h"

inline NSArray*
GetArray(void* p) {
	return	(__bridge NSArray*)p;
}

