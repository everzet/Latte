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

// Models
#import "TaskList.h"
#import "Task.h"

// Interface libraries
#import "MAAttachedWindow.h"

@interface TaskEntryController : NSWindowController {
  IBOutlet NSArray*       lists;
  IBOutlet NSImageView*   background;
  IBOutlet NSTextField*   quick;
  IBOutlet NSBox*         fullBox;
  IBOutlet NSButton*      showFull;
  IBOutlet NSView*        datePickerView;
  IBOutlet NSDatePicker*  datePicker;
  IBOutlet NSButton*      completed;
  IBOutlet NSTextField*   name;
  IBOutlet NSPopUpButton* priority;
  IBOutlet NSTextField*   due;
  IBOutlet NSPopUpButton* list;
  MAAttachedWindow*       datePickerWindow;

  Task*                   task;
  id                      saveTarget;
  SEL                     saveAction;
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
