//
//  GameMechanics.h
//  tester
//
//  Created by Nina Schiff on 2010/09/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "block.h"

@interface GameMechanics : NSObject {

	CGPoint startPos;
	CGPoint endPos;
	float maxDist;
	NSMutableArray * blockArray;
	block **** blockPlace;
	CGPoint  lastDist;
	
	CGPoint startArray;
	
	
	int yAxis [3];
	int xAxis [3];
	int zAxis[3];
	
	BOOL adjustZ;
	int currentZ;
	
	
	
	
}


@property (nonatomic) CGPoint startPos;
@property (nonatomic) CGPoint endPos;
@property (nonatomic) float maxDist;
@property (nonatomic, retain) NSMutableArray * blockArray;


- (void)rowLeft;

- (void)rowRight;
- (void) columnUp;
- (void) columnDown;
- (void) zForward;
- (void) zBackward;
- (void) swapBlocks:(int)direction;
- (void) setStart:(float)x andY:(float)y;

- (void) setEnd:(float)x andY:(float)y;
- (CGPoint) rotateCube;
- (void) removeBlocks;
- (block *) getBlock:(int)x andY:(int)y andZ:(int)z;
@end
