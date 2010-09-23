//
//  sidePanel.m
//  tester
//
//  Created by Nina Schiff on 2010/09/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "sidePanel.h"


@implementation sidePanel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
		//self.layer.cornerRadius = 5;
		[self setMultipleTouchEnabled:YES]; 
		
    }
    return self;
}

- (void) slideIn{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.75];
	self.frame = CGRectMake(10, 10, 100, 750);	
	[UIView commitAnimations];
}

- (void) slideOut{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.75];
	self.frame = CGRectMake(-100,10,100,750);	
	[UIView commitAnimations];
}




@end
