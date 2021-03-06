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
@synthesize rotating;
@synthesize score;
@synthesize translateArray;
@synthesize gestureCounter;
@synthesize highScore;
@synthesize highScoreLabel;

- (id)init
{    
    blockArray = nil;
	translateArray = nil;
	blockPlace = nil;
	
    return self;
}

- (void) restart{
	if (blockArray == nil) {
		blockArray = [[NSMutableArray alloc] init];
		translateArray = [[NSMutableSet alloc] init];
		blockPlace = (block****) malloc(11*sizeof(block***));
		
		for (int x=-5; x<6; x++) {
			blockPlace[x+5] = (block***)malloc(11*sizeof(block**));
			for (int y=-5; y<6; y++) {
				blockPlace[x+5][y+5] = (block**)malloc(11*sizeof(block*));
				for (int z=-5; z<6; z++) {
					block * temp = [[block alloc] init];
					[temp setPosition:x andY:y andZ:z andPlacement:blockPlace]; 
					blockPlace[x+5][y+5][z+5] = temp;
					[blockArray addObject:temp];
				}
			}
		}
		
	}
	else {
		if (score > *highScore) {
			*highScore = score;
			highScoreLabel.text = [NSString stringWithFormat:@"Best: %d",score];
		}
		
		if (blockArray.count > 0) {
			[blockArray removeAllObjects];
		}
		if (translateArray.count > 0) {
			[translateArray removeAllObjects];
		}
		
		
		
		for (int x=-5; x<6; x++) {
			
			for (int y=-5; y<6; y++) {
				
				for (int z=-5; z<6; z++) {
					
					
					
					if (blockPlace[x+5][y+5][z+5] == nil) {
						block * temp = [[block alloc] init];
						[temp setPosition:x andY:y andZ:z andPlacement:blockPlace]; 
						blockPlace[x+5][y+5][z+5] = temp;
						[blockArray addObject:temp];
					}
					else {
						[blockPlace[x+5][y+5][z+5] setPosition:x andY:y andZ:z andPlacement:blockPlace];
						[blockPlace[x+5][y+5][z+5] reset];
						[blockArray addObject:blockPlace[x+5][y+5][z+5]];
					}
				}
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
	
	adjustZ = NO;
	currentZ = -6;
	rotating = NO;
	score = 0;
}

- (void)dealloc
{
    [blockArray release];
	[translateArray release];
	
	for (int x=0; x<=10; x++) {
		for (int y=0; y<=10; y++) {
			for (int z=0; z<=10; z++) {
				[blockPlace[x][y][z] release];
					 
			}
			 free(blockPlace[x][y]);
		}
		free(blockPlace[x]);
	}
	free(blockPlace );
		
    [super dealloc];
}

/*
 * Rotates a row left
 */
- (void) rowLeft{
	adjustZ = YES;
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	
	if (swap==nil) {
		
		return;
	}
	gestureCounter[0]+=1;
	if (fabs(startArray.x) > currentZ) {
		currentZ = fabs(startArray.x);
	}
	
	
	//swap = [self getBlock:currentZ andY:startArray.y andZ:currentZ];
	int startX;
	int startY ;
	int startZ ;
	
		int pos[3] = {currentZ,startArray.y,currentZ};
		[self getPosition:pos];
		 startX = pos[0];
		 startY = pos[1];
		 startZ = pos[2];
	
	swap = blockPlace[pos[0]+5][pos[1]+5][pos[2]+5];

	
	
	int tempPos[3];
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		int tempPos[3] = {j,startArray.y,currentZ};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
			
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
			blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			swap.y = tempPos[1];
			swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		
		int tempPos[3] = {-currentZ,startArray.y,j};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=-currentZ+1; j<=currentZ; j++) {
		//block * temp = [self getBlock:j andY:startArray.y andZ:-currentZ];
		int tempPos[3] = {j,startArray.y,-currentZ};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
			
		}
		swap = temp;
	}
	
	for (int j=-currentZ+1; j<=currentZ-1; j++) {
		
		//block * temp = [self getBlock:currentZ andY:startArray.y andZ:j];
		int tempPos[3] = {currentZ,startArray.y,j};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
	if (swap!=nil) {
		
		[swap setNewPos:pos[0] andY:pos[1] andZ:pos[2]];
		/*swap.x = tempPos[0];
		 swap.y = tempPos[1];
		 swap.z = tempPos[2];*/
		
		[translateArray addObject:blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]];
		for (int i=0; i<blockArray.count; i++) {
			if ([blockArray objectAtIndex:i] == swap) {
				[blockArray removeObjectAtIndex:i];
				break;
			}
		}
		
	}
	
}

/*
 * Rotates a row right
 */
- (void) rowRight{
	adjustZ = YES;
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	
	if (swap==nil) {
		
		return;
	}
	gestureCounter[1]+=1;
	if (fabs(startArray.x) > currentZ) {
		currentZ = fabs(startArray.x);
	}
	
	
	//swap = [self getBlock:currentZ andY:startArray.y andZ:currentZ];
		
	int pos[3] = {-currentZ,startArray.y,currentZ};
	[self getPosition:pos];
		
	swap = blockPlace[pos[0]+5][pos[1]+5][pos[2]+5];
	
	
	
	
	for (int j=-currentZ+1; j<=currentZ; j++) {
		int tempPos[3] = {j,startArray.y,currentZ};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		
		int tempPos[3] = {currentZ,startArray.y,j};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		//block * temp = [self getBlock:j andY:startArray.y andZ:-currentZ];
		int tempPos[3] = {j,startArray.y,-currentZ};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=-currentZ+1; j<=currentZ-1; j++) {
		
		//block * temp = [self getBlock:currentZ andY:startArray.y andZ:j];
		int tempPos[3] = {-currentZ,startArray.y,j};
		[self getPosition:tempPos];
		//block * temp = [self getBlock:j andY:startArray.y andZ:currentZ];
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
	if (swap!=nil) {
		
		[swap setNewPos:pos[0] andY:pos[1] andZ:pos[2]];
		/*swap.x = tempPos[0];
		 swap.y = tempPos[1];
		 swap.z = tempPos[2];*/
		
		[translateArray addObject:blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]];
		for (int i=0; i<blockArray.count; i++) {
			if ([blockArray objectAtIndex:i] == swap) {
				[blockArray removeObjectAtIndex:i];
				break;
			}
		}
	}	
}

/*
 * Rotates column up
 */
- (void) columnUp{
	adjustZ = YES;
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	gestureCounter[2]+=1;
	
	int pos[3] = {startArray.x,-currentZ,currentZ};
	[self getPosition:pos];
	
	
	swap = blockPlace[pos[0]+5][pos[1]+5][pos[2]+5];
	
	
	
	int tempPos[3];	
	
	for (int j=-currentZ+1; j<=currentZ; j++) {
		//block * temp = [self getBlock:startArray.x andY:j andZ:currentZ];
		int tempPos[3] = {startArray.x,j,currentZ};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		//block * temp = [self getBlock:startArray.x andY:currentZ andZ:j];
		int tempPos[3] = {startArray.x,currentZ,j};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}			
			
		}
		swap = temp;
	}
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		//block * temp = [self getBlock:startArray.x andY:j andZ:-currentZ];
		int tempPos[3] = {startArray.x,j,-currentZ};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}			
			
		}
		swap = temp;
	}
	
	for (int j=-currentZ+1; j<=currentZ-1; j++) {
		//block * temp = [self getBlock:startArray.x andY:-currentZ andZ:j];
		int tempPos[3] = {startArray.x,-currentZ,j};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
	if (swap!= nil) {
		[swap setNewPos:pos[0] andY:pos[1] andZ:pos[2]];
		/*swap.x = tempPos[0];
		 swap.y = tempPos[1];
		 swap.z = tempPos[2];*/
		
		[translateArray addObject:blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]];
		for (int i=0; i<blockArray.count; i++) {
			if ([blockArray objectAtIndex:i] == swap) {
				[blockArray removeObjectAtIndex:i];
				break;
			}
		}
	}
	
	
}

