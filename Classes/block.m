//
//  block.m
//  tester
//  Stores information for each individual block in the game.
//
//  Created by Nina Schiff on 2010/08/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "block.h"
#import <math.h>

@implementation block
@synthesize x;
@synthesize y;
@synthesize z;
@synthesize colour;

- (id) init{
	
	colour = rand()%3;
	
	return self;
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ{
	x=tempX;
	y=tempY;
	z=tempZ;
	
}


@end
