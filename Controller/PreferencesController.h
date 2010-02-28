//
//  LTPreferencesController.h
//  Latte
//
//  Created by ever.zet on 03.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Preferences library
#import "AppPreferences.h"

// RTM library
#import "RTMKeys.h"
#import "EZMilk.h"

@interface PreferencesController : NSWindowController {
  IBOutlet NSTabView*   tabView;
  IBOutlet NSToolbar*   toolbar;

  IBOutlet NSTextField* rtmText;
  IBOutlet NSButton*    rtmButton;

  // AppPreferences & EZMilk libs
  AppPreferences*       preferences;
  EZMilk*               rtmApi;

  // RTM FROB string
  NSString*             frob;
}

@property (retain) NSString* frob;

- (id)initWithPreferences:(AppPreferences*)aPref andRtmConnector:(EZMilk*)anRtmApi;

- (IBAction)generalShow:(id)sender;
- (IBAction)notificationsShow:(id)sender;
- (IBAction)rtmShow:(id)sender;

- (IBAction)connectToRtmStepOne:(id)sender;
- (IBAction)connectToRtmStepTwo:(id)sender;
- (IBAction)resetRtmAuth:(id)sender;

@end
