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
		rotations = [[NSMutableArray alloc] init];
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
	
	
	/*block * swap = blockPlace[10][(int)startArray.y+5][10];
	 int startX = swap.x;
	 int startY = swap.y;
	 int startZ = swap.z;
	 NSLog(@" and swap: (%d, %d, %d)", swap.x, swap.y, swap.z);
	 for (int i=9; i>=0; i--) {
	 block * temp = blockPlace[i][(int)startArray.y+5][10];
	 NSLog(@"In loop: %d   %d", i, (int)(startArray.y+5));
	 blockPlace[i][(int)startArray.y+5][10] = swap;
	 NSLog(@" and swap: (%d, %d, %d)", swap.rotX, swap.rotY, swap.rotZ);
	 NSLog(@" and swap: (%d, %d, %d)", swap.x, swap.y, swap.z);
	 swap.x = temp.x;
	 swap.y = temp.y;
	 swap.z = temp.z;
	 
	 swap.rotX = temp.rotX;
	 swap.rotY = temp.rotY;
	 swap.rotZ = temp.rotZ;
	 NSLog(@" and swap: (%d, %d, %d)", swap.rotX, swap.rotY, swap.rotZ);
	 NSLog(@" and swap: (%d, %d, %d)", swap.x, swap.y, swap.z);
	 swap = temp;
	 }
	 
	 for (int i=9; i>=0; i--) {
	 block * temp = blockPlace[0][(int)startArray.y+5][i];
	 
	 blockPlace[0][(int)startArray.y+5][i] = swap;
	 swap.x = temp.x;
	 swap.y = temp.y;
	 swap.z = temp.z;
	 
	 swap.rotX = temp.rotX;
	 swap.rotY = temp.rotY;
	 swap.rotZ = temp.rotZ;
	 
	 swap = temp;
	 }
	 
	 for (int i=1; i<=10; i++) {
	 
	 block * temp = blockPlace[i][(int)startArray.y+5][0];
	 
	 blockPlace[i][(int)startArray.y+5][0] = swap;
	 swap.x = temp.x;
	 swap.y = temp.y;
	 swap.z = temp.z;
	 
	 swap.rotX = temp.rotX;
	 swap.rotY = temp.rotY;
	 swap.rotZ = temp.rotZ;
	 
	 swap = temp;
	 }
	 
	 for (int i=1; i<=10; i++) {
	 block * temp = blockPlace[10][(int)startArray.y+5][i];
	 
	 blockPlace[10][(int)startArray.y+5][i] = swap;
	 swap.x = temp.x;
	 swap.y = temp.y;
	 swap.z = temp.z;
	 
	 swap.rotX = temp.rotX;
	 swap.rotY = temp.rotY;
	 swap.rotZ = temp.rotZ;
	 
	 swap = temp;
	 }*/
	
	/*blockPlace[startX+5][startY+5][startZ+5] = swap;
	 swap.x = startX;
	 swap.y = startY;
	 swap.z = startZ;*/
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

