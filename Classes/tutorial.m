//
//  tutorial.m
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "tutorial.h"


@implementation tutorial

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		
		UILabel * instructions = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 380, 50)];
		instructions.text = @"Please draw the following gesture 10 times:";
		
		instructions.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5] ;
		instructions.textColor = [UIColor whiteColor];
		instructions.lineBreakMode = UILineBreakModeWordWrap;
		instructions.textAlignment = UITextAlignmentCenter;
		
		[self addSubview:instructions];
		
		
		counter = [[UILabel alloc] initWithFrame:CGRectMake(340, 270, 50, 35)];
		counter.text = @"10";
		
		counter.backgroundColor = [UIColor clearColor];
		counter.textColor = [UIColor whiteColor];
		counter.lineBreakMode = UILineBreakModeWordWrap;
		counter.textAlignment = UITextAlignmentCenter;
		counter.font = [UIFont fontWithName: @"Courier New" size: 35];
		[self addSubview:counter];
		
		currentGesture = 0;
		gesCounter = 10;
	}
	
	return self;
}

- (BOOL) incrementGes:(int)type{
	BOOL ans = NO;
	if (type == currentGesture) {
		gesCounter--;
		ans = YES;
	}
	
	if (gesCounter == 0 && type == currentGesture) {
		gesCounter = 10;
		currentGesture++;
		// load next gesture
	}
	
	counter.text = [NSString stringWithFormat:@"%d", gesCounter];
	return ans;
}
@end
