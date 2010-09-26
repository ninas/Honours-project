//
//  sidePanel.m
//  tester
//
//  Created by Nina Schiff on 2010/09/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "sidePanel.h"


@implementation sidePanel
@synthesize restart;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		gestPanel = nil;
		
		lineVis = NO;
		swapVis = NO;
		rockVis = NO;
		moveVis = NO;
        //self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
		//self.layer.cornerRadius = 5;
		[self setMultipleTouchEnabled:YES]; 
		
		line = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		line.layer.cornerRadius = 5;
		line.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		line.titleLabel.textAlignment = UITextAlignmentCenter;
		[line setTitle:@"Move\nline" forState:UIControlStateNormal];
		
		[line addTarget:self action:@selector(moveRow) forControlEvents:UIControlEventTouchUpInside];
		//line.adjustsImageWhenHighlighted = YES;
		[self addSubview:line];
		
				
		
		
		
		swap = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 80, 80)];
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swap.layer.cornerRadius = 5;
		swap.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swap.titleLabel.textAlignment = UITextAlignmentCenter;
		[swap setTitle:@"Swap\nblocks" forState:UIControlStateNormal];
		[swap addTarget:self action:@selector(swapB) forControlEvents:UIControlEventTouchUpInside];
		swap.adjustsImageWhenHighlighted = YES;
		[self addSubview:swap];
		
		moveT = [[UIButton alloc] initWithFrame:CGRectMake(10, 210, 80, 80)];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.layer.cornerRadius = 5;
		moveT.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		moveT.titleLabel.textAlignment = UITextAlignmentCenter;
		[moveT setTitle:@"Move blocks\ntogether" forState:UIControlStateNormal];
		[moveT addTarget:self action:@selector(move) forControlEvents:UIControlEventTouchUpInside];
		moveT.adjustsImageWhenHighlighted = YES;
		[self addSubview:moveT];
		
		rock = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.layer.cornerRadius = 5;
		rock.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rock.titleLabel.textAlignment = UITextAlignmentCenter;
		[rock setTitle:@"Rock shape" forState:UIControlStateNormal];
		[rock addTarget:self action:@selector(rockB) forControlEvents:UIControlEventTouchUpInside];
		rock.adjustsImageWhenHighlighted = YES;
		[self addSubview:rock];
		
		other = [[UIButton alloc] initWithFrame:CGRectMake(10, 410, 80, 80)];
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		other.layer.cornerRadius = 5;
		other.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		other.titleLabel.textAlignment = UITextAlignmentCenter;
		[other setTitle:@"Other controls" forState:UIControlStateNormal];
		[other addTarget:self action:@selector(otherC) forControlEvents:UIControlEventTouchUpInside];
		other.adjustsImageWhenHighlighted = YES;
		[self addSubview:other];
		
		
		
		
		
		
    }
    return self;
}

- (void) disable{
	rock.hidden = YES;
	moveT.hidden = YES;
	other.frame = CGRectMake(10, 210, 80, 80);
	restart.hidden = YES;
	disabled = YES;
	
}

- (void) enable{
	NSLog(@"enabled");
	rock.hidden = NO;
	moveT.hidden = NO;
	other.frame = CGRectMake(10, 410, 80, 80);
	restart.hidden = NO;
	restart.frame = CGRectMake(10, 660, 80, 80);
	disabled = NO;
	
}

- (void) setGest:(gesturePanel*)gg{
	gestPanel = gg;
	
	UIButton * hide = [[UIButton alloc] initWithFrame:CGRectMake(510, 310, 80, 80)];
	hide.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	hide.layer.cornerRadius = 5;
	hide.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	hide.titleLabel.textAlignment = UITextAlignmentCenter;
	[hide setTitle:@"Hide panel" forState:UIControlStateNormal];
	[hide addTarget:self action:@selector(hideWindow) forControlEvents:UIControlEventTouchUpInside];
	hide.adjustsImageWhenHighlighted = YES;
	[gestPanel addSubview:hide];
	hide.hidden = YES;
	
	gestPanel.hide = hide;
	
	
}

