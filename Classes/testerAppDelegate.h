//
//  testerAppDelegate.h
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"



@interface testerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    //EAGLView *glView;
	ViewController * viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ViewController *viewController;

@end

