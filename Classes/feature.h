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
	
	float scale;
	float distance;
	CGPoint endPos;
	CGPoint startPos;
	int step;
	feature * next;
	feature * previous;
	int maxNum;
	float featureAngle;
	float chordAngle;
	float startDist;

}


- (void) setChange:(CGPoint) start andEnd:(CGPoint)end;
- (void) setPrevious:(feature*)tempPrevious;
- (void) setNext:(feature *)tempNext;
- (void) setScaleD:(float)tempDistance;
- (void) setStep:(int)tempStep;
- (void) setMaxNum:(int)num;
- (void) incrementAll:(NSArray*)array;
- (NSArray*) getValues;
- (void) divideValues:(int)num;
- (void) printValues;
- (void) setAngles:(CGPoint)secEnd;
- (void) resetEnd:(CGPoint)end andDist:(float)dist;

@property (nonatomic, retain) feature * next;
@property (nonatomic, retain) feature * previous;
@property int step;
@property float scale;
@property CGPoint endPos;
@property float startDist;
@property float chordAngle;
@property int maxNum;

@end
