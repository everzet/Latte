//
//  TaskList.m
//  Latte
//
//  Created by ever.zet on 28.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TaskList.h"


@implementation TaskList

@synthesize name, rtmId, createdAt, updatedAt, syncedAt, isDeleted;

- (void)dealloc
{
  [name release];
  [createdAt release];
  [updatedAt release];
  [syncedAt release];

  [super dealloc];
}

@end
