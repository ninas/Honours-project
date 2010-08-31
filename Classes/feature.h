//
//  feature.h
//  testing
//
//  Created by Nina Schiff on 2010/07/14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface feature : NSObject {
@public
	float a;
	float b;
	float c;
	float scale;
	float distance;
	CGPoint endPos;
	int step;
	feature * next;
	feature * previous;
	int maxNum;

}

- (void) setLine:(float)tempA andB:(float)tempB andC:(float)tempC;
- (void) setChange:(CGPoint)end;
- (void) setPrevious:(feature*)tempPrevious;
- (void) setNext:(feature *)tempNext;
- (void) setScaleD:(float)tempDistance;
- (void) setStep:(int)tempStep;
- (void) setMaxNum:(int)num;
- (void) incrementAll:(NSArray*)array;
- (NSArray*) getValues;
- (void) divideValues:(int)num;
- (void) printValues;

@property (nonatomic, retain) feature * next;
@property int step;
@property float scale;
@property CGPoint endPos;

@end
