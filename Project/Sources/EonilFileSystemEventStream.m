//
//  EonilFileSystemEventStream.m
//  EonilFileSystemEvents
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import "EonilFileSystemEventStream.h"
#import "EonilJustFSEventStreamWrapper.h"

@implementation EonilFileSystemEvent
static inline void
EonilSimpleFileSystemEvent_set(EonilFileSystemEvent* self, NSString* path, FSEventStreamEventFlags const flag, FSEventStreamEventId const ID) {
	self->_path	=	[path copy];
	self->_flag	=	flag;
	self->_ID	=	ID;
}
- (NSString *)description {
	return	[NSString stringWithFormat:@"<EonilFileSystemEvent: path = %@, flag = %@, id = %@>", _path, NSStringFromFSEventStreamEventFlags(_flag), @(_ID)];
}
@end







@implementation EonilFileSystemEventStream {
	EonilJustFSEventStreamWrapper*			_lowlevel;
}
- (instancetype)initWithCallback:(EonilFileSystemEventStreamCallback)callback pathsToWatch:(NSArray*)pathsToWatch latency:(NSTimeInterval)latency watchRoot:(BOOL)watchRoot queue:(dispatch_queue_t)queue {
	NSAssert(callback != nil, @"Parameter `callback` shouldn't be `nil`.");
	NSAssert(queue != nil, @"Parameter `queue` must be a `dispatch_queue_t` object instance.");
	
	self	=	[super init];
	if (self) {
		_queue	=	queue;
		
		FSEventStreamCreateFlags	fs1	=	kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagNoDefer;
		if (watchRoot) {
			fs1	|=	kFSEventStreamCreateFlagWatchRoot;
		}

		_lowlevel	=	[[EonilJustFSEventStreamWrapper alloc] initWithAllocator:NULL callback:^(ConstFSEventStreamRef stream, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags *eventFlags, const FSEventStreamEventId *eventIds) {
			NSMutableArray*	a1	=	[[NSMutableArray alloc] initWithCapacity:numEvents];
			NSArray*		ps1	=	(__bridge NSArray*)eventPaths;
			for (size_t i=0; i<numEvents; i++) {
				EonilFileSystemEvent*		ev1	=	[[EonilFileSystemEvent alloc] init];
				EonilSimpleFileSystemEvent_set(ev1, ps1[i], eventFlags[i], eventIds[i]);
				[a1 addObject:ev1];
			}
			callback(a1);
		} pathsToWatch:pathsToWatch sinceWhen:(kFSEventStreamEventIdSinceNow) latency:latency flags:(fs1)];
		
		[_lowlevel setDispatchQueue:_queue];
		[_lowlevel start];
	}
	return	self;
}
- (void)dealloc {
	[_lowlevel stop];
	[_lowlevel invalidate];
}
@end



























NSString*
NSStringFromFSEventStreamEventFlags(FSEventStreamEventFlags flag) {
	switch (flag) {
			
	case kFSEventStreamEventFlagNone:				return	@"None";
	case kFSEventStreamEventFlagMustScanSubDirs:	return	@"MustScanSubDirs";
	case kFSEventStreamEventFlagUserDropped:		return	@"UserDropped";
	case kFSEventStreamEventFlagKernelDropped:		return	@"KernelDropped";
	case kFSEventStreamEventFlagEventIdsWrapped:	return	@"EventIdsWrapped";
	case kFSEventStreamEventFlagHistoryDone:		return	@"HistoryDone";
	case kFSEventStreamEventFlagRootChanged:		return	@"RootChanged";
	case kFSEventStreamEventFlagMount:				return	@"Mount";
	
	case kFSEventStreamEventFlagUnmount:			return	@"Unmount";
	case kFSEventStreamEventFlagItemCreated:		return	@"ItemCreated";
	case kFSEventStreamEventFlagItemRemoved:		return	@"ItemRemoved";
	case kFSEventStreamEventFlagItemInodeMetaMod:	return	@"ItemInodeMetaMod";
	case kFSEventStreamEventFlagItemRenamed:		return	@"ItemRenamed";
	case kFSEventStreamEventFlagItemModified:		return	@"ItemModified";
	case kFSEventStreamEventFlagItemFinderInfoMod:	return	@"ItemFinderInfoMod";
	case kFSEventStreamEventFlagItemChangeOwner:	return	@"ItemChangeOwner";
	case kFSEventStreamEventFlagItemXattrMod:		return	@"ItemXattrMod";
	case kFSEventStreamEventFlagItemIsFile:			return	@"ItemIsFile";
	case kFSEventStreamEventFlagItemIsDir:			return	@"ItemIsDir";
	case kFSEventStreamEventFlagItemIsSymlink:		return	@"ItemIsSymlink";
	case kFSEventStreamEventFlagOwnEvent:			return	@"OwnEvent";
	
	default:	return	@"????";
	}
}
















