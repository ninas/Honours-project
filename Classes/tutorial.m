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
		instructions.font = [UIFont systemFontOfSize:18];
		
		[self addSubview:instructions];
		
		instruct2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 380, 100)];
		instruct2.lineBreakMode = UILineBreakModeWordWrap;
		instruct2.textAlignment = UITextAlignmentCenter;
		instruct2.text = @"The black dot indicates the beginning of the gesture.";
		instruct2.font = [UIFont systemFontOfSize:15];
		instruct2.backgroundColor = [UIColor clearColor] ;
		instruct2.textColor = [UIColor whiteColor];
		
		
		[self addSubview:instruct2];
		
		
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
		
		images = [[NSMutableArray alloc] init];
		
		[images addObject:@"rowL.png"];
		[images addObject:@"rowR.png"];
		[images addObject:@"colU.png"];
		[images addObject:@"colD.png"];
		[images addObject:@"forward.png"];
		[images addObject:@"backward.png"];
		[images addObject:@"z.png"];
		[images addObject:@"sL.png"];
		[images addObject:@"sR.png"];
		[images addObject:@"sD.png"];
		[images addObject:@"sU.png"];
		[images addObject:@"square.png"];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
		imageView.opaque = YES;
		[self addSubview:imageView];
		[imageView setImage:[UIImage imageNamed:[images objectAtIndex:currentGesture]]];
		
		/*CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 109.0f);
		UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
		[myImage setImage:[UIImage imageNamed:@"myImage.png"]];
		myImage.opaque = YES; // explicitly opaque for performance
		[self.view addSubview:myImage];
		[myImage release];*/
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
		if (currentGesture < 12) {
			[imageView setImage:[UIImage imageNamed:[images objectAtIndex:currentGesture]]];
		}
		
	}
	
	counter.text = [NSString stringWithFormat:@"%d", gesCounter];
	return ans;
}

- (void) showFirstScreen:(int)vers{
	self.frame = fullScreen;
	self.backgroundColor = [UIColor grayColor];
	second.hidden = YES;
	imageView.hidden = YES;
	instruct2.hidden = YES;
	instructions.hidden = NO;
	counter.hidden = YES;
	version = vers;
	if (wasTraining) {
		wasTraining = NO;
		instructions.text = @"Instructions:";
		instructions.frame = CGRectMake(10, 10, 1030, 50);
		instructions.font = [UIFont systemFontOfSize:35];
		first.hidden = NO;
		description.hidden = NO;
		
		description.text = [NSString stringWithFormat:@"The aim of this game is to get as high a score as possible.\n\nThe game consists of a number of different coloured blocks placed in a cube shape. These can be removed from the screen by grouping them into sets of 3 or more blocks of the same colour. Points are awarded for the number of blocks removed at one time.\n\nThere are a number of possible block manipulations that can be performed in order to rearrange blocks so that they can be removed. These include rotating an entire row or column and moving blocks backwards and forwards within the overall shape. Blocks can also be swapped with their neighbours. In addition, as gaps may be left when blocks are removed, one can move all blocks back in towards the centre.\n\nAs the shape is three dimensional, there are also controls for rotating it.\n\nIf you get stuck, or can no longer remove any more blocks, tap the New Game button and try and beat your previous score.\n\nGood luck!"];
		//[self showSecondScreen];
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
