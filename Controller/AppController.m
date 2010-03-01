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

#import "AppController.h"

@implementation AppController

@synthesize groups;

- (void)awakeFromNib
{
  // Interface setup
  [self initMGScope];
  [self initTable];

  // Setup EZMilk & AppPreferences lib
  rtmService = [[EZMilk alloc] initWithApiKey:[RTMKeys apiKey]
                             andApiSecret:[RTMKeys apiSecret]];
  prefHolder = [[AppPreferences alloc] init];

  // Retrieve DB data
  [self reloadLists];
  [self reloadTasksWithSelection:NO];

  [NSThread detachNewThreadSelector:@selector(runSyncLoop:) toTarget:self withObject:self];
}

- (void)initMGScope
{
  self.groups = [NSMutableArray arrayWithCapacity:0];
	scopeBar.delegate = self;

	NSArray *items = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"AllItem", @"Identifier", @"All", @"Name", nil], 
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"PendingItem", @"Identifier", @"Pending", @"Name", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"CompleteItem", @"Identifier", @"Complete", @"Name", nil],
                    nil];
	
	[self.groups addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"show:", @"Label", 
                          [NSNumber numberWithBool:NO], @"HasSeparator", 
                          [NSNumber numberWithInt:MGRadioSelectionMode], @"SelectionMode",
                          items, @"Items", 
                          nil]];

  [scopeBar reloadData];
}

- (void)initTable
{
  // Setting self as tableView target & sets the reciever of double click action to quickEntryEdit: action
  [tableView setTarget:self];
  [tableView setDoubleAction:@selector(taskEntryEdit:)];
  
  // Inserting self in NSResponder chain right after the tableView & before the tableView's responder
  [self setNextResponder:[tableView nextResponder]];
  [tableView setNextResponder:self];
}

- (void)dealloc
{
  [taskEntryController release];
  [preferencesController release];

  [prefHolder release];
  [rtmService release];
  [groups release];

  [super dealloc];
}

- (void)reloadLists
{
  int selectedList = [listView indexOfSelectedItem];

  NSMutableArray* listArray = [self mutableArrayValueForKey:@"lists"];
  [listArray removeAllObjects];
  [listArray addObjectsFromArray:[TaskList allObjects]];

  if (selectedList >= 0)
  {
    [listView selectItemAtIndex:selectedList];
  }

  if (1 > [listArray count])
  {
    TaskList* list = [[TaskList alloc] init];
    list.name = @"Inbox";
    [list save];
    [list release];
    [self reloadLists];
  }
}

- (void)reloadTasksWithSelection:(BOOL)withSelection
{
  NSIndexSet* selectedTasks = [tableView selectedRowIndexes];
  NSRect scrollRect = [tableView visibleRect];

  TaskList* list = nil;

  list = [lists objectAtIndex:[listView indexOfSelectedItem]];
  [[self mutableArrayValueForKey:@"tasks"] removeAllObjects];
  NSString* identifier = [[[scopeBar selectedItems] objectAtIndex:0] objectAtIndex:0];

if (NSOrderedSame == [identifier compare:@"AllItem"])
  {
    [[self mutableArrayValueForKey:@"tasks"] addObjectsFromArray:[Task allInList:list]];
  }
  else if (NSOrderedSame == [identifier compare:@"PendingItem"])
  {
    [[self mutableArrayValueForKey:@"tasks"] addObjectsFromArray:[Task allCompleted:false inList:list]];
  }
  else if (NSOrderedSame == [identifier compare:@"CompleteItem"])
  {
    [[self mutableArrayValueForKey:@"tasks"] addObjectsFromArray:[Task allCompleted:true inList:list]];
  }

  if (withSelection)
  {
    [tableView selectRowIndexes:selectedTasks byExtendingSelection:NO];
    [tableView scrollRectToVisible:scrollRect];
  }
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
  TaskTableCell* cell = (TaskTableCell*)aCell;

  [cell setTarget:self];
  [cell setCheckboxClickedAction:@selector(changeTaskCompletionStatus:)];
}

- (void)keyDown:(NSEvent*)anEvent
{
  Task* task = nil;
  if ([[tableView selectedRowIndexes] count])
  {
    task = [tasks objectAtIndex:[[tableView selectedRowIndexes] firstIndex]];
  }

  char keyCode = [[anEvent charactersIgnoringModifiers] characterAtIndex:0];
  switch (keyCode)
  {
    case NSDeleteCharacter:
      if (task)
      {
        [task deleteObject];
        [self reloadTasksWithSelection:YES];
      }
      break;
    case NSCarriageReturnCharacter:
      if (task)
      {
        [self taskEntryEditTask:task];
      }
      else
      {
        [self taskEntryAdd:self];
      }
      break;
    case 32:
      [self changeTaskCompletionStatus:self];
      break;
    case 27:
      [tableView deselectAll:tableView];
      break;
    default:
      [super keyDown:anEvent];
      break;
  }
}

- (IBAction)aboutShow:(id)sender
{
  [aboutWindow makeKeyAndOrderFront:self];
}

- (IBAction)preferencesShow:(id)sender
{
  if (preferencesController)
  {
    [preferencesController release];
  }
  preferencesController = [[PreferencesController alloc] initWithPreferences: prefHolder
                                                             andRtmConnector: rtmService];
  [preferencesController showWindow:self];
}