/*
 * Rotates column down
 */
- (void) columnDown{
	adjustZ = YES;
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap==nil) {
		return;
	}
	gestureCounter[3]+=1;
	
	int pos[3] = {startArray.x,currentZ,currentZ};
	[self getPosition:pos];
		
	swap = blockPlace[pos[0]+5][pos[1]+5][pos[2]+5];
	
	
	
	int tempPos[3];	
	
	for (int j=currentZ-1; j>= -currentZ; j--) {
		//block * temp = [self getBlock:startArray.x andY:j andZ:currentZ];
		int tempPos[3] = {startArray.x,j,currentZ};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=currentZ-1; j>=-currentZ; j--) {
		//block * temp = [self getBlock:startArray.x andY:currentZ andZ:j];
		int tempPos[3] = {startArray.x,-currentZ,j};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=-currentZ+1; j<=currentZ; j++) {
		//block * temp = [self getBlock:startArray.x andY:j andZ:-currentZ];
		int tempPos[3] = {startArray.x,j,-currentZ};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	for (int j=-currentZ+1; j<=currentZ-1; j++) {
		//block * temp = [self getBlock:startArray.x andY:-currentZ andZ:j];
		int tempPos[3] = {startArray.x,currentZ,j};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
	if (swap!=nil) {
		[swap setNewPos:pos[0] andY:pos[1] andZ:pos[2]];
		/*swap.x = tempPos[0];
		 swap.y = tempPos[1];
		 swap.z = tempPos[2];*/
		
		[translateArray addObject:blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]];
		for (int i=0; i<blockArray.count; i++) {
			if ([blockArray objectAtIndex:i] == swap) {
				[blockArray removeObjectAtIndex:i];
				break;
			}
		}
	}
	
}

