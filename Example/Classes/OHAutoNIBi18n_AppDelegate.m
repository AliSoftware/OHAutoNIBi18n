//
//  OHAutoNIBi18n_AppDelegate.m
//  OHAutoNIBi18n
//
//  Created by Olivier on 17/04/11.
//  Copyright 2011 AliSoftware. All rights reserved.
//

#import "OHAutoNIBi18n_AppDelegate.h"
#import "MainViewController.h"

@implementation OHAutoNIBi18n_AppDelegate
@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MainViewController new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
