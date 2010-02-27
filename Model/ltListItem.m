//
//  LTTaskList.m
//  Latte
//
//  Created by ever.zet on 30.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ltListItem.h"


@implementation ltListItem

@synthesize dbId;
@synthesize name;
@synthesize rtmId;
@synthesize created;
@synthesize updated;
@synthesize synced;
@synthesize deleted;

- (id)init
{
  if (!(self = [super init]))
  {
    return nil;
  }

  return self;
}

- (id)initWithId:(NSNumber*)anId;
{
  self = [self init];

  [self setDbId:anId];

  return self;
}

- (id)initWithDbData:(NSDictionary*)aData
{
  self = [self initWithId:[aData objectForKey:@"id"]];

  [self setName:[EZSQLite object:@"name" fromDictionary:aData]];
  [self setRtmId:[EZSQLite object:@"rtm_id" fromDictionary:aData]];
  [self setCreated:[EZSQLite object:@"created" fromDictionary:aData]];
  [self setUpdated:[EZSQLite object:@"updated" fromDictionary:aData]];
  [self setSynced:[EZSQLite object:@"synced" fromDictionary:aData]];
  [self setDeleted:[EZSQLite object:@"deleted" fromDictionary:aData]];

  return self;
}

- (void)dealloc
{
  [dbId release];
  [name release];
  [rtmId release];

  [super dealloc];
}

- (BOOL)isDeleted
{
  return ([self deleted] != nil);
}

- (void)save
{
  [self saveWithSyncDate:nil];
}

- (void)saveWithSyncDate:(NSDate*)aSyncDate
{
  EZSQLite* sql = [EZSQLite instance];
  NSString* query = [[NSString alloc] init];
  NSMutableArray* parameters = [[NSMutableArray alloc] init];

  [EZSQLite bindObject:name toParameters:parameters];
  [EZSQLite bindObject:rtmId toParameters:parameters];

  if (dbId)
  {
    if (aSyncDate)
    {
      query = [[NSString alloc] initWithFormat:@"update lists set %@ where %@", 
               @"name = ?, rtm_id = ?, updated = ?, synced = ?",
               @"id = ?"];
      [EZSQLite bindObject:aSyncDate toParameters:parameters];
      [EZSQLite bindObject:aSyncDate toParameters:parameters];
    }
    else
    {
      query = [[NSString alloc] initWithFormat:@"update lists set %@ where %@", 
               @"name = ?, updated = datetime('now'), rtm_id = ?", 
               @"id = ?"];
    }
    [EZSQLite bindObject:dbId toParameters:parameters];
  }
  else
  {
    if (rtmId && aSyncDate)
    {
      query = [[NSString alloc] initWithFormat:@"insert into lists(%@) values(%@)", 
               @"name, created, updated, rtm_id, synced", 
               @"?, datetime('now'), datetime('now'), ?, ?"];
      [EZSQLite bindObject:aSyncDate toParameters:parameters];
    }
    else
    {
      query = [[NSString alloc] initWithFormat:@"insert into lists(%@) values(%@)", 
               @"name, created, updated, rtm_id",
               @"?, datetime('now'), datetime('now'), ?"];
    }
  }

  [sql setDataWithQuery:query andParameters:parameters];

  [parameters release];
  [query release];
}

- (void)delete
{
  if (dbId)
  {
    EZSQLite* sql = [EZSQLite instance];
    NSString* query = [[NSString alloc] init];
    NSMutableArray* parameters = [[NSMutableArray alloc] initWithObjects:dbId, nil];

    query = @"update lists set deleted = datetime('now') where id = ?";
    [sql setDataWithQuery:query andParameters:parameters];

    [parameters release];
    [query release];
  }
}

@end
