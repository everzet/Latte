#import <Cocoa/Cocoa.h>

// Controllers
#import "PreferencesController.h"
#import "TaskEntryController.h"

// Models
#import "SQLiteInstanceManager.h"
#import "Task.h"

// Interface libraries
#import "LRFilterBar.h"
#import "TaskTableCell.h"

// RTM library
#import "RTMKeys.h"
#import "EZMilk.h"

@interface AppController : NSWindowController {
  IBOutlet LRFilterBar*         filter;
  IBOutlet NSTableView*         tableView;
  IBOutlet NSPopUpButton*       listView;
  IBOutlet NSProgressIndicator* progress;
  IBOutlet NSWindow*            aboutWindow;

  // Data arrays
  IBOutlet NSMutableArray*      lists;
  IBOutlet NSMutableArray*      tasks;

  // Controllers
  TaskEntryController*          quickEntryController;
  PreferencesController*        preferencesController;

  // Singletons
  EZMilk*                       rtmApi;
  AppPreferences*               preferences;
}

- (void)initFilter;
- (void)initTable;
- (void)initDatabase;

- (void)reloadTasks;
- (void)reloadTasksWithSelection:(BOOL)withSelection;
- (void)reloadLists;

- (IBAction)aboutShow:(id)sender;
- (IBAction)preferencesShow:(id)sender;

- (IBAction)quickEntryAdd:(id)sender;
- (IBAction)quickEntryEdit:(id)sender;
- (void)quickEntryEditTask:(Task*)aTask;

- (IBAction)selectList:(id)sender;
- (void)selectFilter:(id)sender;

- (void)changeTaskCompletionStatus:(id)sender;
- (void)saveTaskFromEntry:(id)sender;

- (void)runSyncLoop:(id)sender;
- (void)syncWillStart:(id)sender;
- (void)syncDidFinish:(id)sender;
- (void)syncWithRtm:(EZMilk*)anRtm;

@end