/*
 * Moves blocks forward along z. Frontmost block is wrapped around to the back
 */
- (void) zForward{
	adjustZ = YES;
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:-5];
	gestureCounter[4]+=1;
	int pos[3] = {startArray.x,startArray.y, -5};
	
	
	for (int j=-4; j<=5; j++) {
		int tempPos[3] = {startArray.x,startArray.y,j};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
	if (swap!=nil) {
		[swap setNewPos:pos[0] andY:pos[1] andZ:pos[2]];
		/*swap.x = tempPos[0];
		 swap.y = tempPos[1];
		 swap.z = tempPos[2];*/
		
		[translateArray addObject:blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]];
		for (int i=0; i<blockArray.count; i++) {
			if ([blockArray objectAtIndex:i] == swap) {
				[blockArray removeObjectAtIndex:i];
				break;
			}
		}
	}
	
	
}

/*
 * Moves blocks backward along z. Backmost block is wrapped around to the front
 */
- (void) zBackward{
	adjustZ = YES;
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	gestureCounter[5]+=1;
	int pos[3] = {startArray.x,startArray.y, 5};
	
	
	for (int j=4; j>=-5; j--) {
		int tempPos[3] = {startArray.x,startArray.y,j};
		[self getPosition:tempPos];
		
		
		block * temp = blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5];
		blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5] = swap;
		if (swap!=nil) {
			
			
			[swap setNewPos:tempPos[0] andY:tempPos[1] andZ:tempPos[2]];
			/*swap.x = tempPos[0];
			 swap.y = tempPos[1];
			 swap.z = tempPos[2];*/
			
			[translateArray addObject:blockPlace[tempPos[0]+5][tempPos[1]+5][tempPos[2]+5]];
			for (int i=0; i<blockArray.count; i++) {
				if ([blockArray objectAtIndex:i] == swap) {
					[blockArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
		}
		swap = temp;
	}
	
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
	if (swap!=nil) {
		[swap setNewPos:pos[0] andY:pos[1] andZ:pos[2]];
		/*swap.x = tempPos[0];
		 swap.y = tempPos[1];
		 swap.z = tempPos[2];*/
		
		[translateArray addObject:blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]];
		for (int i=0; i<blockArray.count; i++) {
			if ([blockArray objectAtIndex:i] == swap) {
				[blockArray removeObjectAtIndex:i];
				break;
			}
		}
	}	
}

