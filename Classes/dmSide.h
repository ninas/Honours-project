//
//  gesturePanel.h
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameMechanics.h"

@interface dmSide : UIView {
	
	
	NSMutableArray * lineButtons;
	NSMutableArray * swapButtons;
	NSMutableArray * rotateButtons;
	
	NSMutableArray * descriptions;
	GameMechanics * mechanics;
	UIButton * hide;
	
	UITextView * otherControls;
	UILabel * descripLabel;
	UILabel * secLabel;
	
}


- (void) setupLine;
- (void) setupSwap;
- (void) setupRotate;

- (void) fadeOut;
- (void) fadeIn;
- (void) setup:(GameMechanics*)mech;

@property (nonatomic, retain) UIButton * hide;
@property (nonatomic, retain) NSMutableArray * lineButtons;
@property (nonatomic, retain) NSMutableArray * swapButtons;
@property (nonatomic, retain) NSMutableArray * rotateButtons;
@end
