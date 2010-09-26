//
//  gesturePanel.m
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "gesturePanel.h"


@implementation gesturePanel
@synthesize hide;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		[self setMultipleTouchEnabled:YES];
		
		UIButton * rowL = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		rowL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rowL.layer.cornerRadius = 5;
		rowL.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rowL.titleLabel.textAlignment = UITextAlignmentCenter;
		[rowL setTitle:@"Move row left" forState:UIControlStateNormal];
		[rowL addTarget:self action:@selector(rowLeft:) forControlEvents:UIControlEventTouchUpInside];
		rowL.adjustsImageWhenHighlighted = YES;
		[self addSubview:rowL];
		rowL.hidden = YES;
		
		UIButton * rowR = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 80, 80)];
		rowR.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rowR.layer.cornerRadius = 5;
		rowR.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rowR.titleLabel.textAlignment = UITextAlignmentCenter;
		[rowR setTitle:@"Move row right" forState:UIControlStateNormal];
		[rowR addTarget:self action:@selector(rowLeft:) forControlEvents:UIControlEventTouchUpInside];
		rowR.adjustsImageWhenHighlighted = YES;
		[self addSubview:rowR];
		rowR.hidden = YES;
		
		UIButton * columnU = [[UIButton alloc] initWithFrame:CGRectMake(210, 10, 80, 80)];
		columnU.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		columnU.layer.cornerRadius = 5;
		columnU.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		columnU.titleLabel.textAlignment = UITextAlignmentCenter;
		[columnU setTitle:@"Move column up" forState:UIControlStateNormal];
		[columnU addTarget:self action:@selector(rowLeft:) forControlEvents:UIControlEventTouchUpInside];
		columnU.adjustsImageWhenHighlighted = YES;
		[self addSubview:columnU];
		columnU.hidden = YES;
		
		UIButton * columnD = [[UIButton alloc] initWithFrame:CGRectMake(310, 10, 80, 80)];
		columnD.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		columnD.layer.cornerRadius = 5;
		columnD.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		columnD.titleLabel.textAlignment = UITextAlignmentCenter;
		[columnD setTitle:@"Move column down" forState:UIControlStateNormal];
		[columnD addTarget:self action:@selector(rowLeft:) forControlEvents:UIControlEventTouchUpInside];
		columnD.adjustsImageWhenHighlighted = YES;
		[self addSubview:columnD];
		columnD.hidden = YES;
		
		UIButton * backward = [[UIButton alloc] initWithFrame:CGRectMake(410, 10, 80, 80)];
		backward.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		backward.layer.cornerRadius = 5;
		backward.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		backward.titleLabel.textAlignment = UITextAlignmentCenter;
		[backward setTitle:@"Move line backward" forState:UIControlStateNormal];
		[backward addTarget:self action:@selector(rowLeft:) forControlEvents:UIControlEventTouchUpInside];
		backward.adjustsImageWhenHighlighted = YES;
		[self addSubview:backward];
		backward.hidden = YES;
		
		UIButton * forward = [[UIButton alloc] initWithFrame:CGRectMake(510, 10, 80, 80)];
		forward.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		forward.layer.cornerRadius = 5;
		forward.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		forward.titleLabel.textAlignment = UITextAlignmentCenter;
		[forward setTitle:@"Move line forward" forState:UIControlStateNormal];
		[forward addTarget:self action:@selector(rowLeft:) forControlEvents:UIControlEventTouchUpInside];
		forward.adjustsImageWhenHighlighted = YES;
		[self addSubview:forward];
		forward.hidden = YES;
		
		lineButtons = [[NSMutableArray alloc] init];
		[lineButtons addObject:rowL];
		[lineButtons addObject:rowR];
		[lineButtons addObject:columnD];
		[lineButtons addObject:columnU];
		[lineButtons addObject:backward];
		[lineButtons addObject:forward];
		
		UIButton * swapL = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		swapL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapL.layer.cornerRadius = 5;
		swapL.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapL.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapL setTitle:@"Swap block left" forState:UIControlStateNormal];
		[swapL addTarget:self action:@selector(swapMen:) forControlEvents:UIControlEventTouchUpInside];
		swapL.adjustsImageWhenHighlighted = YES;
		[self addSubview:swapL];
		swapL.hidden = YES;
		
		UIButton * swapR = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 80, 80)];
		swapR.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapR.layer.cornerRadius = 5;
		swapR.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapR.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapR setTitle:@"Swap block right" forState:UIControlStateNormal];
		[swapR addTarget:self action:@selector(swapMen:) forControlEvents:UIControlEventTouchUpInside];
		swapR.adjustsImageWhenHighlighted = YES;
		[self addSubview:swapR];
		swapR.hidden = YES;
		
		UIButton * swapU = [[UIButton alloc] initWithFrame:CGRectMake(210, 10, 80, 80)];
		swapU.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapU.layer.cornerRadius = 5;
		swapU.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapU.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapU setTitle:@"Swap block up" forState:UIControlStateNormal];
		
		[swapU addTarget:self action:@selector(swapMen:) forControlEvents:UIControlEventTouchUpInside];
		swapU.adjustsImageWhenHighlighted = YES;
		[self addSubview:swapU];
		swapU.hidden = YES;
		
		UIButton * swapD = [[UIButton alloc] initWithFrame:CGRectMake(310, 10, 80, 80)];
		swapD.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapD.layer.cornerRadius = 5;
		swapD.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapD.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapD setTitle:@"Swap block down" forState:UIControlStateNormal];
		[swapD addTarget:self action:@selector(swapMen:) forControlEvents:UIControlEventTouchUpInside];
		swapD.adjustsImageWhenHighlighted = YES;
		[self addSubview:swapD];
		swapD.hidden = YES;
		
		swapButtons = [[NSMutableArray alloc] init];
		[swapButtons addObject:swapL];
		[swapButtons addObject:swapR];
		[swapButtons addObject:swapD];
		[swapButtons addObject:swapU];
		
		
		otherControls = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 580, 380)];
		otherControls.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
		otherControls.editable = NO;
		otherControls.font = [UIFont systemFontOfSize:25];
		otherControls.textColor = [UIColor whiteColor];
		otherControls.text = @"The shape can be rotated by swiping in the desired direction with two fingers.\n\nThe help panel can be hidden by using three fingers and swiping towards the left edge of the screen. Swiping from the left edge inwards shows the panel again";
		[self addSubview:otherControls];
		otherControls.hidden = YES;
		
		descriptions = [[NSMutableArray alloc] init];
		[descriptions addObject:@"Rotates an entire row left"];
		[descriptions addObject:@"Rotates an entire row right"];
		[descriptions addObject:@"Rotates an entire column down"];
		[descriptions addObject:@"Rotates an entire column up"];
		[descriptions addObject:@"Moves blocks one place forward"];
		[descriptions addObject:@"Moves blocks one place backward"];
		[descriptions addObject:@"Swap block with block to its left"];
		[descriptions addObject:@"Swap block with block to its right"];
		[descriptions addObject:@"Swap block with block below it"];
		[descriptions addObject:@"Swap block with block above it"];
		
		descripLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, 490, 40)];
		descripLabel.text=@"";
		descripLabel.textAlignment = UITextAlignmentCenter;
		descripLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1]; 
		descripLabel.textColor = [UIColor whiteColor];
		
		descripLabel.font = [UIFont systemFontOfSize:25];
		[self addSubview:descripLabel];
		descripLabel.hidden = YES;
		
		
		secLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, 490, 30)];
		secLabel.text=@"The dot indicates the start of the gesture.";
		secLabel.textAlignment = UITextAlignmentLeft;
		secLabel.backgroundColor = [UIColor clearColor] ; 
		secLabel.textColor = [UIColor whiteColor];
		
		secLabel.font = [UIFont systemFontOfSize:16];
		[self addSubview:secLabel];
		secLabel.hidden = YES;
		
	}
	
	return self;
}

