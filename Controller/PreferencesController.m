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

#import "PreferencesController.h"


@implementation PreferencesController

@synthesize frob;

- (id)initWithPreferences:(AppPreferences*)aPref andRtmConnector:(EZMilk*)anRtmApi
{
  prefHolder = aPref;
  rtmService = anRtmApi;

  return [self init];
}

- (id)init
{
  if (!(self = [super initWithWindowNibName:@"Preferences"]))
  {
    return nil;
  }

  return self;
}

- (void)dealloc
{
  [frob release];

  [super dealloc];
}

- (void)awakeFromNib
{
  [toolbar setSelectedItemIdentifier:[[[toolbar items] objectAtIndex:0] itemIdentifier]];
  [[self window] orderFront:self];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)aToolbar
{
  NSMutableArray *allIdentifiers = [[NSMutableArray alloc] init];
  
  for (NSToolbarItem *toolbarItem in [aToolbar items])
  {
    if (![[toolbarItem label] isEqualToString:@"Inspect"])
    {
      [allIdentifiers addObject:[toolbarItem itemIdentifier]];
    }
  }
  
  return [allIdentifiers autorelease];
}

- (IBAction)generalShow:(id)sender
{
  [tabView selectTabViewItemWithIdentifier:@"general"];
}

- (IBAction)notificationsShow:(id)sender
{
  [tabView selectTabViewItemWithIdentifier:@"notifications"];
}

- (IBAction)rtmShow:(id)sender
{
  if ([prefHolder rtmToken])
  {
    [tabView selectTabViewItemWithIdentifier:@"rtm"];
  }
  else if (frob)
  {
    [tabView selectTabViewItemWithIdentifier:@"rtm_auth_step2"];
  }
  else
  {
    [tabView selectTabViewItemWithIdentifier:@"rtm_auth_step1"];
  }
}

- (IBAction)connectToRtmStepOne:(id)sender
{
  NSString* aFrob = [rtmService frob];
  if (aFrob)
  {
    [self setFrob:aFrob];
    system([[NSString stringWithFormat:@"open '%@'", [rtmService authUrlForPerms:@"delete" withFrob:frob]] UTF8String]);
  }

  [self rtmShow:self];
}

- (IBAction)connectToRtmStepTwo:(id)sender
{
  if (frob)
  {
    NSString* token = [rtmService tokenWithFrob:frob];
    if (token)
    {
      [prefHolder setRtmToken:token];
    }
    [self setFrob:nil];
  }

  [self rtmShow:self];
}

- (IBAction)resetRtmAuth:(id)sender
{
  [prefHolder setRtmToken:nil];
  [self rtmShow:self];
}

@end
