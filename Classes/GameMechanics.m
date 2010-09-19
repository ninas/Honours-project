//
//  GameMechanics.m
//  tester
//
//  Created by Nina Schiff on 2010/09/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameMechanics.h"


@implementation GameMechanics

@synthesize startPos;
@synthesize endPos;
@synthesize maxDist;
@synthesize blockArray;

- (id)init
{    
    
        // Init 
		blockArray = [[NSMutableArray alloc] init];
		blockPlace = (block****) malloc(11*sizeof(block***));
		
		for (int x=-5; x<6; x++) {
			blockPlace[x+5] = (block***)malloc(11*sizeof(block**));
			for (int y=-5; y<6; y++) {
				blockPlace[x+5][y+5] = (block**)malloc(11*sizeof(block*));
				for (int z=-5; z<6; z++) {
					block * temp = [[block alloc] init];
					[temp setPosition:x andY:y andZ:z]; 
					blockPlace[x+5][y+5][z+5] = temp;
					[blockArray addObject:temp];
				}
			}
		}
		
		
		
		// Axes for rotations
		yAxis[0] = 0;
		yAxis[1] = 1;
		yAxis [2] = 0;
		
		xAxis[0]=1;
		xAxis[1]=0;
		xAxis[2] = 0;
		
		zAxis[0]=0;
		zAxis[1]=0;
		zAxis[2] = 1;
		
			
    return self;
}


- (void)dealloc
{
    
	
    [super dealloc];
}

/*
 * Rotates a row left
 */
