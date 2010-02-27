//
//  LTTask.m
//  LTTasks
//
//  Created by ever.zet on 26.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ltTaskItem.h"


@implementation ltTaskItem

@synthesize dbId;
@synthesize name;
@synthesize priority;
@synthesize due;
@synthesize completed;
@synthesize list;
@synthesize rtmId;
@synthesize created;
@synthesize updated;
@synthesize synced;
@synthesize deleted;
@synthesize listName;

- (id)init
{
  if (!(self = [super init]))
  {
    return nil;
  }

  return self;
}

- (id)initWithId:(NSNumber*)anId
{
  self = [self init];

  [self setDbId:anId];

  return self;
}

- (id)initWithDbData:(NSDictionary*)aData
{
  self = [self initWithId:[EZSQLite object:@"id" fromDictionary:aData]];

  [self setName:[EZSQLite object:@"name" fromDictionary:aData]];
  [self setPriority:[EZSQLite object:@"priority" fromDictionary:aData]];
  [self setDue:[EZSQLite object:@"due" fromDictionary:aData]];
  [self setCompleted:[EZSQLite object:@"completed" fromDictionary:aData]];
  [self setList:[EZSQLite object:@"list" fromDictionary:aData]];
  [self setRtmId:[EZSQLite object:@"rtm_id" fromDictionary:aData]];
  [self setCreated:[EZSQLite object:@"created" fromDictionary:aData]];
  [self setUpdated:[EZSQLite object:@"updated" fromDictionary:aData]];
  [self setSynced:[EZSQLite object:@"synced" fromDictionary:aData]];
  [self setDeleted:[EZSQLite object:@"deleted" fromDictionary:aData]];
  [self setListName:[EZSQLite object:@"listName" fromDictionary:aData]];

  return self;
}

- (void)dealloc
{
  [dbId release];
  [name release];
  [priority release];
  [due release];
  [completed release];
  [list release];
  [rtmId release];
  [created release];
  [updated release];
  [synced release];
  [deleted release];
  [listName release];

  [super dealloc];
}

- (NSString*)displayableDue
{
  NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormatter setDateStyle: NSDateFormatterShortStyle];

  return [dateFormatter stringFromDate:due];
}

- (id)copyWithZone:(NSZone *)zone
{
  return [self retain];
}

- (BOOL)isDeleted
{
  return ([self deleted] != nil);
}

- (BOOL)isCompleted
{
  return ([self completed] != nil);
}

- (void)save
{
  EZSQLite* sql = [EZSQLite instance];
  NSString* query = nil;
  NSMutableArray* parameters = [[NSMutableArray alloc] init];

  [EZSQLite bindObject:name toParameters:parameters];
  [EZSQLite bindObject:priority toParameters:parameters];
  [EZSQLite bindObject:due toParameters:parameters];
  [EZSQLite bindObject:completed toParameters:parameters];
  [EZSQLite bindObject:list toParameters:parameters];
  [EZSQLite bindObject:rtmId toParameters:parameters];
  [EZSQLite bindObject:(created ? created : [NSDate date]) toParameters:parameters];
  [EZSQLite bindObject:(updated ? updated : [NSDate date]) toParameters:parameters];
  [EZSQLite bindObject:synced toParameters:parameters];
  [EZSQLite bindObject:deleted toParameters:parameters];

  if (dbId)
  {
    [EZSQLite bindObject:dbId toParameters:parameters];

    query = [[NSString alloc] initWithFormat:@"update tasks set %@ where %@",
             @"name = ?, priority = ?, due = ?, completed = ?, list = ?, rtm_id = ?, created = ?, updated = ?, synced = ?, deleted = ?",
             @"id = ?"];
  }
  else
  {
    query = [[NSString alloc] initWithFormat:@"insert into tasks(%@) values(%@)",
             @"name, priority, due, completed, list, rtm_id, created, updated, synced, deleted",
             @"?, ?, ?, ?, ?, ?, ?, ?, ?, ?"];
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

    NSString* query = [[NSString alloc] initWithFormat:@"update tasks set deleted = datetime('now') where id = %d", [dbId integerValue]];
    [sql setDataWithQuery:query andParameters:[NSArray array]];

    [query release];
  }
}

@end
