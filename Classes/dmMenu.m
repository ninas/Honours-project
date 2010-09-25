//
//  sidePanel.m
//  tester
//
//  Created by Nina Schiff on 2010/09/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "dmMenu.h"


@implementation dmMenu
@synthesize rock;
@synthesize rotate;
@synthesize gestPanel;
@synthesize rotateVis;
@synthesize swapVis;
@synthesize lineVis;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		
		
		
		
		
		
    }
    return self;
}

- (void) setup:(GameMechanics *)mech{
	mechanics = mech;
	
	
	gestPanel = nil;
	
	lineVis = NO;
	swapVis = NO;
	rockVis = NO;
	moveVis = NO;
	//self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
	//self.layer.cornerRadius = 5;
	 
	
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
	
	
	
	
}









- (void) moveRow{
	gestPanel.hidden = NO;
	if (swapVis || rockVis || moveVis || rotateVis) {
		
		[gestPanel fadeOut];
		swapVis = NO;
		rockVis = NO;
		moveVis = NO;
		rotateVis = NO;
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	if (lineVis) {
		[gestPanel fadeOut];
		
		lineVis = NO;
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		
	}
	else{
		
		[gestPanel setupLine];
		[gestPanel setFrame:CGRectMake(120, 10, 100, 600)];
		[gestPanel fadeIn];
		lineVis = YES;
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
		
		
	}
	
	
}

- (void) swapB{
	gestPanel.hidden = NO;
	if (lineVis || rockVis || moveVis || rotateVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		rockVis = NO;
		moveVis = NO;
		rotateVis = NO;
		
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		
	}
	
	if (swapVis) {
		[gestPanel fadeOut];
		
		swapVis = NO;
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	else{
		
		[gestPanel setupSwap];
		[gestPanel setFrame:CGRectMake(120, 120, 100, 410)];
		[gestPanel fadeIn];
		swapVis = YES;
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
	}
	
	
}

- (void) move{
	
	if (lineVis || rockVis || swapVis || rotateVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		rockVis = NO;
		swapVis = NO;
		rotateVis = NO;
		
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	}
	
	
		
		
		
		
		
	[mechanics moveIn];
		
	
	
}

- (void) rockB{
	gestPanel.hidden = NO;
	if (lineVis || moveVis || swapVis || rotateVis) {
		
		[gestPanel fadeOut];
		lineVis = NO;
		moveVis = NO;
		swapVis = NO;
		rotateVis = NO;
		
		swap.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		moveT.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		
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

- (void) clearOthers{
	
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
	
	
}

@end
