//
//  LTRtmTaskSync.h
//  Latte
//
//  Created by ever.zet on 09.08.09.
//  Copyright 2009 ever.zet. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ltListProxy.h"
#import "ltTaskProxy.h"
#import "EZMilk.h"


@interface LTRtmTaskSync : NSObject {
  
}

// Main action
+ (void)syncWithRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;

// Retrieve
+ (NSArray*)tasksFromRtm:(EZMilk*)anRtm changedAfter:(NSDate*)aSyncDate;
+ (ltTaskItem*)taskWithRtmData:(NSDictionary*)aData;

// Update
+ (void)deleteTask:(ltTaskItem*)aTask fromRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;
+ (void)updateTask:(ltTaskItem*)rtmTask to:(ltTaskItem*)localTask inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;
+ (ltTaskItem*)createTask:(ltTaskItem*)notSyncedTask inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline;

@end
