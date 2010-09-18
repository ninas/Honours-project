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
	
	
}

- (void) setPosition:(int)tempX andY:(int)tempY andZ:(int)tempZ;

@property int x;
@property int y;
@property int z;

@property int colour;
@end
