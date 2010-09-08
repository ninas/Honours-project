//
//  feature.m
//  testing
//
//  Created by Nina Schiff on 2010/07/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "feature.h"


@implementation feature
@synthesize next;
@synthesize step;
@synthesize scale;
@synthesize endPos;
@synthesize previous;
@synthesize startDist;
@synthesize chordAngle;
@synthesize maxNum;

- (id) init {
	if ((self = [super init])){
		previous = nil;
		next = nil;
		maxNum=-1;
		chordAngle = 500;
	}
	return self;
}

- (void) setAngles:(CGPoint)secEnd{
	
	
	chordAngle = 180 + (atan2f(secEnd.y-startPos.y,  startPos.x - secEnd.x))*180/3.1415926;
	
	
	
}

- (void) setMaxNum:(int)num{
	maxNum = num;
}

- (void) setChange:(CGPoint)start andEnd:(CGPoint)end{
	endPos.x=end.x-start.x;
	endPos.y = end.y - start.y;
	
	startPos= start;
	
	featureAngle = 180 + (atan2f(endPos.y,  0 - endPos.x))*180/3.1415926;
}

- (void) setNext:(feature *)tempNext{
	next = tempNext;
	
	if (chordAngle == 500) {
		chordAngle = featureAngle;
	}
	
}

- (void) setPrevious:(feature*)tempPrevious {
	previous = tempPrevious;
}

- (void) setScaleD:(float)tempDistance{
	distance = tempDistance;
	if (previous != nil){
		startDist = previous.startDist;
		scale = distance / startDist;
 	}
	else{
		scale = 1.0;
		startDist = distance;
	}
}

- (void) setStep:(int)tempStep{
	step = tempStep;
}

/* Used in averaging */
- (void) incrementAll:(NSArray*) array{
	
	
	endPos.x+=[[array objectAtIndex:0] floatValue];
	endPos.y+=[[array objectAtIndex:1] floatValue];
	scale+=[[array objectAtIndex:2] floatValue];
	chordAngle+=[[array objectAtIndex:3] floatValue];
	
}

/* Returns all defining values packed into a NSArray */
- (NSArray*) getValues{
	NSArray * vals = [NSArray arrayWithObjects:[NSNumber numberWithFloat:endPos.x],[NSNumber numberWithFloat:endPos.y],[NSNumber numberWithFloat:scale],[NSNumber numberWithFloat:chordAngle],nil];
	return vals;
}

/* Average values */
- (void) divideValues:(int)num{
	
	scale/=num;
	endPos.x/=num;
	endPos.y/=num;
	chordAngle/=num;
}

- (void) printValues{
	NSLog(@"\tEnd point: (%f, %f)\t Scale: %f\t Chordangle: %f\n",endPos.x,endPos.y,scale,chordAngle);
}
- (void) resetEnd:(CGPoint)end andDist:(float)dist{
	endPos.x = end.x - startPos.x;
	endPos.y = end.y - startPos.y;
	featureAngle = 180 + (atan2f(endPos.y,  0 - endPos.x))*180/3.1415926;
	
	distance+=dist;
	if (previous != nil){
		
		scale = distance / startDist;
 	}
	else{
		
		startDist = distance;
	}
}
- (void) dealloc{
	[super dealloc];
	
		
	
	
	
}
@end
