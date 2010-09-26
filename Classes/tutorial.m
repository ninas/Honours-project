//
//  tutorial.m
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "tutorial.h"


@implementation tutorial
@synthesize second;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		
		instructions = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 380, 50)];
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
		
		text = [[NSMutableArray alloc] init];
		
		
		[text addObject:@"Use the menu on the lefthand side of the screen to manipulate the blocks and shape as a whole"];
		[text addObject:@"Write the number 627 on the front of the questionnaire."];
		[text addObject:@"Gestures are used to control block manipulation. A help panel on the lefthand side of the screen displays possible gestures and their meanings. Once you're comfortable with these, the help panel can be hidden by performing a three finger swipe towards the edge of the screen. One can rotate the shape by performing a two finger swipe in the desired direction."];
		[text addObject:@"Write the number 14 on the front of the questionnaire."];
		[text addObject:@"Gameplay is controlled by means of drawn gestures and buttons. A list of the possible gestures is available through the help menu on the bottom left side of the screen. The menu at the top of the left side of the screen contains buttons for further manipulation controls."];
		[text addObject:@"Write the number 382 on the front of the questionnaire."];
		[text addObject:@"Thank you very much for taking part in my experiment."];
		
		
		fullScreen = CGRectMake(0, 0, 1050, 800);
		
		
		first = [[UIButton alloc] initWithFrame:CGRectMake(900, 650, 100, 100)];
		first.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		first.layer.cornerRadius = 5;
		first.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		first.titleLabel.textAlignment = UITextAlignmentCenter;
		[first setTitle:@"Continue" forState:UIControlStateNormal];
		[first addTarget:self action:@selector(showSecondScreen) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:first];
		first.hidden = YES;
		
		
		
		
		wasTraining = YES;
		
		
		
		description = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 1000, 500)];
		description.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
		description.editable = NO;
		description.font = [UIFont systemFontOfSize:25];
		description.textColor = [UIColor whiteColor];
		description.textAlignment = UITextAlignmentCenter;
		
		
		description.text = @"fsdddddddddddddddddd";
		[self addSubview:description];
		description.hidden = YES;
		gameCounter = 0;
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

- (void) showFirstScreen:(int)vers{
	self.frame = fullScreen;
	self.backgroundColor = [UIColor grayColor];
	second.hidden = YES;
	instructions.hidden = NO;
	counter.hidden = YES;
	version = vers;
	if (wasTraining) {
		wasTraining = NO;
		instructions.text = @"Instructions:";
		instructions.frame = CGRectMake(10, 10, 1030, 50);
		instructions.font = [UIFont systemFontOfSize:35];
		
		[self showSecondScreen];
	}
	else {
		gameCounter++;
		first.hidden = NO;
		description.hidden = NO;
		
		description.text = [NSString stringWithFormat:@"Please fill out questionnaire %d\n%@\nOnce you're done, tap continue.",gameCounter,[text objectAtIndex:version*2+1]];
	}

	
}
- (void) showSecondScreen{
	self.frame = fullScreen;
	first.hidden = YES;
	description.text = [NSString stringWithFormat:@"Game %d\n%@",gameCounter+1,[text objectAtIndex:version*2]];
	description.hidden = NO;
	second.hidden = NO;
	instructions.hidden = NO;
	if (gameCounter+1 == 4) {
		description.text = @"Thank you very much for taking part in my experiment.";
		second.hidden = YES;
	}
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
@end
