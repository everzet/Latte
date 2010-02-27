//
//  LTTaskCollection.m
//  Latte
//
//  Created by ever.zet on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ltTaskProxy.h"


@implementation ltTaskProxy

+ (NSArray*)tasks
{
  return [self tasksWithList:nil completed:nil];
}

+ (NSArray*)tasksWithList:(ltListItem*)aList completed:(NSNumber*)isCompleted
{
  NSMutableString *where = [[NSMutableString alloc] initWithString:@"where tasks.deleted IS NULL"];
  if (aList != nil)
  {
    [where appendFormat:@" AND list = %d", [[aList dbId] integerValue]];
  }
  if (isCompleted != nil)
  {
    if ([isCompleted boolValue])
    {
      [where appendString:@" AND completed IS NOT NULL"];
    }
    else
    {
      [where appendString:@" AND completed IS NULL"];
    }
  }

  NSMutableString *order = [[NSMutableString alloc] initWithString:@"order by completedSort, prioritySort DESC"];

  NSString* sql = [[NSString alloc] initWithFormat:@"select %@, %@ from tasks, lists %@ and lists.id = tasks.list %@",
                   @"nullif(4 - priority, 4) as prioritySort, (completed IS NOT NULL) as completedSort",
                   @"tasks.*, lists.name as listName",
                   where, order];

  [where release];
  [order release];
  NSLog(sql);

  return [self tasksWithSqlQuery:[sql autorelease] usingParameters:[NSArray array]];
}

+ (NSArray*)tasksNotSyncedYet
{
  return [self tasksWithSqlQuery:@"select * from tasks where deleted is null and rtm_id is null" usingParameters:[NSArray array]];
}

+ (ltTaskItem*)taskWithRtmId:(NSNumber*)anId
{
  EZSQLite* sql = [EZSQLite instance];
  NSString* query = [[NSString alloc] initWithFormat:@"select * from tasks where rtm_id = %d", [anId integerValue]];
  NSArray* dbArray = [sql dataWithQuery:query andParameters:[NSArray array]];
  ltTaskItem* task = nil;

  if ([dbArray count] > 0)
  {
    task = [[ltTaskItem alloc] initWithDbData:[dbArray objectAtIndex:0]];
    [task autorelease];
  }

  [query release];
  return task;
}

+ (NSArray*)tasksWithSqlQuery:(NSString*)aQuery usingParameters:(NSArray*)aParameters
{
  EZSQLite* sql = [EZSQLite instance];
  
  NSMutableArray* taskArray = [[NSMutableArray alloc] init];
  NSArray* dbArray = [sql dataWithQuery:aQuery andParameters:aParameters];

  for (NSDictionary* dbTask in dbArray)
  {
    ltTaskItem* task = [[ltTaskItem alloc] initWithDbData:dbTask];
    [taskArray addObject:task];
    [task release];
  }

  return [taskArray autorelease];
}

+ (NSDate*)lastSyncDate
{
  EZSQLite* sql = [EZSQLite instance];
  NSString* query = [[NSString alloc] initWithString:@"select max(synced) as max_synced from tasks group by synced"];
  NSArray* dbArray = [sql dataWithQuery:query andParameters:[NSArray array]];
  NSDate* date = nil;

  if ([dbArray count] > 0)
  {
    date = [[dbArray objectAtIndex:0] objectForKey:@"max_synced"];
    [date autorelease];
  }

  [query release];
  return date;
}

+ (NSArray*)deletedSince:(NSDate*)aDeleteDate
{
  NSArray* parameters = [NSArray arrayWithObjects:aDeleteDate, nil];
  return [self tasksWithSqlQuery:@"select * from tasks where rtm_id is not null and deleted is not null and deleted > ?" usingParameters:parameters];
}

@end
