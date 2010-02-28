//
//  LTEntryWindow.h
//  Latte
//
//  Created by ever.zet on 01.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskList.h"
#import "Task.h"
#import "MAAttachedWindow.h"

@interface QuickEntryController : NSWindowController {
  IBOutlet NSArray*       lists;

  IBOutlet NSImageView*   background;

  IBOutlet NSTextField*   quick;
  IBOutlet NSBox*         fullBox;
  IBOutlet NSButton*      showFull;

  MAAttachedWindow*       datePickerWindow;
  IBOutlet NSView*        datePickerView;
  IBOutlet NSDatePicker*  datePicker;

  IBOutlet NSButton*      completed;
  IBOutlet NSTextField*   name;
  IBOutlet NSPopUpButton* priority;
  IBOutlet NSTextField*   due;
  IBOutlet NSPopUpButton* list;

  Task* task;
  id saveTarget;
  SEL saveAction;
}

@property (retain)Task* task;
@property (retain)id saveTarget;
@property SEL saveAction;

- (id)initWithTask:(Task*)aTask;

- (void)selectListWithPk:(int)pk;

- (IBAction)redrawWindow:(id)sender;
- (IBAction)datePickerChoose:(id)sender;

- (IBAction)saveTask:(id)sender;
- (IBAction)cancelEntry:(id)sender;

@end
