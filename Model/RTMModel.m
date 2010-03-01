//
//  RTMModel.m
//  Latte
//
//  Created by ever.zet on 01.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RTMModel.h"


@implementation RTMModel

@synthesize rtmId, createdAt, updatedAt, syncedAt, isDeleted;

- (void)dealloc
{
  [createdAt release];
  [updatedAt release];
  [syncedAt release];
  
  [super dealloc];
}

@end
