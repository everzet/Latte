#import "AppController.h"

@implementation AppController

- (void)awakeFromNib
{
  // Interface setup
  [self initFilter];
  [self initTable];

  // Preferences controller
  preferences = [[Preferences alloc] init];

  // Setup RTM connector
  rtm = [[EZMilk alloc] initWithApiKey:[LTRtmApiKeys apiKey]
                          andApiSecret:[LTRtmApiKeys apiSecret]];

  // Setup DB & retrieve data
  [self initDatabase];
  [self reloadLists];
  [self reloadTasks];

  [NSThread detachNewThreadSelector:@selector(runSyncLoop:) toTarget:self withObject:self];
}

- (void)initFilter
{
  NSArray *filterButtons = [[NSArray alloc] initWithObjects: @"All", @"Pending", @"Complete", nil];
  [filter setGrayBackground];
  [filter setRegularFontWeight];
  [filter addItemsWithTitles:filterButtons withSelector:@selector(selectFilter:) withTarget:self];
  [filter selectIndex:0 inSegment:0];
  [filterButtons release];
}

- (void)initTable
{
  // Setting self as tableView target & sets the reciever of double click action to quickEntryEdit: action
  [tableView setTarget:self];
  [tableView setDoubleAction:@selector(quickEntryEdit:)];
  
  // Inserting self in NSResponder chain right after the tableView & before the tableView's responder
  [self setNextResponder:[tableView nextResponder]];
  [tableView setNextResponder:self];
}

- (void)initDatabase
{
  NSArray   *appSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString  *databasePath = [[[appSupportPath objectAtIndex: 0] 
                              stringByAppendingPathComponent: @"Latte"]
                             stringByAppendingPathComponent: @"tasks.db"];
  [[SQLiteInstanceManager sharedManager] setDatabaseFilepath:databasePath];

  //TaskList* list = [[TaskList alloc] init];
  //list.name = @"Inbox";
  //[list save];
}

- (void)dealloc
{
  [quickEntryController release];
  [preferencesController release];

  [preferences release];
  [rtm release];

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
}

- (void)reloadTasks
{
  [self reloadTasksWithSelection:NO];
}

- (void)reloadTasksWithSelection:(BOOL)withSelection
{
  NSIndexSet* selectedTasks = [tableView selectedRowIndexes];
  NSRect scrollRect = [tableView visibleRect];

  TaskList* list = nil;
  NSNumber* completed = nil;

  if ([listView indexOfSelectedItem] > 0)
  {
    list = [lists objectAtIndex:[listView indexOfSelectedItem]];
  }
  if ([filter getSelectedIndexInSegment:0] > 0)
  {
    completed = [NSNumber numberWithInt:[filter getSelectedIndexInSegment:0] - 1];
  }
  [[self mutableArrayValueForKey:@"tasks"] removeAllObjects];
  [[self mutableArrayValueForKey:@"tasks"] addObjectsFromArray:[Task allObjects]];

  if (withSelection)
  {
    [tableView selectRowIndexes:selectedTasks byExtendingSelection:NO];
    [tableView scrollRectToVisible:scrollRect];
  }
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
  TaskCell* cell = (TaskCell*)aCell;

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
        [self quickEntryEditTask:task];
      }
      else
      {
        [self quickEntryAdd:tableView];
      }
      break;
    case 32:
      [self changeTaskCompletionStatus:tableView];
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
  preferencesController = [[PreferencesController alloc] init];
  [preferencesController showWindow:self];
}

- (IBAction)quickEntryAdd:(id)sender
{
  Task* task = [[Task alloc] init];
  task.list = [lists objectAtIndex:[listView indexOfSelectedItem]];
  [self quickEntryEditTask:task];
  [task release];
}

- (IBAction)quickEntryEdit:(id)sender
{
  if ([[sender selectedRowIndexes] count] > 0)
  {
    [self quickEntryEditTask:[tasks objectAtIndex:[[tableView selectedRowIndexes] firstIndex]]];
  }
}

- (void)quickEntryEditTask:(Task*)aTask
{
  if (quickEntryController)
  {
    [quickEntryController release];
  }
  quickEntryController = [[QuickEntryController alloc] initWithTask:aTask];
  [quickEntryController setSaveTarget:self];
  [quickEntryController setSaveAction:@selector(saveTaskFromEntry:)];
  [quickEntryController showWindow: self];
}

- (IBAction)selectList:(id)sender
{
  [self reloadTasks];
}

- (void)selectFilter:(id)sender
{
  [self reloadTasks];
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

- (void)runSyncLoop:(id)sender
{
  while (true)
  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [rtm setToken:[preferences rtmToken]];

    if ([rtm token])
    {
      [self performSelectorOnMainThread:@selector(syncWillStart:) withObject:self waitUntilDone:NO];
      [self syncWithRtm:rtm];
      [self performSelectorOnMainThread:@selector(syncDidFinish:) withObject:self waitUntilDone:NO];
    }

    [pool release];
    [NSThread sleepForTimeInterval:[preferences rtmSyncInterval]];
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

@end