- (void) rowLeft{
	
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	swap = [self getBlock:5 andY:startArray.y andZ:5];
	
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=4; j>=-5; j--) {
		block * temp = [self getBlock:j andY:startArray.y andZ:5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=4; j>=-5; j--) {
		block * temp = [self getBlock:-5 andY:startArray.y andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=-4; j<=5; j++) {
		block * temp = [self getBlock:j andY:startArray.y andZ:-5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=-4; j<=4; j++) {
		block * temp = [self getBlock:5 andY:startArray.y andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	blockPlace[startX+5][startY+5][startZ+5] = swap;
	swap.x = startX;
	swap.y = startY;
	swap.z = startZ;
	
}

/*
 * Rotates a row right
 */
- (void) rowRight{
	
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	swap = [self getBlock:-5 andY:startArray.y andZ:5];
	
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=-4; j<=5; j++) {
		block * temp = [self getBlock:j andY:startArray.y andZ:5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=-4; j<=5; j++) {
		block * temp = [self getBlock:-5 andY:startArray.y andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=4; j>=-5; j--) {
		block * temp = [self getBlock:j andY:startArray.y andZ:-5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=4; j>=-4; j--) {
		block * temp = [self getBlock:5 andY:startArray.y andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	blockPlace[startX+5][startY+5][startZ+5] = swap;
	swap.x = startX;
	swap.y = startY;
	swap.z = startZ;
}

/*
 * Rotates column up
 */
- (void) columnUp{
	
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	swap = [self getBlock:startArray.x andY:-5 andZ:5];
		int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=-4; j<=5; j++) {
		block * temp = [self getBlock:startArray.x andY:j andZ:5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=4; j>=-5; j--) {
		block * temp = [self getBlock:startArray.x andY:5 andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=4; j>=-5; j--) {
		block * temp = [self getBlock:startArray.x andY:j andZ:-5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=-4; j<=4; j++) {
		block * temp = [self getBlock:startArray.x andY:-5 andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	blockPlace[startX+5][startY+5][startZ+5] = swap;
	swap.x = startX;
	swap.y = startY;
	swap.z = startZ;
	
}

/*
 * Rotates column down
 */
- (void) columnDown{
	
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	swap = [self getBlock:startArray.x andY:5 andZ:5];
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=4; j>=-5; j--) {
		block * temp = [self getBlock:startArray.x andY:j andZ:5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=-4; j<=5; j++) {
		block * temp = [self getBlock:startArray.x andY:5 andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=-4; j<=5; j++) {
		block * temp = [self getBlock:startArray.x andY:j andZ:-5];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	for (int j=4; j>=-4; j--) {
		block * temp = [self getBlock:startArray.x andY:-5 andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	blockPlace[startX+5][startY+5][startZ+5] = swap;
	swap.x = startX;
	swap.y = startY;
	swap.z = startZ;
	
}

/*
 * Moves blocks forward along z. Frontmost block is wrapped around to the back
 */
- (void) zForward{
	
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:-5];
	if (swap==nil) {
		return;
	}
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=-4; j<=4; j++) {
		block * temp = [self getBlock:startArray.x andY:startArray.y andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	blockPlace[startX+5][startY+5][startZ+5] = swap;
	swap.x = startX;
	swap.y = startY;
	swap.z = startZ;
	
}

/*
 * Moves blocks backward along z. Backmost block is wrapped around to the front
 */
- (void) zBackward{
	
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=4; j>=-4; j--) {
		block * temp = [self getBlock:startArray.x andY:startArray.y andZ:j];
		blockPlace[temp.x+5][temp.y+5][temp.z+5] = swap;
		swap.x = temp.x;
		swap.y = temp.y;
		swap.z = temp.z;
		
		swap = temp;
	}
	
	blockPlace[startX+5][startY+5][startZ+5] = swap;
	swap.x = startX;
	swap.y = startY;
	swap.z = startZ;
	
}

/*
 * Swaps to blocks with each other
 * direction: specifies which direction to swap in
 */
- (void) swapBlocks:(int)direction{
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	block * second;
	
	if (direction == 0) { // left
		int x = startArray.x - 1;
		int z = 5;
		if (x < -5) {
			x = -5;
			z = 4;
		}
		second = [self getBlock:x andY:startArray.y andZ:z];
	}
	else if (direction == 1) { // right
		int x = startArray.x + 1;
		int z = 5;
		if (x > 5) {
			x = 5;
			z = 4;
		}
		second = [self getBlock:x andY:startArray.y andZ:z];
	}
	else if (direction == 2) { // up
		int y = startArray.y + 1;
		int z = 5;
		if (y > 5) {
			y = 5;
			z = 4;
		}
		second = [self getBlock:startArray.x andY:y andZ:z];
	}
	else if (direction == 3) { // down
		int y = startArray.y - 1;
		int z = 5;
		if (y < -5) {
			y = -5;
			z = 4;
		}
		second = [self getBlock:startArray.x andY:y andZ:z];
	}
	/*else if (direction == 4) { // forward
	 int y = startArray.y - 1;
	 int z = 5;
	 if (y < -5) {
	 y = -5;
	 z = 4;
	 }
	 second = [self getBlock:startArray.x andY:y andZ:z];
	 }*/
	
	//TODO: add for z
}

/*
 * Determines block position within array (as cube gets rotated)
 */
- (block*) getBlock:(int)x andY:(int)y andZ:(int)z{
	
	
	if (x > 5 || x < -5 || y > 5 || y < -5) {
		return nil;
	}
	int newX = x*xAxis[0] + y*xAxis[1] + z*xAxis[2];
	int newY = x*yAxis[0] + y*yAxis[1] + z*yAxis[2];	
	int newZ = x*zAxis[0] + y*zAxis[1] + z*zAxis[2];	
	
	return blockPlace[newX+5][newY+5][newZ+5];
	
}

/* ----------------------------------- These methods will be moved to feature extraction ----------------------------------- */

- (void)setStart:(float)x andY:(float)y{
   
	
	// New touches are not yet included in the current touches for the view
	startPos = CGPointMake(x, y);
	//[[blockArray objectAtIndex:0] setPosition:(startPos.x-160)/160 andY:(startPos.y-240)/240 andZ:0];
	
	startArray.x = roundf((startPos.x - 512)/512*15*1024/768/2.0);
	startArray.y = roundf((startPos.y- 384)/384*-15/2.0);
	
}



- (void)setEnd:(float)x andY:(float)y 
{
	
	endPos = CGPointMake(x, y);
}

- (CGPoint)rotateCube{
	
	float x = endPos.x - startPos.x;
	float y = endPos.y - startPos.y;
	
	
		
		float angle = atan2f(y,x)*180/M_PI;
		if (fabs(angle) < 45 || fabs(angle) > 135 ) {
			if (x < 0) {
				x = -90;
			}
			else {
				x = 90;
			}
			y=0;
			
			
			float tempX = x*M_PI/180.0;
			//NSLog(@"xRot:    %f",xRot);
			float newX = yAxis[2]*sinf(tempX) + yAxis[0]*cosf(tempX);
			float newZ = yAxis[2]*cosf(tempX) - yAxis[0]*sinf(tempX);
			yAxis[0] = roundf(newX);
			yAxis[2] = roundf(newZ);
			
			newX = xAxis[2]*sinf(tempX) + xAxis[0]*cosf(tempX);
			newZ = xAxis[2]*cosf(tempX) - xAxis[0]*sinf(tempX);
			xAxis[0] = roundf(newX);
			xAxis[2] = roundf(newZ);
			
			newX = zAxis[2]*sinf(tempX) + zAxis[0]*cosf(tempX);
			newZ = zAxis[2]*cosf(tempX) - zAxis[0]*sinf(tempX);
			zAxis[0] = roundf(newX);
			zAxis[2] = roundf(newZ);
			
			
		}
		else if (fabs(angle) > 45 && fabs(angle) < 135 ) {
			if (y < 0) {
				y = -90;
			}
			else {
				y = 90;
			}
			x=0;
			
			
			float tempY = y*M_PI/180.0;
			
			float newY = xAxis[1]*cosf(tempY) - xAxis[2]*sinf(tempY);
			float newZ = xAxis[1]*sinf(tempY) + xAxis[2]*cosf(tempY);
			xAxis[1] = roundf(newY);
			xAxis[2]= roundf(newZ);
			
			newY = yAxis[1]*cosf(tempY) - yAxis[2]*sinf(tempY);
			newZ = yAxis[1]*sinf(tempY) + yAxis[2]*cosf(tempY);
			yAxis[1] = roundf(newY);
			yAxis[2]= roundf(newZ);
			
			newY = zAxis[1]*cosf(tempY) - zAxis[2]*sinf(tempY);
			newZ = zAxis[1]*sinf(tempY) + zAxis[2]*cosf(tempY);
			zAxis[1] = roundf(newY);
			zAxis[2]= roundf(newZ);
			
		}
		
		
		NSLog(@"                     X axis:  %d  %d  %d",xAxis[0], xAxis[1], xAxis[2]);
		NSLog(@"                     Y axis:  %d  %d  %d",yAxis[0], yAxis[1], yAxis[2]);
		NSLog(@"                     Z axis:  %d  %d  %d",zAxis[0], zAxis[1], zAxis[2]);
		int z = 0;
		
		
	return CGPointMake(x, y);
		
		
		
		
	
	
	
}



@end
