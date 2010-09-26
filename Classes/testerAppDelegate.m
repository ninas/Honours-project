//
//  testerAppDelegate.m
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "testerAppDelegate.h"


@implementation testerAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[window addSubview:viewController.view];
	
    [window makeKeyAndVisible];
	
    //[glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   //[glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   //[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   //[glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    //[glView release];
	[viewController release];
    [super dealloc];
}

@end
