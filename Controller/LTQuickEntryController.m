//
//  LTEntryWindow.m
//  Latte
//
//  Created by ever.zet on 01.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LTQuickEntryController.h"


@implementation LTQuickEntryController

@synthesize task;
@synthesize saveTarget;
@synthesize saveAction;

- (id)init
{
  ltTaskItem* newTask = [[[ltTaskItem alloc] init] autorelease];
  return [self initWithTask:newTask];
  [newTask release];
}

- (id)initWithTask:(ltTaskItem*)aTask
{
  if (!(self = [super initWithWindowNibName:@"QuickEntry"]))
  {
    return nil;
  }

  [self setTask:aTask];

  [[self mutableArrayValueForKey:@"lists"] addObjectsFromArray:[ltListProxy lists]];

  return self;
}

- (void)selectListWithDbId:(NSNumber*)anId
{
  for (int lNum = 0, lCount = [lists count]; lNum < lCount; lNum++)
  {
    if ([[[lists objectAtIndex:lNum] dbId] isEqualToNumber:anId])
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
    [priority selectItemAtIndex:([[task priority] boolValue] ? 4 - [[task priority] integerValue] : 0)];
    if ([task isCompleted])
    {
      [completed setState:1];
    }
    else
    {
      [completed setState:0];
    }
    if ([task due])
    {
      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
      [due setStringValue:[dateFormatter stringFromDate:[task due]]];
      [dateFormatter release];
    }
    if ([task list])
    {
      [self selectListWithDbId:[task list]];
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
    [task setName:[name stringValue]];
    [task setPriority:[NSNumber numberWithInt:4 - [priority indexOfSelectedItem]]];
    if ([completed integerValue])
    {
      [task setCompleted:[NSDate date]];
    }
    else
    {
      [task setCompleted:nil];
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
    [task setDue:[dateFormatter dateFromString:[due stringValue]]];
    [dateFormatter release];
    [task setList:[[lists objectAtIndex:[list indexOfSelectedItem]] dbId]];
    [task setUpdated:[NSDate date]];

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
