//
//  LTListCollection.m
//  Latte
//
//  Created by ever.zet on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ltListProxy.h"


@implementation ltListProxy

+ (NSArray*)lists
{
  return [self listsWithSqlQuery:@"select * from lists where deleted is null"];
}

+ (NSArray*)listsNotSyncedYet
{
  return [self listsWithSqlQuery:@"select * from lists where deleted is null and rtm_id is null"];
}

+ (NSArray*)listsWithSqlQuery:(NSString*)aQuery
{
  EZSQLite* sql = [EZSQLite instance];
  
  NSMutableArray* listArray = [[NSMutableArray alloc] init];
  NSArray* dbArray = [sql dataWithQuery:aQuery andParameters:[NSArray array]];
  
  for (NSDictionary* dbList in dbArray)
  {
    ltListItem* list = [[ltListItem alloc] initWithDbData:dbList];
    [listArray addObject:list];
    [list release];
  }
  
  return [listArray autorelease];
}

+ (ltListItem*)listWithRtmId:(NSNumber*)anId
{
  EZSQLite* sql = [EZSQLite instance];
  NSString* query = [[NSString alloc] initWithFormat:@"select * from lists where rtm_id = %d", [anId integerValue]];
  NSArray* dbArray = [sql dataWithQuery:query andParameters:[NSArray array]];
  ltListItem* list = nil;

  if ([dbArray count] > 0)
  {
    list = [[ltListItem alloc] initWithDbData:[dbArray objectAtIndex:0]];
    [list autorelease];
  }

  [query release];
  return list;
}

+ (void)deleteListsSyncedBefore:(NSDate*)aDate
{
  EZSQLite* sql = [EZSQLite instance];
  NSString* query = [[NSString alloc] initWithFormat:@"update lists set deleted = datetime('now') where synced < '%@'",
                     [EZSQLite sqlDateFromDate:aDate]];
  NSMutableArray* parameters = [[NSMutableArray alloc] init];

  [sql setDataWithQuery:query andParameters:parameters];

  [parameters release];
  [query release];
}

@end
