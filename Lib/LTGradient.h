//
//  RTGradient.h
//  RTTasks
//
//  Created by ever.zet on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTGradient.h"

@interface LTGradient : CTGradient {

}

+ (id)taskGradientIsHighlighted:(BOOL)isHighlighted isChecked:(BOOL)isChecked;
+ (id)taskGradient;
+ (id)selectedTaskGradient;
+ (id)checkedTaskGradient;

+ (id)priorityGradient:(NSInteger)priority;
+ (id)noPriorityGradient;
+ (id)lowPriorityGradient;
+ (id)normalPriorityGradient;
+ (id)highPriorityGradient;

+ (id)checkboxGradient;
+ (id)checkboxCheckedGradient;

@end
