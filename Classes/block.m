//
//  block.m
//  tester
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
@synthesize rotX;
@synthesize rotY;
@synthesize rotZ;
- (id) init{
	
	colour = rand()%3;
	
	return self;
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ{
	x=tempX;
	y=tempY;
	z=tempZ;
	rotX = x;
	rotY = y;
	rotZ = z;
}

- (void) moveRow:(int)minX andY:(int)minY andZ:(int)minZ{
	
}
- (void) rotatePos:(float)xRot andY:(float)yRot{
	
	
	
	if (xRot !=0) {
			//NSLog(@"Rot x: %d %d %d", rotX, rotY, rotZ);
		//NSLog(@"xRot:    %f",xRot);
		xRot = xRot*M_PI/180.0;
		//NSLog(@"xRot:    %f",xRot);
		float newX = rotZ*sinf(xRot) + rotX*cosf(xRot);
		float newZ = rotZ*cosf(xRot) - rotX*sinf(xRot);
		rotX = newX;
		rotZ = newZ;
		
		//NSLog(@"Rot x: %d %d %d", rotX, rotY, rotZ);
	}
	else if (yRot!=0){
		yRot = yRot*M_PI/180.0;
		
		float newY = rotY*cosf(yRot) - rotZ*sinf(yRot);
		float newZ = rotY*sinf(yRot) + rotZ*cosf(yRot);
		rotY = newY;
		rotZ= newZ;
		
	}
	
}
@end
