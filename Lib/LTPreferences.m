//
//  LTPreferences.m
//  Latte
//
//  Created by ever.zet on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LTPreferences.h"


#define UD_RTM_TOKEN_KEY @"rtm.token"
#define UD_RTM_SYNC_KEY @"rtm.sync.interval"

static LTPreferences* LTPreferencesInstance;

@implementation LTPreferences

- (id)init
{
  if (!(self = [super init]))
  {
    return nil;
  }

  // Default values
  NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
  [defaultValues setObject:[NSNumber numberWithInt:10] forKey:UD_RTM_SYNC_KEY];

  userDefaults = [[NSUserDefaults standardUserDefaults] retain];
  [userDefaults registerDefaults:defaultValues];

  LTPreferencesInstance = self;

  return self;
}

+ (LTPreferences*)instance
{
  return LTPreferencesInstance;
}

- (NSString*)rtmToken
{
  return [userDefaults objectForKey:UD_RTM_TOKEN_KEY];
}

- (void)setRtmToken:(NSString*)aToken
{
  [userDefaults setObject:aToken forKey:UD_RTM_TOKEN_KEY];
}

- (NSInteger)rtmSyncInterval
{
  return [[userDefaults objectForKey:UD_RTM_SYNC_KEY] integerValue];
}

- (void)setRtmSyncInterval:(NSInteger)anInterval
{
  [userDefaults setObject:[NSNumber numberWithInt:anInterval] forKey:UD_RTM_SYNC_KEY];
}

- (void)dealloc
{
  [userDefaults synchronize];
  [userDefaults release];

  [super dealloc];
}

@end
