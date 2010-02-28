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

#import "TaskTableCellGradient.h"


@implementation TaskTableCellGradient

+ (id)taskGradientIsHighlighted:(BOOL)isHighlighted isChecked:(BOOL)isChecked
{
  if (isHighlighted)
  {
    return [TaskTableCellGradient selectedTaskGradient];
  }
  else if (isChecked)
  {
    return [TaskTableCellGradient checkedTaskGradient];
  }
  else
  {
    return [TaskTableCellGradient taskGradient];
  }
}

+ (id)taskGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xFB/255.0 green:0xFB/255.0 blue:0xFB/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0xEB/255.0 green:0xEB/255.0 blue:0xEB/255.0 alpha:0xFF/255.0]];
}

+ (id)selectedTaskGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xFF/255.0 green:0xFE/255.0 blue:0xD0/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0xDC/255.0 green:0xDB/255.0 blue:0xB6/255.0 alpha:0xFF/255.0]];
}

+ (id)checkedTaskGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xFA/255.0 green:0xF9/255.0 blue:0xF0/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0xEB/255.0 green:0xE8/255.0 blue:0xE0/255.0 alpha:0xFF/255.0]];
}

+ (id)priorityGradient:(NSInteger)priority
{
  TaskTableCellGradient* priorityRect;
  switch (priority) {
    case 3:
      priorityRect = [TaskTableCellGradient lowPriorityGradient];
      break;
    case 2:
      priorityRect = [TaskTableCellGradient normalPriorityGradient];
      break;
    case 1:
      priorityRect = [TaskTableCellGradient highPriorityGradient];
      break;
    default:
      priorityRect = [TaskTableCellGradient noPriorityGradient];
      break;
  }
  return [[priorityRect autorelease] retain];
}

+ (id)noPriorityGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xE9/255.0 green:0xE9/255.0 blue:0xE9/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0xD4/255.0 green:0xD4/255.0 blue:0xD4/255.0 alpha:0xFF/255.0]];
}

+ (id)lowPriorityGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0x48/255.0 green:0x9A/255.0 blue:0xF8/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0x3D/255.0 green:0x83/255.0 blue:0xD7/255.0 alpha:0xFF/255.0]];
}

+ (id)normalPriorityGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0x1D/255.0 green:0x60/255.0 blue:0xB9/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0x16/255.0 green:0x4D/255.0 blue:0x95/255.0 alpha:0xFF/255.0]];
}

+ (id)highPriorityGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xD9/255.0 green:0x5A/255.0 blue:0x1E/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0xB7/255.0 green:0x4C/255.0 blue:0x1B/255.0 alpha:0xFF/255.0]];
}

+ (id)checkboxGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xE4/255.0 green:0xE4/255.0 blue:0xE4/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0xF7/255.0 green:0xF7/255.0 blue:0xF7/255.0 alpha:0xFF/255.0]];
}

+ (id)checkedCheckboxGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xE5/255.0 green:0xEE/255.0 blue:0xF8/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0x97/255.0 green:0x9D/255.0 blue:0xA2/255.0 alpha:0xFF/255.0]];
}

@end
