//
//  Task.m
//  Latte
//
//  Created by ever.zet on 28.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Task.h"


@implementation Task

@synthesize name, rtmId, priority, list, dueAt, createdAt, updatedAt, syncedAt, isCompleted, isDeleted;

- (void)dealloc
{
  [name release];
  [list release];
  [dueAt release];
  [createdAt release];
  [updatedAt release];
  [syncedAt release];

  [super dealloc];
}

+ (NSArray*)allCompleted:(NSNumber*)isCompleted inList:(TaskList*)list
{
  return [Task findByCriteria:[NSString stringWithFormat:@"WHERE list = %d AND is_completed = %d", list.pk, isCompleted]];
}

- (NSString*)displayableDue
{
  NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormatter setDateStyle: NSDateFormatterShortStyle];

  return [dateFormatter stringFromDate:dueAt];
}

@end
