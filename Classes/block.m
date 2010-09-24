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
@synthesize newX;
@synthesize newY;
@synthesize newZ;
@synthesize toTrans;
@synthesize upX;
@synthesize upY;
@synthesize upZ;

- (id) init{
	
	colour = rand()%4;
	toTrans = NO;
	return self;
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ andPlacement:(block****)placementA{
	x=tempX;
	y=tempY;
	z=tempZ;
	upX = x;
	upY=y;
	upZ=z;
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

- (BOOL) updatePos{
	//NSLog(@"Current pos:   %f   %f   %f",newX,newY,newZ);
	newX+=increX;
	newY+=increY;
	newZ+=increZ;
	
	if (counter==20) {
		x = upX;
		y = upY;
		z = upZ;
		return YES;
	}
	counter++;
	return NO;
	
	
}

- (void) setNewPos:(int)nX andY:(int)nY andZ:(int)nZ{
	x = upX;
	y = upY;
	z = upZ;
	
	newX = (float)x;
	newY = (float)y;
	newZ = (float)z;
	
	upX=nX;
	upY=nY;
	upZ=nZ;
	
	counter = 0;
	
	increX = (upX - x)/20.0;
	increY = (upY - y)/20.0;
	increZ = (upZ - z)/20.0;
}

- (void) preTrans{
	upX=x;
	upY=y;
	upZ=z;
	//NSLog(@"1111111111111111111old (%d, %d, %d)    new:(%d, %d, %d)",x,y,z,newX,newY,newZ);
}

- (void) setNewPos2{
	/*x = upX;
	y = upY;
	z = upZ;*/
	
	newX = (float)x;
	newY = (float)y;
	newZ = (float)z;
	//NSLog(@"old (%d, %d, %d)    new:(%d, %d, %d)",x,y,z,newX,newY,newZ);
	/*upX=nX;
	upY=nY;
	upZ=nZ;*/
	
	counter = 0;
	
	increX = (upX - x)/20.0;
	increY = (upY - y)/20.0;
	increZ = (upZ - z)/20.0;
}

@end
