//
//  testingAppDelegate.h
//  testing
//
//  Created by Nina Schiff on 2010/06/17.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class testingViewController;
@interface testingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	testingViewController * viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) testingViewController *viewController;

@end

