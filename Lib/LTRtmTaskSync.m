//
//  LTRtmTaskSync.m
//  Latte
//
//  Created by ever.zet on 09.08.09.
//  Copyright 2009 ever.zet. All rights reserved.
//

#import "LTRtmTaskSync.h"


@implementation LTRtmTaskSync

+ (void)syncWithRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
  /*
  // 1. Get latestSyncDate for tasks from local DB
  NSDate* lastSyncDate = [LTTaskTable lastSyncDate];
  NSDate* syncDate = [NSDate date];

  // 2. Deleting from RTM tasks, that have been deleted since last sync
  NSArray* deletedLocally = [LTTaskTable deletedSince:lastSyncDate];
  for (LTTask* deletedTask in deletedLocally)
  {
    [self deleteTask:deletedTask fromRtm:anRtm usingTimeline:aTimeline];
  }

  // 3. Getting tasks from RTM. If latestSyncDate != nil - getting tasks from RTM by last_sync parameter. If not - getting without last_sync
  NSArray* rtmTasks = [self tasksFromRtm:anRtm changedAfter:lastSyncDate];

  // 4. Looping through tasks from RTM
  for (LTTask* rtmTask in rtmTasks)
  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    LTTask* localTask = [LTTaskTable taskWithRtmId:[rtmTask rtmId]];
    if (localTask)
    {
      [rtmTask setDbId:[localTask dbId]];
      if ([rtmTask isDeleted])
      {
        // 4.1. If task is marked as deleted in RTM - deleting it in local DB
        [localTask delete];
      }
      else if ([[rtmTask updated] compare:[localTask updated]] == NSOrderedAscending)
      {
        // 4.2. Looking for change date & if RTM change date is later than local - changin local. If not - changing RTM
        [self updateTask:rtmTask to:localTask inRtm:anRtm usingTimeline:aTimeline];
      }
    }
    // 4.3. If local DB have not this task - create it. If has - just sync it
    [rtmTask saveWithSyncDate:syncDate];

    [pool release];
  }

  // 5. Looping through notSynced tasks & creating them on RTM
  NSArray* notSyncedTasks = [LTTaskTable tasksNotSyncedYet];
  for (LTTask* notSyncedTask in notSyncedTasks)
  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    LTTask* newTask = [self createTask:notSyncedTask inRtm:anRtm usingTimeline:aTimeline];
    if (newTask)
    {
      [notSyncedTask setRtmId:[newTask rtmId]];
      [notSyncedTask saveWithSyncDate:syncDate];
    }
    
    [pool release];
  }
  */
}

+ (NSArray*)tasksFromRtm:(EZMilk*)anRtm changedAfter:(NSDate*)aSyncDate
{
  NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
  if ([[aSyncDate className] compare:@"NSNull"] != NSOrderedSame)
  {
    [parameters setObject:[EZMilk rtmDateFromDate:aSyncDate] forKey:@"last_sync"];
  }
  NSDictionary* response = [anRtm dataByCallingMethod:@"rtm.tasks.getList" andParameters:parameters withToken:YES];
  NSMutableArray* tasks = [NSMutableArray array];

  if ([anRtm noErrorsInResponse:response])
  {
    for (NSDictionary* rtmList in [[response objectForKey:@"tasks"] objectForKey:@"list"])
    {
      NSNumber* rtmListId = [NSNumber numberWithInt:[[rtmList objectForKey:@"id"] integerValue]];
      ltListItem* localList = [ltListProxy listWithRtmId:rtmListId];

      for (NSDictionary* rtmTask in [rtmList objectForKey:@"taskseries"])
      {
        ltTaskItem* task = [self taskWithRtmData:rtmTask];
        [task setList:[localList dbId]];
        [tasks addObject:task];
      }
      for (NSDictionary* rtmTask in [[rtmList objectForKey:@"deleted"] objectForKey:@"taskseries"])
      {
        ltTaskItem* task = [self taskWithRtmData:rtmTask];
        [task setList:[localList dbId]];
        [task setDeleted:[EZMilk dateFromRtmDate:[rtmTask objectForKey:@"deleted"]]];
        [tasks addObject:task];
      }
    }
  }

  return tasks;
}

+ (ltTaskItem*)taskWithRtmData:(NSDictionary*)aData
{
  NSDictionary* taskData = [aData objectForKey:@"task"];
  
  ltTaskItem* task = [[ltTaskItem alloc] init];
  [task setName:[aData objectForKey:@"name"]];
  [task setRtmId:[taskData objectForKey:@"id"]];
  [task setDue:[EZMilk dateFromRtmDate:[taskData objectForKey:@"due"]]];
  [task setCreated:[EZMilk dateFromRtmDate:[taskData objectForKey:@"added"]]];
  [task setCompleted:[EZMilk dateFromRtmDate:[taskData objectForKey:@"completed"]]];
  [task setUpdated:[EZMilk dateFromRtmDate:[aData objectForKey:@"modified"]]];
  [task setPriority:[NSNumber numberWithInt:[[taskData objectForKey:@"priority"] integerValue]]];

  return [task autorelease];
}

+ (void)deleteTask:(ltTaskItem*)aTask fromRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
}

+ (void)updateTask:(ltTaskItem*)rtmTask to:(ltTaskItem*)localTask inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
}

+ (ltTaskItem*)createTask:(ltTaskItem*)notSyncedTask inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
  return nil;
}

@end