- (block*) getBlock:(int)x andY:(int)y andZ:(int)z{
	
	
	if (x > 5 || x < -5 || y > 5 || y < -5) {
		return nil;
	}
	
	int newX = x, newY=y, newZ = z;
	
	
	for (int i=rotations.count-1; i>=0; i--) {
		
		newX = x;
		newY= y;
		newZ = z;
		
		
		float xAngle = ([[rotations objectAtIndex:i] CGPointValue]).x;
		float yAngle = ([[rotations objectAtIndex:i] CGPointValue]).y;
		NSLog(@"Rotating around:  %f %f",xAngle,yAngle);
		float radianX = xAngle*M_PI/180.0;
		float radianY = yAngle*M_PI/180.0;
		
		if (xAngle > 0 || xAngle < 0) {
			newX = roundf(z*sinf(radianX) + x*cosf(radianX));
			newZ = roundf(z*cosf(radianX) - x*sinf(radianX));
		}
		
		if (yAngle > 0 || yAngle < 0) {
			y = roundf(newY*cosf(radianY) - newZ*sinf(radianY));
			x = newX;
			z = roundf(newY*sinf(radianY) + newZ*cosf(radianY));
		}
		else {
			x = newX;
			y=newY;
			z=newZ;
			//NSLog(@"In here");
		}
	}
	
	
	//NSLog(@"Adjusted positions from (%f, %f, %f) to (%d, %d, %d)",pos.x,pos.y,5.0,x,y,z);
	return blockPlace[x+5][y+5][z+5];
	//NSLog(@"Adjusted positions from (%f, %f, %f) to (%d, %d, %d)",xPos,yPos,5.0,x,y,z);
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
	//NSLog(@"Position:  (%f,%f)",xPos,yPos);
	NSLog(@"StartArray: (%f, %f)",startArray.x, startArray.y);
	//[[blockArray objectAtIndex:0] setPosition:xPos andY:yPos andZ:0];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	CGPoint currentMovementPosition = [[touches anyObject] locationInView:self];
	//[renderer renderByRotatingAroundX:(currentMovementPosition.x - lastPos.x) rotatingAroundY:(currentMovementPosition.y - lastPos.y)];
	//lastPos = currentMovementPosition;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    //[remainingTouches minusSet:touches];
	//[renderer renderByRotatingAroundX:(startPos.x - lastPos.x)/320.0*180.0 rotatingAroundY:(startPos.y - lastPos.y)/480.0*180.0];
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
		
		xTotal += -x;
		yTotal += -y;
		
		
		//NSLog(@"angle:   %f", angle);
		NSLog(@"x:  %f   y:%f   z:%d",x,y,z);
		
		lastDist = CGPointMake(x, y);
		counter=0;
		xRot=0.0;
		yRot=0.0;
		
		
		
		
		if (xTotal >= 360) {
			xTotal -= 360;
		}
		else if (xTotal <= -360){
			xTotal+=360;
		}
		if (yTotal >= 360 ) {
			yTotal -=360;
		}
		else if (yTotal <= -360){
			yTotal+=360;
		}
		[rotations addObject:[NSValue valueWithCGPoint:CGPointMake(-x, -y)]];
		/*for (int i=0; i<blockArray.count; i++) {
		 [[blockArray objectAtIndex:i] rotatePos:x andY:-y];
		 }*/
	}
	else{
		[self rowLeft];
		block * temp = [self getBlock:(int)startArray.x andY:startArray.y andZ:5];// [(int)startArray.x+5][(int)startArray.y+5][10];
		NSLog(@"Block touched: (%d, %d, %d)      from (%f  %f  %d)",temp.x, temp.y, temp.z,startArray.x, startArray.y, 5);
	}
	NSLog(@"xTotal %f    yTotal %f   zTotal %f", xTotal, yTotal,zTotal);
	//[renderer renderByRotatingAroundX:(lastPos.x - startPos.x) rotatingAroundY:(lastPos.y - startPos.y)];
	//[renderer renderByRotatingAroundX:(90) rotatingAroundY:(90)];
	
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
	// Handle touches canceled the same as as a touches ended event
    [self touchesEnded:touches withEvent:event];
}

/*- (void) calcRotation {
 float hypot = sqrtf(powf(startPos.x - endPos.x,2.0f) + powf(startPos.y - endPos.y, 2));
 float yLen = endPos.y - startPos.y;
 float xLen = endPos.x - startPos.x;
 float mover = 0.0f;
 
 mover = hypot/(sqrtf(320.0f*320.0f+480.0f*480.0f))*360.0f;
 //maxDist = (xLen/320.0f)*180.0f;
 NSLog(@"Hypot: %f    x: %f     y: %f", mover, maxDist, yLen);
 [renderer setVals:mover andRot:((float)abs(xLen))/hypot andDist:(xLen/320.0f)*180.0f andDist2:(yLen/480.0f)*180.0f];
 mover-=0.1f;
 [self drawView:nil];
 
 }*/


@end
