//
//  EAGLView.m
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EAGLView.h"

#import "ES1Renderer.h"
#import "ES2Renderer.h"
#import "block.h"
#import <math.h>

@implementation EAGLView

@synthesize animating;
@synthesize startPos;
@synthesize endPos;
@synthesize maxDist;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
    {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		NSLog(@"pooooo");
        /*renderer = [[ES2Renderer alloc] init];
		 
		 if (!renderer)
		 {*/
		renderer = [[ES1Renderer alloc] init];
		
		if (!renderer)
		{
			[self release];
			return nil;
		}
        //}
		
        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;
		blockArray = [[NSMutableArray alloc] init];
		blockPlace = (block****) malloc(11*sizeof(block***));
		//rotations = [[NSMutableArray alloc] init];
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
		xTotal = 0;
		yTotal = 0;
		zTotal = 0;
		yAxis[0] = 0;
		yAxis[1] = 1;
		yAxis [2] = 0;
		
		xAxis[0]=1;
		xAxis[1]=0;
		xAxis[2] = 0;
		
		zAxis[0]=0;
		zAxis[1]=0;
		zAxis[2] = 1;
		
		
		
		
		[renderer setBlockArray:blockArray];
		
        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
    }
	
    return self;
}

- (void)drawView:(id)sender
{
    //[renderer renderByRotatingAroundX:0 rotatingAroundY:0];
	//[renderer renderByRotatingAroundX:14 rotatingAroundY:14];
	xRot = lastDist.x/40;
	yRot = lastDist.y/40;
	
	if (xRot != 0 || yRot !=0) {
		counter+=1;
	}
	
	
	if (counter==40) {
		lastDist.x=0;
		lastDist.y=0;
		counter=0;
		xRot=0.0;
		yRot=0.0;
	}
	
	[renderer renderByRotatingAroundX:xRot rotatingAroundY:yRot];
	
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
		
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.
			
            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:FALSE];
		
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }
		
        animating = FALSE;
    }
}

- (void)dealloc
{
    [renderer release];
	
    [super dealloc];
}

- (void) rowLeft{
	
	
	NSLog(@"Swapping");
	 block * swap = [self getBlock:5 andY:startArray.y andZ:5];
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
	 
	 for (int j=-4; j<=5; j++) {
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
	 NSLog(@"start pos:  (%d, %d, %d)",swap.x,swap.y,swap.z);	
	
}

- (void) rowRight{
	
	
	NSLog(@"Swapping");
	block * swap = [self getBlock:-5 andY:startArray.y andZ:5];
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
	
	for (int j=4; j>=5; j--) {
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
	NSLog(@"start pos:  (%d, %d, %d)",swap.x,swap.y,swap.z);	
	
}

- (void) columnUp{
	
	
	NSLog(@"Swapping");
	block * swap = [self getBlock:startArray.x andY:-5 andZ:5];
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
	
	for (int j=-4; j<=5; j++) {
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
	NSLog(@"start pos:  (%d, %d, %d)",swap.x,swap.y,swap.z);	
	
}

- (void) columnDown{
	
	
	NSLog(@"Swapping");
	block * swap = [self getBlock:startArray.x andY:5 andZ:5];
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
	
	for (int j=4; j>=-5; j--) {
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
	NSLog(@"start pos:  (%d, %d, %d)",swap.x,swap.y,swap.z);	
	
}

- (void) zForward{
	
	
	NSLog(@"Swapping");
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:-5];
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=-4; j<=5; j++) {
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
	NSLog(@"start pos:  (%d, %d, %d)",swap.x,swap.y,swap.z);	
	
}

- (void) zBackward{
	
	
	NSLog(@"Swapping");
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	int startX = swap.x;
	int startY = swap.y;
	int startZ = swap.z;
	
	
	for (int j=4; j>=-5; j--) {
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
	NSLog(@"start pos:  (%d, %d, %d)",swap.x,swap.y,swap.z);	
	
}

- (void) swapBlocks:(int)direction{
	block * swap = [self getBlock:startArray.x andY:startArray.y andZ:5];
	block * second;
	// swap left
	if (direction == 0) {
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


- (block*) getBlock:(int)x andY:(int)y andZ:(int)z{
	
	
	if (x > 5 || x < -5 || y > 5 || y < -5) {
		return nil;
	}
	int newX = x*xAxis[0] + y*xAxis[1] + z*xAxis[2];
	int newY = x*yAxis[0] + y*yAxis[1] + z*yAxis[2];	
	int newZ = x*zAxis[0] + y*zAxis[1] + z*zAxis[2];	
		
		return blockPlace[newX+5][newY+5][newZ+5];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
	
	// New touches are not yet included in the current touches for the view
	startPos = [[touches anyObject] locationInView:self];
	//[[blockArray objectAtIndex:0] setPosition:(startPos.x-160)/160 andY:(startPos.y-240)/240 andZ:0];
	
	startArray.x = roundf((startPos.x - 512)/512*15*1024/768/2.0);
	startArray.y = roundf((startPos.y- 384)/384*-15/2.0);
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	CGPoint currentMovementPosition = [[touches anyObject] locationInView:self];
	}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	
	lastPos = [[touches anyObject] locationInView:self];
	
	block * tester = blockPlace[0][0][0];
	NSLog(@"Origin: (%d, %d, %d)",tester.x, tester.y, tester.z);
	
	
	//lastDist = CGPointMake(lastPos.x - startPos.x, lastPos.y-startPos.y);
	float x = lastPos.x - startPos.x;
	float y = lastPos.y - startPos.y;
	
	if (sqrtf(x*x+y*y) > 50) {
		
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
		
		
		lastDist = CGPointMake(x, y);
		counter=0;
		xRot=0.0;
		yRot=0.0;
				
	}
	else{
		[self zForward];
		block * temp = [self getBlock:(int)startArray.x andY:startArray.y andZ:5];// [(int)startArray.x+5][(int)startArray.y+5][10];
		
		//		block * temp = blockPlace[(int)startArray.x+5][(int)startArray.y+5][10];
		NSLog(@"Block touched: (%d, %d, %d)      from (%f  %f  %d)",temp.x, temp.y, temp.z,startArray.x, startArray.y, 5);
	}
	
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
	// Handle touches canceled the same as as a touches ended event
    [self touchesEnded:touches withEvent:event];
}




@end
