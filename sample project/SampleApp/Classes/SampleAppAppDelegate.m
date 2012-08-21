//
//  SampleAppAppDelegate.m
//  SampleApp
//
//  Created by honcheng on 11/27/10.
//  Copyright 2010 honcheng. All rights reserved.
//

#import "SampleAppAppDelegate.h"
#import "SamplePanelsViewController.h"
#import "SamplePanelsViewControllerForiPad.h"

@implementation SampleAppAppDelegate


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	id panelsViewController = nil;
	if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
	{
		panelsViewController = [[SamplePanelsViewController alloc] init];
	}
	else if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
	{
		panelsViewController = [[SamplePanelsViewControllerForiPad alloc] init];
	}
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:panelsViewController];
	[[navController navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
	[self.window setRootViewController:navController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
