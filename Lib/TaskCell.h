//
//  LTTaskCell.h
//  LTTasks
//
//  Created by ever.zet on 26.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskGradient.h"
#import "ltTaskItem.h"


@interface TaskCell : NSTextFieldCell {
  SEL checkboxClickedAction;
  BOOL checkboxMouseIsDown;
}

@property SEL checkboxClickedAction;

- (NSRect)checkboxRectForFrame:(NSRect)cellFrame;
- (NSRect)checkboxRectForFrame:(NSRect)cellFrame withBorder:(NSInteger)aBorder;
- (NSShadow*)textShadow;

- (void)drawCheckboxWithFrame:(NSRect)cellFrame isChecked:(BOOL)isChecked;
- (NSString*)rightAlignedString:(NSString*)aString ofSize:(NSInteger)aSize;

@end
