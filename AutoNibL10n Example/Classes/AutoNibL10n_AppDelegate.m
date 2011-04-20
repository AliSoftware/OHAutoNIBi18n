//
//  AutoNibL10n_AppDelegate.m
//  AutoNibL10n
//
//  Created by Olivier on 17/04/11.
//  Copyright 2011 AliSoftware. All rights reserved.
//

#import "AutoNibL10n_AppDelegate.h"

@implementation AutoNibL10n_AppDelegate
@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

	//label.text = NSLocalizedString(@"greetings",@"Text to say hello"); // NOT NEEDED ANYMORE!
	
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
