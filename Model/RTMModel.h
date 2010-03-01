//
//  RTMModel.h
//  Latte
//
//  Created by ever.zet on 01.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SQLitePersistentObject.h"


@interface RTMModel : SQLitePersistentObject {
  int       rtmId;
  NSDate*   createdAt;
  NSDate*   updatedAt;
  NSDate*   syncedAt;
  BOOL      isDeleted;
}

@property (nonatomic,readwrite)         int         rtmId;
@property (nonatomic,readwrite,retain)  NSDate*     createdAt;
@property (nonatomic,readwrite,retain)  NSDate*     updatedAt;
@property (nonatomic,readwrite,retain)  NSDate*     syncedAt;
@property (nonatomic,readwrite)         BOOL        isDeleted;

@end
