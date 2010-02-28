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

+ (NSArray*)allCompleted:(bool)isCompleted inList:(TaskList*)aList
{
  NSString* criteria = [NSString stringWithFormat:@"WHERE list = '%@-%d' AND is_completed = %d",
                        [aList class], aList.pk, isCompleted];

  return [Task findByCriteria:criteria];
}

+ (NSArray*)allInList:(TaskList*)aList
{
  NSString* criteria = [NSString stringWithFormat:@"WHERE list = '%@-%d'",
                        [aList class], aList.pk];

  return [Task findByCriteria:criteria];
}

- (NSString*)displayableDue
{
  NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormatter setDateStyle: NSDateFormatterShortStyle];

  return [dateFormatter stringFromDate:dueAt];
}

- (id)copyWithZone:(NSZone *)zone
{
  return [self retain];
}

@end