/*
 * Swaps to blocks with each other
 * direction: specifies which direction to swap in
 */
- (void) swapBlocks:(int)direction{
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	if (swap == nil) {
		return;
	}
	int pos[3];
	
	if (direction == 0) { // left
		pos[0] = startArray.x - 1;
		pos[2] = 5;
		if (pos[0] < -5) {
			pos[0] = -5;
			pos[2] = 4;
		}
		pos[1] = startArray.y;
		[self getPosition:pos];
		gestureCounter[6]++;
	}
	else if (direction == 1) { // right
		pos[0] = startArray.x + 1;
		pos[2] = 5;
		if (pos[0] > 5) {
			pos[0] = 5;
			pos[2] = 4;
		}
		pos[1] = startArray.y;
		[self getPosition:pos];
		gestureCounter[7]++;
	}
	else if (direction == 2) { // up
		pos[1] = startArray.y + 1;
		pos[2] = 5;
		if (pos[1] > 5) {
			pos[1] = 5;
			pos[2] = 4;
		}
		pos[0] = startArray.x;
		[self getPosition:pos];
		gestureCounter[8]++;
	}
	else if (direction == 3) { // down
		pos[1] = startArray.y - 1;
		pos[2] = 5;
		if (pos[1] < -5) {
			pos[1] = -5;
			pos[2] = 4;
		}
		pos[0] = startArray.x;
		[self getPosition:pos];
		gestureCounter[9]++;
	}
	
	
	
	if (blockPlace[pos[0]+5][pos[1]+5][pos[2]+5]!=nil) {
		[blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] setPosition:swap.x andY:swap.y andZ:swap.z andPlacement:blockPlace];
		blockPlace[swap.x+5][swap.y+5][swap.z+5] = blockPlace[pos[0]+5][pos[1]+5][pos[2]+5];
	}
	
	swap.x = pos[0];
	swap.y = pos[1];
	swap.z = pos[2];
	blockPlace[pos[0]+5][pos[1]+5][pos[2]+5] = swap;
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
	currentZ = z;
	if (adjustZ && blockPlace[newX+5][newY+5][newZ+5] == nil) {
		
		while (blockPlace[newX+5][newY+5][newZ+5]==nil) {
			currentZ-=1;
			z = currentZ;
			newX = x*xAxis[0] + y*xAxis[1] + z*xAxis[2];
			newY = x*yAxis[0] + y*yAxis[1] + z*yAxis[2];	
			newZ = x*zAxis[0] + y*zAxis[1] + z*zAxis[2];
			
			if (newX > 5 || newX < -5 || newY > 5 || newY < -5 || newZ > 5 || newZ < -5) {
				return nil;
			}
		}
		currentZ = abs(currentZ);
		adjustZ = NO;
	}
	return blockPlace[newX+5][newY+5][newZ+5];
	
}

- (void) getPosition:(int*)vals{
	int x = vals[0];
	int y = vals[1];
	int z = vals[2];
	if (x > 5 || x < -5 || y > 5 || y < -5) {
		return;
	}
	int newX = x*xAxis[0] + y*xAxis[1] + z*xAxis[2];
	int newY = x*yAxis[0] + y*yAxis[1] + z*yAxis[2];	
	int newZ = x*zAxis[0] + y*zAxis[1] + z*zAxis[2];	
	
	vals[0] = newX;
	vals[1] = newY;
	vals[2] = newZ;
	
	
}

