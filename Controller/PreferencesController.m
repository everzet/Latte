//
//  LTPreferencesController.m
//  Latte
//
//  Created by ever.zet on 03.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

@synthesize frob;

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
  if ([[Preferences instance] rtmToken])
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
  EZMilk* rtm = [EZMilk instance];

  NSString* aFrob = [rtm frob];
  if (aFrob)
  {
    [self setFrob:aFrob];
    system([[NSString stringWithFormat:@"open '%@'", [rtm authUrlForPerms:@"delete" withFrob:frob]] UTF8String]);
  }

  [self rtmShow:self];
}

- (IBAction)connectToRtmStepTwo:(id)sender
{
  EZMilk* rtm = [EZMilk instance];

  if (frob)
  {
    NSString* token = [rtm tokenWithFrob:frob];
    if (token)
    {
      [[Preferences instance] setRtmToken:token];
    }
    [self setFrob:nil];
  }

  [self rtmShow:self];
}

- (IBAction)resetRtmAuth:(id)sender
{
  [[Preferences instance] setRtmToken:nil];
  [self rtmShow:self];
}

@end