- (void) rowLeft:(id)select{
	descripLabel.hidden = NO;
	secLabel.hidden = NO;
	for (int i=0; i<lineButtons.count; i++) {
		UIButton * temp = [lineButtons objectAtIndex:i];
		if (temp == select) {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
			descripLabel.text = [descriptions objectAtIndex:i];
		}
		else {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		}
		
	}
}

- (void) swapMen:(id)select{
	descripLabel.hidden = NO;
	secLabel.hidden = NO;
	for (int i=0; i<swapButtons.count; i++) {
		UIButton * temp = [swapButtons objectAtIndex:i];
		if (temp == select) {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
			descripLabel.text = [descriptions objectAtIndex:i+6];
		}
		else {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		}
		
	}
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
	
	hide.hidden = NO;
}

- (void) setupOther:(int)num{
	otherControls.hidden = YES;
	descripLabel.hidden = NO;
	secLabel.hidden = NO;
	for (int i=0; i<lineButtons.count; i++) {
		[[lineButtons objectAtIndex:i] setHidden:YES];
		[[lineButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	for (int i=0; i<swapButtons.count; i++) {
		[[swapButtons objectAtIndex:i] setHidden:YES];
		[[swapButtons objectAtIndex:i] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
	}
	
	hide.hidden = NO;
	
	if (num == 0) {
		// move together
		descripLabel.text = @"Moves blocks together, removing any gaps";
	}
	else if (num == 1){
		// rocking cube
		descripLabel.text = @"Rocks shape slightly";
		
	}
	else {
		// other options
		descripLabel.hidden = YES;
		otherControls.hidden = NO;
		secLabel.hidden = YES;
	}
	
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
