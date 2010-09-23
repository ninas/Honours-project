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
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ andPlacement:(block****)placementA;
- (void) checkRemoval:(NSMutableArray*)toRemove andCol:(int)col andX:(int)cX andY:(int)cY andZ:(int)cZ;
- (void) checkConnection;
@property int x;
@property int y;
@property int z;

@property int colour;
@end
