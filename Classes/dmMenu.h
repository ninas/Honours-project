//
//  sidePanel.h
//  tester
//
//  Created by Nina Schiff on 2010/09/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "dmSide.h"
#import "GameMechanics.h"

@interface dmMenu : UIView {
	UIButton * line;
	UIButton * swap;
	UIButton * moveT;
	UIButton * rock;
	UIButton * rotate;
	
	dmSide * gestPanel;
	
	BOOL lineVis;
	BOOL swapVis;
	BOOL moveVis;
	BOOL rockVis;
	BOOL rotateVis;
	
	
	GameMechanics * mechanics;
	
}
- (void) moveRow;

- (void) swapB;
- (void) move;
- (void) rockB;
- (void) clearOthers;

-(void) enable;
-(void) disable;
- (void) setup:(GameMechanics*)mech;

@property (nonatomic, retain) UIButton * rock;
@property (nonatomic, retain) UIButton * rotate;
@property (nonatomic, retain) dmSide * gestPanel;
@property BOOL rotateVis;
@property BOOL lineVis;
@property BOOL swapVis;

@end
