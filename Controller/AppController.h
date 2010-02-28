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
  TaskEntryController*          taskEntryController;
  PreferencesController*        preferencesController;

  // Libs
  EZMilk*                       rtmService;
  AppPreferences*               prefHolder;
}

// Interface & Data init
- (void)initFilter;
- (void)initTable;
- (void)initDatabase;

// Data reloaders
- (void)reloadTasksWithSelection:(BOOL)withSelection;
- (void)reloadLists;

// Run other controllers
- (IBAction)aboutShow:(id)sender;
- (IBAction)preferencesShow:(id)sender;

// TaskEntry controllers
- (IBAction)taskEntryAdd:(id)sender;
- (IBAction)taskEntryEdit:(id)sender;
- (void)taskEntryEditTask:(Task*)aTask;

- (IBAction)selectList:(id)sender;
- (void)selectFilter:(id)sender;

- (void)changeTaskCompletionStatus:(id)sender;
- (void)saveTaskFromEntry:(id)sender;

- (void)runSyncLoop:(id)sender;
- (void)syncWillStart:(id)sender;
- (void)syncDidFinish:(id)sender;
- (void)syncWithRtm:(EZMilk*)anRtm;

@end
