//
//  recognition.h
//  testing
//
//  Created by Nina Schiff on 2010/09/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface recognition : NSObject {
    
	// Holds features
	NSMutableArray * directionArray;
    
	/*** Feature extraction ***/
	// Previous point in order to determine distance
	CGPoint previous;
	// Previous point in regression line	
	CGPoint startPos; 
    
	// Holds length of current feature
	float distance;
    
	// The angle of the current feature	
	float currentAngle;
    
	// current direction in X
	// Can be one of:
	// 0  - No change
	// 1  - Increasing
	// -1 - Decreasing
	float xDir;
    
	// current direction in Y
	// Can be one of:
	// 0  - No change
	// 1  - Increasing
	// -1 - Decreasing
	float yDir;
    
	// Angle made by line connection startPos to third point in feature - the differance between this and 
	// currentAngle gives an indication of curvature and the direction of the arc (above or below line)
	float cAngle;
    
	// Used to determine when to sample angle for curvature approximation
	int gradientCounter;
    
	// Length of first feature - used in scaling the rest
	float startDist;
    
	// Due to the fact that features can be extended, the feature is only passed once a new one is created
	// These variables hold state of previous feature before it is passed to gesture machine
	CGPoint prevEnd;
	CGPoint prevStart;
	float prevAngle;
	float prevScale;
	float prevCAngle;
    
	NSMutableArray * packed;
	NSMutableArray * packed2;
	
	BOOL tap;
    
    
    
}

- (BOOL) recognitionDirection:(CGPoint)point;
- (void) reset:(CGPoint)pt;
- (NSMutableArray*) end:(CGPoint)pt;
- (void) setDirArray:(NSMutableArray *)dir;
- (NSMutableArray *) getFeature;
- (NSMutableArray *) getSecond;

@property BOOL tap;
@end
