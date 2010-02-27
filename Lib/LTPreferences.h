//
//  LTPreferences.h
//  Latte
//
//  Created by ever.zet on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LTPreferences : NSObject {
  NSUserDefaults* userDefaults;
}

+ (LTPreferences*)instance;

- (NSString*)rtmToken;
- (void)setRtmToken:(NSString*)aToken;
- (NSInteger)rtmSyncInterval;
- (void)setRtmSyncInterval:(NSInteger)anInterval;

@end
