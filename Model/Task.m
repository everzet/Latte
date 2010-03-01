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

#import "Task.h"


@implementation Task

@synthesize name, priority, list, dueAt, isCompleted;

- (void)dealloc
{
  [name release];
  [dueAt release];

  [super dealloc];
}

+ (NSArray*)allCompleted:(BOOL)isCompleted inList:(TaskList*)aList
{
  NSString* criteria = [NSString stringWithFormat:@"WHERE list = '%@' AND is_completed = %d ORDER BY priority, due_at",
                        [aList memoryMapKey], isCompleted];

  return [Task findByCriteria:criteria];
}

+ (NSArray*)allInList:(TaskList*)aList
{
  NSString* criteria = [NSString stringWithFormat:@"WHERE list = '%@' ORDER BY is_completed, priority, due_at",
                        [aList memoryMapKey], aList.pk];

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
