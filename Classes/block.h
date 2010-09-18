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
	int rotX, rotY, rotZ;
	int colour;
	block * neighbours [8];
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ;
- (void) rotatePos:(float)xRot andY:(float)yRot;
- (void) moveRow:(int)minX andY:(int)minY andZ:(int)minZ;
@property int x;
@property int y;
@property int z;
@property int rotX;
@property int rotY;
@property int rotZ;
@property int colour;
@end
