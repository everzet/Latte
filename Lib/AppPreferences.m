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

#import "AppPreferences.h"


#define UD_RTM_TOKEN_KEY @"rtm.token"
#define UD_RTM_SYNC_KEY @"rtm.sync.interval"

@implementation AppPreferences

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

  return self;
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
