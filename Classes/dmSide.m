//
//  gesturePanel.m
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "dmSide.h"


@implementation dmSide
@synthesize hide;
@synthesize swapButtons;
@synthesize lineButtons;
@synthesize rotateButtons;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		
		
		
		
		
				
	}
	
	return self;
}


- (void) setup:(GameMechanics *)mech{
	mechanics = mech;
	
	
	
}

- (void) setupLine{
	
	otherControls.hidden = YES;
	for (int i=0; i<lineButtons.count; i++) {
		[[lineButtons objectAtIndex:i] setHidden:NO];
		[[lineButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<swapButtons.count; i++) {
		[[swapButtons objectAtIndex:i] setHidden:YES];
		[[swapButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<rotateButtons.count; i++) {
		[[rotateButtons objectAtIndex:i] setHidden:YES];
		[[rotateButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	
	hide.hidden = NO;
}

- (void) setupRotate{
	
	otherControls.hidden = YES;
	for (int i=0; i<rotateButtons.count; i++) {
		[[rotateButtons objectAtIndex:i] setHidden:NO];
		[[rotateButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<swapButtons.count; i++) {
		[[swapButtons objectAtIndex:i] setHidden:YES];
		[[swapButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<lineButtons.count; i++) {
		[[lineButtons objectAtIndex:i] setHidden:YES];
		[[lineButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	
	hide.hidden = NO;
}

- (void) setupSwap{
	otherControls.hidden = YES;
	for (int i=0; i<lineButtons.count; i++) {
		[[lineButtons objectAtIndex:i] setHidden:YES];
		[[lineButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<swapButtons.count; i++) {
		[[swapButtons objectAtIndex:i] setHidden:NO];
		[[swapButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<rotateButtons.count; i++) {
		[[rotateButtons objectAtIndex:i] setHidden:YES];
		[[rotateButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	
	hide.hidden = NO;
}





- (void) fadeOut{
	
	/*[UIView beginAnimations:nil context:NULL];
	 
	 [UIView setAnimationDuration:0.5];
	 [self setAlpha:0.0];
	 [UIView commitAnimations];*/
	self.hidden = YES;
	
	
	
	
}
- (void) fadeIn{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.75];
	[self setAlpha:90];
	[UIView commitAnimations];
}
@end
