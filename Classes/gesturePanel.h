//
//  gesturePanel.h
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface gesturePanel : UIView {
	
	
	NSMutableArray * lineButtons;
	NSMutableArray * swapButtons;
	
	
	
	UIButton * hide;
	
}

- (void) rowLeft;
- (void) setupLine;
- (void) setupSwap;
- (void) setupOther;
- (void) fadeOut;
- (void) fadeIn;

@property (nonatomic, retain) UIButton * hide;
@end
