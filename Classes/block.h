//
//  block.h
//  tester
//
//  Created by Nina Schiff on 2010/08/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface block : NSObject {
	int x,y,z;
	
	int colour;
	block **** placementArray;
	int checkX, checkY, checkZ;
	float newX, newY, newZ;
	float increX, increY, increZ;
	int upX, upY, upZ;
	int counter;
	BOOL toTrans;
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ andPlacement:(block****)placementA;
- (void) checkRemoval:(NSMutableArray*)toRemove andCol:(int)col andX:(int)cX andY:(int)cY andZ:(int)cZ;
- (void) checkConnection;
- (BOOL) updatePos;
- (void) setNewPos:(int)nX andY:(int)nY andZ:(int)nZ;
- (void) setNewPos2;

- (void) preTrans;
@property int x;
@property int y;
@property int z;
@property float newX;
@property float newY;
@property float newZ;
@property int upX;
@property int upY;
@property int upZ;
@property BOOL toTrans;

@property int colour;
@end
