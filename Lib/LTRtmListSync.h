//
//  LTRtmListSync.h
//  Latte
//
//  Created by ever.zet on 09.08.09.
//  Copyright 2009 ever.zet. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ltListProxy.h"
#import "EZMilk.h"


@interface LTRtmListSync : NSObject {

}

// Main action
+ (void)syncWithRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;

// Retrieve
+ (NSArray*)listsFromRtm:(EZMilk*)anRtm;
+ (ltListItem*)listWithRtmData:(NSDictionary*)rtmData;

// Update
+ (void)deleteList:(ltListItem*)aList fromRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;
+ (void)updateList:(ltListItem*)fromList to:(ltListItem*)toList inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;
+ (ltListItem*)createList:(ltListItem*)notSyncedList inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;

@end
