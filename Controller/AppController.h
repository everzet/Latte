#import <Cocoa/Cocoa.h>

// RTM library
#import "LTRtmApiKeys.h"
#import "EZMilk.h"

// Interface libraries
#import "LRFilterBar.h"
#import "TaskCell.h"

// Controllers
#import "PreferencesController.h"
#import "QuickEntryController.h"

// Models
#import "SQLiteInstanceManager.h"
#import "Task.h"

// 2REMOVE
#import "ltListProxy.h"
#import "ltTaskProxy.h"

@interface AppController : NSWindowController {
  IBOutlet LRFilterBar* filter;
  IBOutlet NSTableView* tableView;
  IBOutlet NSPopUpButton* listView;
  IBOutlet NSProgressIndicator* progress;
  IBOutlet NSWindow* aboutWindow;

  IBOutlet NSMutableArray* lists;
  IBOutlet NSMutableArray* tasks;

  QuickEntryController* quickEntryController;
  PreferencesController* preferencesController;

  EZSQLite* sqlite;
  EZMilk* rtm;
  Preferences* preferences;
}

- (void)reloadTasks;
- (void)reloadTasksWithSelection:(BOOL)withSelection;
- (void)reloadLists;

- (IBAction)aboutShow:(id)sender;
- (IBAction)preferencesShow:(id)sender;

- (IBAction)quickEntryAdd:(id)sender;
- (IBAction)quickEntryEdit:(id)sender;
- (void)quickEntryEditTask:(ltTaskItem*)aTask;

- (IBAction)selectList:(id)sender;
- (void)selectFilter:(id)sender;

- (void)changeTaskCompletionStatus:(id)sender;
- (void)saveTaskFromEntry:(id)sender;

- (void)runSyncLoop:(id)sender;
- (void)syncWillStart:(id)sender;
- (void)syncDidFinish:(id)sender;
- (void)syncWithRtm:(EZMilk*)anRtm;

@end
