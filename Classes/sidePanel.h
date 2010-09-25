//
//  sidePanel.h
//  tester
//
//  Created by Nina Schiff on 2010/09/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "gesturePanel.h"

@interface sidePanel : UIView {
	UIButton * line;
	UIButton * swap;
	UIButton * moveT;
	UIButton * rock;
	UIButton * other;
	
	gesturePanel * gestPanel;
	
	BOOL lineVis;
	BOOL swapVis;
	BOOL moveVis;
	BOOL rockVis;
	BOOL otherVis;
	int version;
	
}
- (void) moveRow;
- (void) slideIn;
- (void) slideOut;
- (void) swapB;
- (void) move;
- (void) rockB;
- (void) otherC;
- (void) setGest:(gesturePanel*)gg;
- (void) hideWindow;



@end
