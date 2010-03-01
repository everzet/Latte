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

#import "TaskEntryController.h"


@implementation TaskEntryController

@synthesize task;
@synthesize saveTarget;
@synthesize saveAction;

- (id)init
{
  Task* newTask = [[Task alloc] init];
  return [self initWithTask:newTask];
  [newTask release];
}

- (id)initWithTask:(Task*)aTask
{
  if (!(self = [super initWithWindowNibName:@"TaskEntry"]))
  {
    return nil;
  }

  [self setTask:aTask];

  [[self mutableArrayValueForKey:@"lists"] addObjectsFromArray:[TaskList allObjects]];

  return self;
}

- (void)selectListWithPk:(int)pk
{
  for (int lNum = 0, lCount = [lists count]; lNum < lCount; lNum++)
  {
    if ([[lists objectAtIndex:lNum] pk] == pk)
    {
      [list selectItemAtIndex:lNum];
      break;
    }
  }
}

- (void)awakeFromNib
{
  if (task)
  {
    if ([task name])
    {
      [name setStringValue:[task name]];
    }
    [priority selectItemAtIndex:(task.priority ? 4 - [task priority] : 0)];
    if (task.isCompleted)
    {
      [completed setState:1];
    }
    else
    {
      [completed setState:0];
    }
    if (task.dueAt)
    {
      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
      [due setStringValue:[dateFormatter stringFromDate:task.dueAt]];
      [dateFormatter release];
    }
    if (task.list.pk)
    {
      [self selectListWithPk:task.list.pk];
    }
  }

  [[self window] orderFront:self];
}

- (void)dealloc
{
  [saveTarget release];
  [datePickerWindow release];
  [task release];

  [super dealloc];
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
  NSPoint buttonPoint = NSMakePoint(60, NSMidY([due frame]));
  datePickerWindow = [[MAAttachedWindow alloc] initWithView: datePickerView
                                            attachedToPoint: buttonPoint
                                                   inWindow: [due window]
                                                     onSide: 1
                                                 atDistance: 8];
  [datePickerWindow setBorderColor:[NSColor whiteColor]];
  [datePickerWindow setBackgroundColor:[NSColor colorWithCalibratedWhite:0.101 alpha:0.750]];
  [datePickerWindow setViewMargin:10];
  [datePickerWindow setBorderWidth:2];
  [datePickerWindow setCornerRadius:8];
  [datePickerWindow setHasArrow:YES];
  [datePickerWindow setDrawsRoundCornerBesideArrow:YES];
  [datePickerWindow setArrowBaseWidth:50];
  [datePickerWindow setArrowHeight:10];

  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
  NSDate* date = [dateFormatter dateFromString:[due stringValue]];
  [datePicker setDateValue:date ? date : [NSDate date]];
  [dateFormatter release];

  [[due window] addChildWindow:datePickerWindow ordered:NSWindowAbove];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
  [[due window] removeChildWindow:datePickerWindow];
  [datePickerWindow orderOut:self];
  [datePickerWindow release];
  datePickerWindow = nil;
}

- (IBAction)redrawWindow:(id)sender
{
  NSRect windowRect = [[self window] frame];

  if ([showFull state])
  {
    NSRect fullBoxRect = [fullBox frame];

    [fullBox setHidden:NO];
    [[self window] setFrame:NSMakeRect(windowRect.origin.x, windowRect.origin.y, 386, 103 + (fullBoxRect.size.height - 6)) display:YES];
  }
  else
  {
    [fullBox setHidden:YES];
    [[self window] setFrame:NSMakeRect(windowRect.origin.x, windowRect.origin.y, 386, 103) display:YES];
  }
}

- (IBAction)datePickerChoose:(id)sender
{
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
  [due setStringValue:[dateFormatter stringFromDate:[datePicker dateValue]]];
  [dateFormatter release];
}

- (IBAction)saveTask:(id)sender
{
  if ([[name stringValue] compare:@""] != NSOrderedSame)
  {
    task.name = [name stringValue];
    task.priority = 4 - [priority indexOfSelectedItem];
    task.isCompleted = [completed integerValue];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
    task.dueAt = [dateFormatter dateFromString:[due stringValue]];
    [dateFormatter release];

    task.list = [lists objectAtIndex:[list indexOfSelectedItem]];
    task.updatedAt = [NSDate date];

    [NSApp sendAction:[self saveAction] to:[self saveTarget] from:self];
    [[self window] close];
  }
  else
  {
    NSRunAlertPanel(@"Name of task needed", @"Please, fill at least name of the task", @"ok", nil, nil);
    [[self window] makeFirstResponder:name];
  }
}

- (IBAction)cancelEntry:(id)sender
{
  [[self window] close];
}

@end
