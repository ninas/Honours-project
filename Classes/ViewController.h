//
//  ViewController.h
//  tester
//
//  Created by Nina Schiff on 2010/09/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureStateMachine.h"

#import "tutorial.h"

@class EAGLView;
@interface ViewController : UIViewController {
	EAGLView * glView;
	tutorial * tut;
	
}

@property (nonatomic, retain) IBOutlet EAGLView * glView;


@end
