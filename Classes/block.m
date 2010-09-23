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

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ andPlacement:(block****)placementA{
	x=tempX;
	y=tempY;
	z=tempZ;
	placementArray = placementA;
	
}

- (void) checkRemoval:(NSMutableArray*)toRemove andCol:(int)col andX:(int)cX andY:(int)cY andZ:(int)cZ{
	if (colour != col || (checkX == cX && checkY == cY && checkZ == cZ)) {
		return;
	}
	[toRemove addObject:self];
	checkX = cX;
	checkY = cY;
	checkZ = cZ;
	
	if (x+1 <= 5) {
		[placementArray[x+6][y+5][z+5] checkRemoval:toRemove andCol:col andX:cX andY:cY andZ:cZ];
	}
	if (x - 1 >=-5) {
		[placementArray[x+4][y+5][z+5] checkRemoval:toRemove andCol:col andX:cX andY:cY andZ:cZ];
	}
	if (y + 1 <=5) {
		[placementArray[x+5][y+6][z+5] checkRemoval:toRemove andCol:col andX:cX andY:cY andZ:cZ];
	}
	if (y - 1 >=-5) {
		[placementArray[x+5][y+4][z+5] checkRemoval:toRemove andCol:col andX:cX andY:cY andZ:cZ];
	}
	if (z + 1 <= 5) {
		[placementArray[x+5][y+5][z+6] checkRemoval:toRemove andCol:col andX:cX andY:cY andZ:cZ];
	}
	if (z - 1 >= -5) {
		[placementArray[x+5][y+5][z+4] checkRemoval:toRemove andCol:col andX:cX andY:cY andZ:cZ];
	}
	
	
	
}

- (void) checkConnection{
	
}

@end