- (void) hideWindow{
	[gestPanel fadeOut];
	swapVis = NO;
	rockVis = NO;
	moveVis = NO;
	otherVis = NO;
	lineVis = NO;
	swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
}


- (void) slideIn{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.75];
	if (disabled) {
		self.frame = CGRectMake(10, 10, 100, 300);
	}
	else{
	self.frame = CGRectMake(10, 10, 100, 750);
	}
	[UIView commitAnimations];
	
	//[gestPanel fadeIn];
}

- (void) slideOut{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.75];
	if (disabled) {
		self.frame = CGRectMake(-100, 10, 100, 300);
	}
	else{
	self.frame = CGRectMake(-100,10,100,750);	
	}
	[UIView commitAnimations];
	[self hideWindow];
}


- (void) moveRow{
	gestPanel.hidden = NO;
	if (swapVis || rockVis || moveVis || otherVis) {
		
		[gestPanel fadeOut];
		swapVis = NO;
		rockVis = NO;
		moveVis = NO;
		otherVis = NO;
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	if (lineVis) {
		[gestPanel fadeOut];
		
		lineVis = NO;
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		
	}
	else{
	
	[gestPanel setupLine];
		if (disabled) {
			[gestPanel setFrame:CGRectMake(120, 360, 600, 400)];
		}
		else{
	[gestPanel setFrame:CGRectMake(120, 10, 600, 400)];
		}
	[gestPanel fadeIn];
	lineVis = YES;
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
		
		
	}
	
	
}

- (void) swapB{
	gestPanel.hidden = NO;
	if (lineVis || rockVis || moveVis || otherVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		rockVis = NO;
		moveVis = NO;
		otherVis = NO;
		
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	if (swapVis) {
		[gestPanel fadeOut];
		
		swapVis = NO;
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	else{
		
		[gestPanel setupSwap];
		if (disabled) {
			[gestPanel setFrame:CGRectMake(120, 360, 600, 400)];
		}
		else{
		[gestPanel setFrame:CGRectMake(120, 120, 600, 400)];
		}
		[gestPanel fadeIn];
		swapVis = YES;
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
	}
	
	
}

- (void) move{
	gestPanel.hidden = NO;
	if (lineVis || rockVis || swapVis || otherVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		rockVis = NO;
		swapVis = NO;
		otherVis = NO;
		
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	if (moveVis) {
		[gestPanel fadeOut];
		
		moveVis = NO;
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	else{
		
		[gestPanel setupOther:0];
		[gestPanel setFrame:CGRectMake(120, 220, 600, 400)];
		[gestPanel fadeIn];
		moveVis = YES;
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
	}
	
	
}

- (void) rockB{
	gestPanel.hidden = NO;
	if (lineVis || moveVis || swapVis || otherVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		moveVis = NO;
		swapVis = NO;
		otherVis = NO;
		
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	if (rockVis) {
		[gestPanel fadeOut];
		
		rockVis = NO;
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	else{
		
		[gestPanel setupOther:1];
		[gestPanel setFrame:CGRectMake(120, 320, 600, 400)];
		[gestPanel fadeIn];
		rockVis = YES;
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
	}
	
	
}

- (void) otherC{
	gestPanel.hidden = NO;
	if (lineVis || moveVis || swapVis || rockVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		moveVis = NO;
		swapVis = NO;
		rockVis = NO;
		
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	if (otherVis) {
		[gestPanel fadeOut];
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		otherVis = NO;
		
	}
	else{
		
		[gestPanel setupOther:2];
		if (disabled) {
			[gestPanel setFrame:CGRectMake(120, 360, 600, 400)];
		}
		else{
		[gestPanel setFrame:CGRectMake(120, 360, 600, 400)];
		}
		
		[gestPanel fadeIn];
		otherVis = YES;
		other.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
	}
}

@end
