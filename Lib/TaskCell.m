//
//  LTTaskCell.m
//  LTTasks
//
//  Created by ever.zet on 26.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskCell.h"

@implementation NSColor (BLColor)

// Row alternating color is always light gray
+ (NSArray *)controlAlternatingRowBackgroundColors {
	return [NSArray arrayWithObjects:
          [NSColor whiteColor],
          [NSColor colorWithCalibratedRed:0xF8/255.0 green:0xF8/255.0 blue:0xF8/255.0 alpha:0xFF/255.0],
          nil];
}

@end

@implementation TaskCell

@synthesize checkboxClickedAction;

- (NSRect)checkboxRectForFrame:(NSRect)cellFrame
{
  return [self checkboxRectForFrame:cellFrame withBorder:0];
}

- (NSRect)checkboxRectForFrame:(NSRect)cellFrame withBorder:(NSInteger)aBorder
{
  return NSMakeRect(cellFrame.origin.x + 10 - aBorder, cellFrame.origin.y + 7 - aBorder, 10 + (aBorder * 2), 10 + (aBorder * 2));
}

- (NSShadow*)textShadow
{
  NSShadow *textShadow = [[NSShadow alloc] init];
  [textShadow setShadowOffset: NSMakeSize(0, -1)];
  [textShadow setShadowBlurRadius: 2];
  [textShadow setShadowColor: [NSColor whiteColor]];

  return [textShadow autorelease];
}

- (void)drawCheckboxWithFrame:(NSRect)cellFrame isChecked:(BOOL)isChecked
{
  NSRect checkboxRect = [self checkboxRectForFrame: cellFrame];

  NSBezierPath* path = [[NSBezierPath alloc] init];
  [path appendBezierPathWithRect: checkboxRect];
  [[NSColor colorWithCalibratedRed:0x6F/255.0 green:0x6F/255.0 blue:0x6F/255.0 alpha:0xFF/255.0] set];
  [path setLineWidth: 1];
  [path stroke];
  [path release];

  if (isChecked)
  {
    [[TaskGradient checkboxCheckedGradient] fillRect:checkboxRect angle:90];

    path = [[NSBezierPath alloc] init];
    [path moveToPoint: NSMakePoint(cellFrame.origin.x + 11, cellFrame.origin.y + 11)];
    [path lineToPoint: NSMakePoint(cellFrame.origin.x + 14, cellFrame.origin.y + 14)];
    [path lineToPoint: NSMakePoint(cellFrame.origin.x + 19, cellFrame.origin.y + 8)];
    [[NSColor whiteColor] set];
    [path setLineWidth: 2];
    [path stroke];
    [path release];
  }
  else
  {
    [[TaskGradient checkboxGradient] fillRect:checkboxRect angle:90];
  }
}

- (NSString*)rightAlignedString:(NSString*)aString ofSize:(NSInteger)aSize
{
  if ([aString length] > 0)
  {
    NSString* padString = [@"" stringByPaddingToLength:aSize - [aString length] withString:@" " startingAtIndex:0];
    return [NSString stringWithFormat:@"%@%@", padString, aString];
  }
  else
  {
    return @"";
  }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  // Getting associated task
  Task *task = (Task*)[self objectValue];

  // Task background
  [[TaskGradient taskGradientIsHighlighted:[self isHighlighted] isChecked:task.isCompleted]
   fillRect: NSMakeRect(cellFrame.origin.x - 1, cellFrame.origin.y - 1, cellFrame.size.width + 3, cellFrame.size.height + 2)
      angle: 90];

  // Task priority colored gradient
  [[TaskGradient priorityGradient: task.priority]
                      fillRect: NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, 5, cellFrame.size.height)
                         angle: 90];

  // Task checker
  [self drawCheckboxWithFrame:cellFrame isChecked:task.isCompleted];

  // Texts shadow
  NSShadow *textShadow = [self textShadow];

  // Width of Due Date string
  NSInteger dueStringWidth = 50;

  // Task title
  [task.name drawInRect: NSMakeRect(cellFrame.origin.x + 26,
                                      cellFrame.origin.y + 3,
                                      cellFrame.size.width - 26,
                                      cellFrame.size.height - 18) 
           withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor darkGrayColor], NSForegroundColorAttributeName,
                            textShadow, NSShadowAttributeName,
                            [NSFont systemFontOfSize:12], NSFontAttributeName, nil]];

  // Task due date
  [[self rightAlignedString:[task displayableDue] ofSize:11]
       drawInRect: NSMakeRect(cellFrame.size.width - dueStringWidth,
                              cellFrame.origin.y + 46,
                              dueStringWidth,
                              cellFrame.size.height) 
   withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSColor grayColor], NSForegroundColorAttributeName,
                    textShadow, NSShadowAttributeName,
                    [NSFont systemFontOfSize:9], NSFontAttributeName, nil]];

  // Task list title
  [task.list.name drawInRect: NSMakeRect(cellFrame.origin.x + 26,
                                          cellFrame.origin.y + 45,
                                          cellFrame.size.width - 26,
                                          15) 
               withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSColor lightGrayColor], NSForegroundColorAttributeName,
                                textShadow, NSShadowAttributeName,
                                [NSFont systemFontOfSize:9], NSFontAttributeName, nil]];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView
{
  NSPoint locationInCell = [controlView convertPoint: [event locationInWindow] fromView: nil];
  
  if (NSPointInRect(locationInCell, [self checkboxRectForFrame: cellFrame withBorder: 6]))
  {
    if ([event type] == NSLeftMouseDown)
    {
      [controlView setNeedsDisplayInRect:cellFrame];
      [NSApp sendAction:checkboxClickedAction to:[self target] from:[self controlView]];
    }
  }

  return [super hitTestForEvent: event inRect: cellFrame ofView: controlView];
}

@end
