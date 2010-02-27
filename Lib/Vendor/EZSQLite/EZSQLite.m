/*
 
 The MIT License
 
 Copyright (c) 2010 Konstantin Kudryashov <ever.zet@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "EZSQLite.h"

static EZSQLite* LTSQLiteInstance;

@implementation EZSQLite

+ (EZSQLite*)instance
{
  return LTSQLiteInstance;
}

- (id)init
{
  if (!(self = [super init]))
  {
    return nil;
  }

  LTSQLiteInstance = self;

  return self;
}

- (id)initWithDatabase:(NSString*)aDatabasePath
{
  self = [self init];
  
  [self connectToDatabase:aDatabasePath];
  
  return self;
}

- (void)connectToDatabase:(NSString*)aDatabasePath
{
  if (db)
  {
    sqlite3_close(db);
  }
  databasePath = aDatabasePath;
  
  if (sqlite3_open([aDatabasePath UTF8String], &db) != SQLITE_OK)
  {
    NSAssert(0, @"Error while connecting to database.");
  }
}

- (void)dealloc
{
  sqlite3_close(db);

  [super dealloc];
}

+ (void)bindObject:(id)anObject toParameters:(NSMutableArray*)anArray
{
  if (anObject != nil)
  {
    [anArray addObject:anObject];
  }
  else
  {
    [anArray addObject:[NSNull null]];
  }
}

+ (id)object:(NSString*)objectName fromDictionary:(NSDictionary*)aDictionary
{
  id object = [aDictionary objectForKey:objectName];

  if ([[object className] compare:@"NSNull"] == NSOrderedSame)
  {
    return nil;
  }
  else
  {
    return object;
  }
}

+ (NSString*)sqlDateFromDate:(NSDate*)aDate
{
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
  NSString* dateString = [dateFormatter stringFromDate:aDate];
  [dateFormatter release];
  
  return dateString;
}

+ (NSDate*)dateFromSqlDate:(NSString*)anSqlDate
{
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
  NSDate* date = [dateFormatter dateFromString:anSqlDate];
  [dateFormatter release];
  
  return date;
}

+ (id)objectBySqlValue:(char*)aValue andSqlType:(int)aType
{
  if (aValue)
  {
    NSString* columnText = [[NSString alloc] initWithUTF8String:aValue];
    id returnObject = nil;

    switch (aType)
    {
      case SQLITE_INTEGER:
        returnObject = [[NSNumber alloc] initWithInt:[columnText integerValue]];
        break;
      case SQLITE_FLOAT:
        returnObject = [[NSNumber alloc] initWithFloat:[columnText floatValue]];
        break;
      case SQLITE_NULL:
        returnObject = [NSNull null];
        break;
      default:
      {
        NSDate* columnDate = [self dateFromSqlDate:columnText];
        if (columnDate)
        {
          returnObject = [columnDate copy];
        }
        else
        {
          returnObject = [columnText retain];
        }
        break;
      }
    }
    [columnText release];

    return [returnObject autorelease];
  }
  else
  {
    return [NSNull null];
  }
}

+ (void)bindStatement:(sqlite3_stmt*)aStmt withObject:(id)anObject toPosition:(NSInteger)aPos;
{
  if ([[anObject className] compare:@"NSCFNumber"] == NSOrderedSame)
  {
    if ([[NSNumber numberWithInt:[anObject integerValue]] isEqualToNumber:anObject])
    {
      sqlite3_bind_int(aStmt, aPos, [anObject integerValue]);
    }
    else
    {
      sqlite3_bind_double(aStmt, aPos, [anObject floatValue]);
    }
  }
  else if ([[anObject className] compare:@"__NSCFDate"] == NSOrderedSame)
  {
    sqlite3_bind_text(aStmt, aPos, [[self sqlDateFromDate:anObject] UTF8String], -1, SQLITE_TRANSIENT);
  }
  else if ([[anObject className] compare:@"NSNull"] == NSOrderedSame)
  {
    sqlite3_bind_null(aStmt, aPos);
  }
  else
  {
    sqlite3_bind_text(aStmt, aPos, [anObject UTF8String], -1, SQLITE_TRANSIENT);
  }
}

- (void)setDataWithQuery:(NSString*)aQuery andParameters:(NSArray*)aParameters
{
  sqlite3_stmt* stmt;

  if (sqlite3_prepare_v2(db, [aQuery UTF8String], -1, &stmt, NULL) != SQLITE_OK)
  {
    NSAssert1(0, @"Error while creating statement. '%s'", sqlite3_errmsg(db));
  }

  for (int parNum = 0, parCount = [aParameters count]; parNum < parCount; parNum++)
  {
    id parameter = [aParameters objectAtIndex:parNum];
    [EZSQLite bindStatement:stmt withObject:parameter toPosition:parNum + 1];
  }

  if (SQLITE_DONE != sqlite3_step(stmt))
  {
    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(db));
  }

  sqlite3_finalize(stmt);
}

- (NSArray*)dataWithQuery:(NSString*)aQuery andParameters:(NSArray*)aParameters
{
  NSMutableArray* rows = [[NSMutableArray alloc] init];
  sqlite3_stmt *stmt;

  if (sqlite3_prepare_v2(db, [aQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK)
  {
    for (int parNum = 0, parCount = [aParameters count]; parNum < parCount; parNum++)
    {
      id parameter = [aParameters objectAtIndex:parNum];
      [EZSQLite bindStatement:stmt withObject:parameter toPosition:parNum];
    }

    while (SQLITE_ROW == sqlite3_step(stmt))
    {
      NSMutableDictionary* row = [[NSMutableDictionary alloc] init];
      for (int colNum = 0, colCount = sqlite3_column_count(stmt); colNum < colCount; colNum++)
      {
        // Adding column value by name to row dictionary
        NSString* columnName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_name(stmt, colNum)];
        id columnValue = [EZSQLite objectBySqlValue: (char *)sqlite3_column_text(stmt, colNum)
                                         andSqlType: sqlite3_column_type(stmt, colNum)];
        [row setObject:columnValue forKey:columnName];
        [columnName release];
      }
      // Adding row to rows array & releasing it
      [rows addObject:row];
      [row release];
    }
  }
  else
  {
    NSAssert1(0, @"Error while creating statement. '%s'", sqlite3_errmsg(db));
  }
  NSArray* returnRows = [NSArray arrayWithArray:rows];
  [rows release];

  sqlite3_finalize(stmt);
  return returnRows;
}

@end