- (void) moveIn{
	gestureCounter[10]+=1;
	for (int x=0; x<=10; x++) {
		for (int y=0; y<=10; y++) {
			for (int z =0; z<=10; z++) {
				if (blockPlace[x][y][z] != nil) {
					[blockPlace[x][y][z] setToTrans:NO];
					[blockPlace[x][y][z] preTrans];

				}
			}
		}
	}
	
	
		for (int x=0; x<=10; x++) {
			for (int y=0; y<=10; y++) {
				for (int z=1; z<=5; z++) {
					int zVal = z;
					while (blockPlace[x][y][zVal+5]!=nil && zVal > 0 && blockPlace[x][y][zVal+4] == nil) {
						[blockPlace[x][y][zVal+5] setUpZ:zVal-1];
						//NSLog(@"New value:    %d    (was %d)", [blockPlace[x][y][zVal+5] newZ], [blockPlace[x][y][zVal+5] z]);
						blockPlace[x][y][zVal+4] = blockPlace[x][y][zVal+5];
						blockPlace[x][y][zVal+5] = nil;
						zVal-=1;
						//NSLog(@"Something1");
					}
					if (zVal != z) {
						[blockPlace[x][y][zVal+5] setToTrans:YES];
					}
					zVal = z;
					while (blockPlace[x][y][-zVal+5]!=nil && zVal > 0 && blockPlace[x][y][-zVal+6] == nil) {
						[blockPlace[x][y][-zVal+5] setUpZ:-zVal+1];
						blockPlace[x][y][-zVal+6] = blockPlace[x][y][-zVal+5];
						blockPlace[x][y][-zVal+5] = nil;
						zVal-=1;
						//NSLog(@"Something2");
					}
					if (zVal != z) {
						[blockPlace[x][y][-zVal+5] setToTrans:YES];
					}
				}
			}
		}
	
	for (int x=1; x<=5; x++) {
		for (int y=0; y<=10; y++) {
			for (int z=0; z<=10; z++) {
				int xVal = x;
				while (blockPlace[xVal+5][y][z]!=nil && xVal > 0 && blockPlace[xVal+4][y][z] == nil) {
					[blockPlace[xVal+5][y][z] setUpX:xVal-1];
					blockPlace[xVal+4][y][z] = blockPlace[xVal+5][y][z];
					blockPlace[xVal+5][y][z] = nil;
					xVal-=1;
					//NSLog(@"Something1");
				}
				if (xVal != x) {
					[blockPlace[xVal+5][y][z] setToTrans:YES];
				}
				xVal = x;
				while (blockPlace[-xVal+5][y][z]!=nil && xVal > 0 && blockPlace[-xVal+6][y][z] == nil) {
					[blockPlace[-xVal+5][y][z] setUpX:-xVal+1];
					blockPlace[-xVal+6][y][z] = blockPlace[-xVal+5][y][z];
					blockPlace[-xVal+5][y][z] = nil;
					xVal-=1;
					//NSLog(@"Something1");
				}
				if (xVal != x) {
					[blockPlace[-xVal+5][y][z] setToTrans:YES];
				}
			}
		}
	}
	
	for (int x=0; x<=10; x++) {
		for (int y=1; y<=5; y++) {
			for (int z=0; z<=10; z++) {
				int yVal = y;
				while (blockPlace[x][yVal+5][z]!=nil && yVal > 0 && blockPlace[x][yVal+4][z] == nil) {
					[blockPlace[x][yVal+5][z] setUpY:yVal-1];
					blockPlace[x][yVal+4][z] = blockPlace[x][yVal+5][z];
					blockPlace[x][yVal+5][z] = nil;
					yVal-=1;
					//NSLog(@"Something1");
				}
				if (yVal != y) {
					[blockPlace[x][yVal+5][z] setToTrans:YES];
				}
				yVal = y;
				while (blockPlace[x][-yVal+5][z]!=nil && yVal > 0 && blockPlace[x][-yVal+6][z] == nil) {
					[blockPlace[x][-yVal+5][z] setUpY:-yVal+1];
					blockPlace[x][-yVal+6][z] = blockPlace[x][-yVal+5][z];
					blockPlace[x][-yVal+5][z] = nil;
					yVal-=1;
					//NSLog(@"Something1");
				}
				if (yVal != y) {
					[blockPlace[x][-yVal+5][z] setToTrans:YES];
				}
			}
		}
	}
	int counter = 0;
	while (counter < blockArray.count) {
		block * temp = [blockArray objectAtIndex:counter];
		if (temp.toTrans) {
			//NSLog(@"Should be adding...");
			[translateArray addObject:temp];
			[temp setNewPos2];
			[blockArray removeObjectAtIndex:counter];
			counter--;
		}
		
		counter++;
	}
	
	
}



