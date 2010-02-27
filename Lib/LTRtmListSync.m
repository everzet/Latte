//
//  LTRtmListSync.m
//  Latte
//
//  Created by ever.zet on 09.08.09.
//  Copyright 2009 ever.zet. All rights reserved.
//

#import "LTRtmListSync.h"


@implementation LTRtmListSync

+ (void)syncWithRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
  NSDate* syncDate = [NSDate date];
  
  NSArray* rtmLists = [self listsFromRtm:anRtm];
  // 1. Looping through lists from RTM
  for (ltListItem* rtmList in rtmLists)
  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    ltListItem* localList = [ltListProxy listWithRtmId:[rtmList rtmId]];
    if (localList)
    {
      [rtmList setDbId:[localList dbId]];
      if ([localList isDeleted])
      {
        // 1.1. If local list is marked deleted - remove it from RTM
        [self deleteList:rtmList fromRtm:anRtm usingTimeline:aTimeline];
      }
      else if ([[localList updated] compare:[localList synced]] == NSOrderedDescending)
      {
        // 1.2. If local update date is greater than last sync date - updating RTM list data
        [self updateList:rtmList to:localList inRtm:anRtm usingTimeline:aTimeline];
      }
    }
    // 1.3. If local hasn't list with such rtm_id - use data from rtm to create one
    // 1.4. If local update date is lower than last sync date - updating local list data
    // 1.5. Saving local list with sync date
    [rtmList saveWithSyncDate:syncDate];
    
    [pool release];
  }
  
  // 2. Creating not synced yet lists
  NSArray* notSyncedLists = [ltListProxy listsNotSyncedYet];
  for (ltListItem* notSyncedList in notSyncedLists)
  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    ltListItem* newList = [self createList:notSyncedList inRtm:anRtm usingTimeline:aTimeline];
    if (newList)
    {
      [notSyncedList setRtmId:[newList rtmId]];
      [notSyncedList saveWithSyncDate:syncDate];
    }
    
    [pool release];
  }
  
  // 3. Deleting local lists, that have an older sync date
  [ltListProxy deleteListsSyncedBefore:syncDate];
}

+ (NSArray*)listsFromRtm:(EZMilk*)anRtm
{
  NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
  NSDictionary* response = [anRtm dataByCallingMethod:@"rtm.lists.getList" andParameters:parameters withToken:YES];
  NSMutableArray* lists = [NSMutableArray array];
  
  if ([anRtm noErrorsInResponse:response])
  {
    for (NSDictionary* rtmList in [[response objectForKey:@"lists"] objectForKey:@"list"])
    {
      if (![[rtmList objectForKey:@"smart"] boolValue])
      {
        ltListItem* list = [self listWithRtmData:rtmList];
        [lists addObject:list];
      }
    }
  }
  
  return lists;
}

+ (ltListItem*)listWithRtmData:(NSDictionary*)rtmData
{
  ltListItem* list = [[ltListItem alloc] init];
  [list setName:[rtmData objectForKey:@"name"]];
  [list setRtmId:[NSNumber numberWithInt:[[rtmData objectForKey:@"id"] integerValue]]];
  
  return [list autorelease];
}

+ (void)deleteList:(ltListItem*)aList fromRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
  NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[aList rtmId] stringValue], @"list_id",
                              aTimeline, @"timeline", nil];
  [anRtm dataByCallingMethod:@"rtm.lists.delete" andParameters:parameters withToken:YES];
}

+ (void)updateList:(ltListItem*)fromList to:(ltListItem*)toList inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
  if ([[fromList name] compare:[toList name]] != NSOrderedSame)
  {
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[fromList rtmId] stringValue], @"list_id",
                                [toList name], @"name",
                                aTimeline, @"timeline", nil];
    [anRtm dataByCallingMethod:@"rtm.lists.setName" andParameters:parameters withToken:YES];
  }
}

+ (ltListItem*)createList:(ltListItem*)notSyncedList inRtm:(EZMilk*)anRtm usingTimeline:(NSString*)aTimeline
{
  NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                              [notSyncedList name], @"name",
                              aTimeline, @"timeline", nil];
  NSDictionary* response = [anRtm dataByCallingMethod:@"rtm.lists.add" andParameters:parameters withToken:YES];
  if ([anRtm noErrorsInResponse:response])
  {
    return [self listWithRtmData:[response objectForKey:@"list"]];
  }
  else
  {
    return nil;
  }
}

@end
