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

- (id) init {
	if ((self = [super init])){
		previous = nil;
		next = nil;
		maxNum=-1;
	}
	return self;
}

- (void) setLine:(float)tempA andB:(float)tempB andC:(float)tempC{
	a = tempA;
	b = tempB;
	c = tempC;
}

- (void) setMaxNum:(int)num{
	maxNum = num;
}

- (void) setChange:(CGPoint)end{
	endPos= end;
}

- (void) setNext:(feature *)tempNext{
	next = tempNext;
	
}

- (void) setPrevious:(feature*)tempPrevious {
	previous = tempPrevious;
}

- (void) setScaleD:(float)tempDistance{
	distance = tempDistance;
	if (previous != nil){
		scale = distance / (*previous).distance;
 	}
	else{
		scale = 1.0;
	}
}

- (void) setStep:(int)tempStep{
	step = tempStep;
}

/* Used in averaging */
- (void) incrementAll:(NSArray*) array{
	a+=[[array objectAtIndex:0] floatValue] ;
	b+=[[array objectAtIndex:1] floatValue];
	c+=[[array objectAtIndex:2] floatValue];
	scale+=[[array objectAtIndex:3] floatValue];
	endPos.x+=[[array objectAtIndex:4] CGPointValue].x;
	endPos.y+=[[array objectAtIndex:4] CGPointValue].y;
	
}

/* Returns all defining values packed into a NSArray */
- (NSArray*) getValues{
	NSArray * vals = [NSArray arrayWithObjects:[NSNumber numberWithFloat:a], [NSNumber numberWithFloat:b], [NSNumber numberWithFloat:c],[NSNumber numberWithFloat:scale],[NSValue valueWithCGPoint:endPos],nil];
	return vals;
}

/* Average values */
- (void) divideValues:(int)num{
	a/=num;
	b/=num;
	c/=num;
	scale/=num;
	endPos.x/=num;
	endPos.y/=num;
}

- (void) printValues{
	NSLog(@"\ta: %f\n\tb: %f\n\tc: %f\n\tscale: %f\n\tEnd point: (%f, %f)\n",a,b,c,scale,endPos.x,endPos.y);
}

- (void) dealloc{
	[super dealloc];
	
		
	
	
	
}
@end
