//
//  testingAppDelegate.m
//  testing
//
//  Created by Nina Schiff on 2010/06/17.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "testingAppDelegate.h"
#import "testingViewController.h"

@implementation testingAppDelegate

@synthesize window;
@synthesize viewController;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	//allocate the view controller
	self.viewController = [testingViewController alloc];
	
	//add the view controller's view to the window
	[window addSubview:self.viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[viewController release];
    [window release];
    [super dealloc];
}


@end