/* ----------------------------------- These methods will be moved to feature extraction ----------------------------------- */

- (void)setStart:(float)x andY:(float)y{
	
	
	// New touches are not yet included in the current touches for the view
	startPos = CGPointMake(x, y);
	//[[blockArray objectAtIndex:0] setPosition:(startPos.x-160)/160 andY:(startPos.y-240)/240 andZ:0];
	float xPos = (startPos.x - 512)/512*15*1024/768/2.0;
	float yPos = (startPos.y- 384)/384*-15/2.0;
	float zPos = 5;
	
	float tempX = -5*M_PI/180.0;
	//NSLog(@"xRot:    %f",xRot);
	float newX = zPos*sinf(tempX) + xPos*cosf(tempX);
	float newZ = zPos*cosf(tempX) - xPos*sinf(tempX);
	xPos = newX;
	zPos = newZ;
	
	
	
	 float newY = yPos*cosf(tempX) - zPos*sinf(tempX);
	 newZ = yPos*sinf(tempX) + zPos*cosf(tempX);
	yPos = newY;
	zPos= newZ;
	
	
	
	
	
	
	
	startArray.x = roundf(xPos);
	startArray.y = roundf(yPos);
	
}

- (void) shuffle{
	
	for (int i=-5; i<=5; i++) {
		startArray.x = 0;
		startArray.y = i;
		[self rowLeft];
		
		startArray.x = i;
		startArray.y = 0;
		[self columnDown];
	}
	[self moveIn];
	
}
- (void) removeBlocks{
	NSMutableArray * toRemove = [[NSMutableArray alloc] init];
	adjustZ = YES;
	block* touched = [self getBlock:startArray.x andY:startArray.y andZ:5];
	int colour = touched.colour;
	
	
	
	[touched checkRemoval:toRemove andCol:colour andX:touched.x andY:touched.y andZ:touched.z];
	if (toRemove.count > 2) {
		
	for (int i=0; i<toRemove.count; i++) {
		for (int j=0; j<blockArray.count; j++) {
			if ([blockArray objectAtIndex:j] == [toRemove objectAtIndex:i]) {
				block * temp = [blockArray objectAtIndex:j];
				blockPlace[temp.x+5][temp.y+5][temp.z+5] = nil;
				[blockArray removeObjectAtIndex:j];
				break;
			}
		}
	}
		
		NSMutableSet * forScore = [NSMutableSet set];
		[forScore addObjectsFromArray:toRemove];
		score+=2*(forScore.count-3);
		
		
	}
	
	
	
	/*while (toRemove.count > 0) {
		block * temp = [toRemove objectAtIndex:0];
		[toRemove removeObjectAtIndex:0];
		[temp release];
		
	}*/
	[toRemove removeAllObjects];
	[toRemove release];
	
}

- (void)setEnd:(float)x andY:(float)y 
{
	
	endPos = CGPointMake(x, y);
}

- (CGPoint)rotateCube{
	gestureCounter[12]+=1;
	rotating = YES;
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
	
	
	
	int z = 0;
	
	rotating = NO;
	return CGPointMake(x, y);
	
	
	
	
	
	
	
}



@end
