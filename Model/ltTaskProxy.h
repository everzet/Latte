//
//  LTTaskCollection.h
//  Latte
//
//  Created by ever.zet on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EZSQLite.h"
#import "ltListItem.h"
#import "ltTaskItem.h"


@interface ltTaskProxy : NSObject {

}

+ (NSArray*)tasks;
+ (NSArray*)tasksWithList:(ltListItem*)aList completed:(NSNumber*)isCompleted;
+ (NSArray*)tasksNotSyncedYet;
+ (ltTaskItem*)taskWithRtmId:(NSNumber*)anId;
+ (NSArray*)tasksWithSqlQuery:(NSString*)aQuery usingParameters:(NSArray*)aParameters;
+ (NSDate*)lastSyncDate;
+ (NSArray*)deletedSince:(NSDate*)aDeleteDate;

@end
