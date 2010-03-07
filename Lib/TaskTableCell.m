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

#import "TaskTableCell.h"

@implementation NSColor (BLColor)

// Row alternating color is always light gray
+ (NSArray *)controlAlternatingRowBackgroundColors {
	return [NSArray arrayWithObjects:
          [NSColor whiteColor],
          [NSColor colorWithCalibratedRed:0xF8/255.0 green:0xF8/255.0 blue:0xF8/255.0 alpha:0xFF/255.0],
          nil];
}

@end

@implementation TaskTableCell

@synthesize checkboxClickedAction;

- (NSRect)checkboxRectForFrame:(NSRect)cellFrame
{
  return [self checkboxRectForFrame:cellFrame withBorder:0];
}

- (NSRect)checkboxRectForFrame:(NSRect)cellFrame withBorder:(NSInteger)aBorder
{
  return NSMakeRect(cellFrame.origin.x + 10 - aBorder, cellFrame.origin.y + 5 - aBorder, 10 + (aBorder * 2), 10 + (aBorder * 2));
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
    [[TaskTableCellGradient checkedCheckboxGradient] fillRect:checkboxRect angle:90];

    path = [[NSBezierPath alloc] init];
    [path moveToPoint: NSMakePoint(cellFrame.origin.x + 11, cellFrame.origin.y + 9.5)];
    [path lineToPoint: NSMakePoint(cellFrame.origin.x + 14, cellFrame.origin.y + 12.5)];
    [path lineToPoint: NSMakePoint(cellFrame.origin.x + 19, cellFrame.origin.y + 6.5)];
    [[NSColor whiteColor] set];
    [path setLineWidth: 2];
    [path stroke];
    [path release];
  }
  else
  {
    [[TaskTableCellGradient checkboxGradient] fillRect:checkboxRect angle:90];
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
  [[TaskTableCellGradient taskGradientIsHighlighted:[self isHighlighted] isChecked:task.isCompleted]
   fillRect: NSMakeRect(cellFrame.origin.x - 1, cellFrame.origin.y - 1, cellFrame.size.width + 3, cellFrame.size.height + 2)
      angle: 90];

  // Task priority colored gradient
  [[TaskTableCellGradient priorityGradient: task.priority]
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
                                      cellFrame.origin.y + 2.9,
                                      cellFrame.size.width - 26,
                                      cellFrame.size.height - 18) 
           withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor darkGrayColor], NSForegroundColorAttributeName,
                            textShadow, NSShadowAttributeName,
                            [NSFont systemFontOfSize:11], NSFontAttributeName, nil]];

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

  // Task tags prepare
  NSArray* tags = [task tags];
  NSUInteger count = [tags count];
  NSString* tagsText = [NSString string];

  if (count > 0)
  {
    tagsText = [tagsText stringByAppendingString:[tags objectAtIndex:0]];
    for (NSUInteger i = 1; i < count; i++)
    {
      tagsText = [tagsText stringByAppendingFormat:@", %@", [tags objectAtIndex:i]];
    }
  }

  // Task tags
  [tagsText drawInRect: NSMakeRect(cellFrame.origin.x + 26,
                                             cellFrame.origin.y + 45,
                                             cellFrame.size.width - 70,
                                             15) 
                  withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor colorWithCalibratedRed:0.446 green:0.631 blue:0.827 alpha:1.000],
                                   NSForegroundColorAttributeName,
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
