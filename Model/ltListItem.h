//
//  LTTaskList.h
//  Latte
//
//  Created by ever.zet on 30.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EZSQLite.h"
#import "EZMilk.h"


@interface ltListItem : NSObject {
  NSNumber* dbId;
  NSString* name;
  NSNumber* rtmId;
  NSDate*   created;
  NSDate*   updated;
  NSDate*   synced;
  NSDate*   deleted;
}

@property (retain) NSNumber* dbId;
@property (retain) NSString* name;
@property (retain) NSNumber* rtmId;
@property (retain) NSDate* created;
@property (retain) NSDate* updated;
@property (retain) NSDate* synced;
@property (retain) NSDate* deleted;

- (id)initWithId:(NSNumber*)anId;
- (id)initWithDbData:(NSDictionary*)aData;

- (BOOL)isDeleted;

- (void)save;
- (void)saveWithSyncDate:(NSDate*)aSyncDate;
- (void)delete;

@end
