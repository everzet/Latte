//
//  RTTask.h
//  RTTasks
//
//  Created by ever.zet on 26.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EZSQLite.h"
#import "EZMilk.h"


@interface ltTaskItem : NSObject <NSCopying> {
  NSNumber* dbId;
  NSString* name;
  NSNumber* priority;
  NSDate*   due;
  NSDate*   completed;
  NSNumber* list;
  NSNumber* rtmId;
  NSDate*   created;
  NSDate*   updated;
  NSDate*   synced;
  NSDate*   deleted;
  NSString* listName;
}

- (id)initWithId:(NSNumber*)anId;
- (id)initWithDbData:(NSDictionary*)aData;

@property (retain) NSNumber* dbId;
@property (retain) NSString* name;
@property (retain) NSNumber* priority;
@property (retain) NSDate* due;
@property (retain) NSDate* completed;
@property (retain) NSNumber* list;
@property (retain) NSNumber* rtmId;
@property (retain) NSDate* created;
@property (retain) NSDate* updated;
@property (retain) NSDate* synced;
@property (retain) NSDate* deleted;
@property (retain) NSString* listName;

- (NSString*)displayableDue;

- (BOOL)isDeleted;
- (BOOL)isCompleted;

- (void)save;
- (void)delete;

@end
