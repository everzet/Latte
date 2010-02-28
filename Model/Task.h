//
//  Task.h
//  Latte
//
//  Created by ever.zet on 28.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SQLitePersistentObject.h"
#import "TaskList.h"


@interface Task : SQLitePersistentObject {
  NSString* name;
  int       rtmId;
  int       priority;
  TaskList* list;
  NSDate*   dueAt;
  NSDate*   createdAt;
  NSDate*   updatedAt;
  NSDate*   syncedAt;
  bool      isCompleted;
  bool      isDeleted;
}

@property (nonatomic,readwrite,retain)  NSString*   name;
@property (nonatomic,readwrite)         int         rtmId;
@property (nonatomic,readwrite)         int         priority;
@property (nonatomic,readwrite,retain)  TaskList*   list;
@property (nonatomic,readwrite,retain)  NSDate*     dueAt;
@property (nonatomic,readwrite,retain)  NSDate*     createdAt;
@property (nonatomic,readwrite,retain)  NSDate*     updatedAt;
@property (nonatomic,readwrite,retain)  NSDate*     syncedAt;
@property (nonatomic,readwrite)         bool        isCompleted;
@property (nonatomic,readwrite)         bool        isDeleted;

@end
