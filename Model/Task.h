/*
 
 The MIT License
 
 Copyright (c) 2009-2010 Konstantin Kudryashov <ever.zet@gmail.com>
 
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

#import <Cocoa/Cocoa.h>
#import "SQLitePersistentObject.h"
#import "TaskList.h"


@interface Task : SQLitePersistentObject {
  NSString* name;
  int       rtmId;
  int       priority;
  TaskList* list;
  NSDate*   dueAt;
  NSDate*   createdAt;
  NSDate*   updatedAt;
  NSDate*   syncedAt;
  BOOL      isCompleted;
  BOOL      isDeleted;
}

@property (nonatomic,readwrite,retain)  NSString*   name;
@property (nonatomic,readwrite)         int         rtmId;
@property (nonatomic,readwrite)         int         priority;
@property (nonatomic,readwrite,retain)  TaskList*   list;
@property (nonatomic,readwrite,retain)  NSDate*     dueAt;
@property (nonatomic,readwrite,retain)  NSDate*     createdAt;
@property (nonatomic,readwrite,retain)  NSDate*     updatedAt;
@property (nonatomic,readwrite,retain)  NSDate*     syncedAt;
@property (nonatomic,readwrite)         BOOL        isCompleted;
@property (nonatomic,readwrite)         BOOL        isDeleted;

+ (NSArray*)allCompleted:(BOOL)isCompleted inList:(TaskList*)aList;
+ (NSArray*)allInList:(TaskList*)aList;
- (NSString*)displayableDue;

@end
