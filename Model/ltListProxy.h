//
//  LTListCollection.h
//  Latte
//
//  Created by ever.zet on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EZSQLite.h"
#import "ltListItem.h"


@interface ltListProxy : NSObject {

}

+ (NSArray*)lists;
+ (NSArray*)listsNotSyncedYet;
+ (NSArray*)listsWithSqlQuery:(NSString*)aQuery;
+ (ltListItem*)listWithRtmId:(NSNumber*)anId;
+ (void)deleteListsSyncedBefore:(NSDate*)aDate;

@end
