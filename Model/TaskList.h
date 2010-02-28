//
//  TaskList.h
//  Latte
//
//  Created by ever.zet on 28.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SQLitePersistentObject.h"


@interface TaskList : SQLitePersistentObject {
  NSString* name;
  int       rtmId;
  NSDate*   createdAt;
  NSDate*   updatedAt;
  NSDate*   syncedAt;
  bool      isDeleted;
}

@property (nonatomic,readwrite,retain)  NSString*  name;
@property (nonatomic,readwrite)         int        rtmId;
@property (nonatomic,readwrite,retain)  NSDate*    createdAt;
@property (nonatomic,readwrite,retain)  NSDate*    updatedAt;
@property (nonatomic,readwrite,retain)  NSDate*    syncedAt;
@property (nonatomic,readwrite)         bool       isDeleted;

@end