- (IBAction)taskEntryAdd:(id)sender
{
  Task* task = [[Task alloc] init];
  task.list = [lists objectAtIndex:[listView indexOfSelectedItem]];
  [self taskEntryEditTask:task];
  [task release];
}

- (IBAction)taskEntryEdit:(id)sender
{
  if ([[sender selectedRowIndexes] count] > 0)
  {
    [self taskEntryEditTask:[tasks objectAtIndex:[[tableView selectedRowIndexes] firstIndex]]];
  }
}

- (void)taskEntryEditTask:(Task*)aTask
{
  if (taskEntryController)
  {
    [taskEntryController release];
  }
  taskEntryController = [[TaskEntryController alloc] initWithTask:aTask];
  [taskEntryController setSaveTarget:self];
  [taskEntryController setSaveAction:@selector(saveTaskFromEntry:)];
  [taskEntryController showWindow: self];
}

- (IBAction)selectList:(id)sender
{
  [self reloadTasksWithSelection:NO];
}

- (void)selectFilter:(id)sender
{
  [self reloadTasksWithSelection:NO];
}

- (void)changeTaskCompletionStatus:(id)sender
{
  Task* task = [tasks objectAtIndex:[[tableView selectedRowIndexes] firstIndex]];
  task.isCompleted = task.isCompleted ? false : true;
  [task save];
  [self reloadTasksWithSelection:YES];
}

- (void)saveTaskFromEntry:(id)sender
{
  [[sender task] save];
  [self reloadTasksWithSelection:YES];
}

#pragma mark RTM sync methods

- (void)runSyncLoop:(id)sender
{
  while (false)
  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [rtmService setToken:[prefHolder rtmToken]];

    if ([rtmService token])
    {
      [self performSelectorOnMainThread:@selector(syncWillStart:) withObject:self waitUntilDone:NO];
      [self syncWithRtm:rtmService];
      [self performSelectorOnMainThread:@selector(syncDidFinish:) withObject:self waitUntilDone:NO];
    }

    [pool release];
    [NSThread sleepForTimeInterval:[prefHolder rtmSyncInterval]];
  }
}

- (void)syncWillStart:(id)sender
{
  [progress setHidden:NO];
  [progress startAnimation:self];
}

- (void)syncDidFinish:(id)sender
{
  [self reloadLists];
  [self reloadTasksWithSelection:YES];
  [progress stopAnimation:self];
  [progress setHidden:YES];
}

- (void)syncWithRtm:(EZMilk*)anRtm
{
  //NSString* timeline = [anRtm timeline];
  //[LTRtmListSync syncWithRtm:anRtm usingTimeline:timeline];
  //[LTRtmTaskSync syncWithRtm:rtm usingTimeline:timeline];
}

#pragma mark MGScopeBarDelegate methods

- (void)scopeBar:(MGScopeBar *)theScopeBar selectedStateChanged:(BOOL)selected 
         forItem:(NSString *)identifier inGroup:(int)groupNumber
{
  [self reloadTasksWithSelection:NO];
}

- (int)numberOfGroupsInScopeBar:(MGScopeBar *)theScopeBar
{
	return [self.groups count];
}


- (NSArray *)scopeBar:(MGScopeBar *)theScopeBar itemIdentifiersForGroup:(int)groupNumber
{
	return [[self.groups objectAtIndex:groupNumber] valueForKeyPath:[NSString stringWithFormat:@"%@.%@", @"Items", @"Identifier"]];
}


- (NSString *)scopeBar:(MGScopeBar *)theScopeBar labelForGroup:(int)groupNumber
{
	return [[self.groups objectAtIndex:groupNumber] objectForKey:@"Label"]; // might be nil, which is fine (nil means no label).
}


- (NSString *)scopeBar:(MGScopeBar *)theScopeBar titleOfItem:(NSString *)identifier inGroup:(int)groupNumber
{
	NSArray *items = [[self.groups objectAtIndex:groupNumber] objectForKey:@"Items"];
	if (items) {
		// We'll iterate here, since this is just a demo. This avoids having to keep an NSDictionary of identifiers 
		// for each group as well as an array for ordering. In a more realistic scenario, you'd probably want to be 
		// able to look-up an item by its identifier in constant time.
		for (NSDictionary *item in items) {
			if ([[item objectForKey:@"Identifier"] isEqualToString:identifier]) {
				return [item objectForKey:@"Name"];
				break;
			}
		}
	}
	return nil;
}


- (MGScopeBarGroupSelectionMode)scopeBar:(MGScopeBar *)theScopeBar selectionModeForGroup:(int)groupNumber
{
	return [[[self.groups objectAtIndex:groupNumber] objectForKey:@"SelectionMode"] intValue];
}


- (BOOL)scopeBar:(MGScopeBar *)theScopeBar showSeparatorBeforeGroup:(int)groupNumber
{
	// Optional method. If not implemented, all groups except the first will have a separator before them.
	return [[[self.groups objectAtIndex:groupNumber] objectForKey:@"HasSeparator"] boolValue];
}


- (NSImage *)scopeBar:(MGScopeBar *)scopeBar imageForItem:(NSString *)identifier inGroup:(int)groupNumber
{
	return nil;
}

@end
