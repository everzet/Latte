//
//  RTGradient.m
//  RTTasks
//
//  Created by ever.zet on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LTGradient.h"


@implementation LTGradient

+ (id)taskGradientIsHighlighted:(BOOL)isHighlighted isChecked:(BOOL)isChecked
{
  if (isHighlighted)
  {
    return [LTGradient selectedTaskGradient];
  }
  else if (isChecked)
  {
    return [LTGradient checkedTaskGradient];
  }
  else
  {
    return [LTGradient taskGradient];
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
  LTGradient* priorityRect;
  switch (priority) {
    case 3:
      priorityRect = [LTGradient lowPriorityGradient];
      break;
    case 2:
      priorityRect = [LTGradient normalPriorityGradient];
      break;
    case 1:
      priorityRect = [LTGradient highPriorityGradient];
      break;
    default:
      priorityRect = [LTGradient noPriorityGradient];
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

+ (id)checkboxCheckedGradient
{
  return [self gradientWithBeginningColor: [NSColor colorWithCalibratedRed:0xE5/255.0 green:0xEE/255.0 blue:0xF8/255.0 alpha:0xFF/255.0]
                              endingColor: [NSColor colorWithCalibratedRed:0x97/255.0 green:0x9D/255.0 blue:0xA2/255.0 alpha:0xFF/255.0]];
}

@end
