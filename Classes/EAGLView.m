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
@synthesize touchesArray;
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
		// OpenGL        
		renderer = [[ES1Renderer alloc] init];
		
		if (!renderer)
		{
			[self release];
			return nil;
		}
        
		// Game loop variables
        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;
		
		// Init 
		//blockArray = [[NSMutableArray alloc] init];
		//blockPlace = (block****) malloc(11*sizeof(block***));
		
		
		counter = 0;
		totalCounter = 0;
		
		mechanics = [[GameMechanics alloc] init];
		
		[renderer setBlockArray:mechanics.blockArray];
		
		
		touchesArray = [[NSMutableArray alloc]init];
		for (int i=0; i<3; i++) {
			[touchesArray addObject:[[NSMutableArray alloc] init]];
		}
		[renderer setTouchesArray:touchesArray];
		directionArray = [[NSMutableArray alloc] init];
		for (int i=0; i<3; i++) {
			[directionArray addObject:[[NSMutableArray alloc] init]];
		}
		
		touch1 = nil;
		touch2 = nil;
		touch3 = nil;
		
		recognition1 = [[recognition alloc] init];
		recognition2 = [[recognition alloc] init];
		recognition3 = [[recognition alloc] init];
		
		[recognition1 setDirArray:[directionArray objectAtIndex:0]];
		[recognition2 setDirArray:[directionArray objectAtIndex:1]];
		[recognition3 setDirArray:[directionArray objectAtIndex:2]];
		
		numTouches = 0;
		endCount = 0;
		
		packed1 = [[NSMutableArray alloc] init];
		packed2 = [[NSMutableArray alloc] init];
		packed3 = [[NSMutableArray alloc] init];
		
		ended1 = YES;
		ended2 = YES;
		ended3 = YES;
		
		stateMachine = [[GestureStateMachine alloc] init];
		
		[self setMultipleTouchEnabled:YES]; 
		
		
		
        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
    }
	
    return self;
}

/*
 * Game loop
 */
- (void)drawView:(id)sender
{
    float xRot = lastDist.x/40;
	float yRot = lastDist.y/40;
	
	if (xRot != 0 || yRot !=0) {
		counter+=1;
	}
	
	
	if (counter==40) {
		lastDist.x=0;
		lastDist.y=0;
		counter=0;
		totalCounter-=40;
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


/* ----------------------------------- These methods will be moved to feature extraction ----------------------------------- */

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
 
 totalCounter+=40;
 
 
 }
 else{
 [self rowLeft];
 block * temp = [self getBlock:(int)startArray.x andY:startArray.y andZ:5];// [(int)startArray.x+5][(int)startArray.y+5][10];
 
 //		block * temp = blockPlace[(int)startArray.x+5][(int)startArray.y+5][10];
 NSLog(@"Block touched: (%d, %d, %d)      from (%f  %f  %d)",temp.x, temp.y, temp.z,startArray.x, startArray.y, 5);
 }
 
 
 }
 
 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
 {
 // Handle touches canceled the same as as a touches ended event
 [self touchesEnded:touches withEvent:event];
 }*/


/* Built in touch methods --------------------------------------------------------------------------- */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	[super touchesBegan:touches withEvent:event];	
	NSLog(@"Touches began");
    
	NSArray * array = [touches allObjects];
	for (int i=0; i<array.count; i++) {
		UITouch *touch = [array objectAtIndex:i];
		CGPoint pt = [touch locationInView:self];
        
		if (touch1 == nil && touch!= touch2 && touch!= touch3) {
			touch1=touch;
			[mechanics setStart:pt.x andY:pt.y];
			if ([[touchesArray objectAtIndex:0] count] > 0){
				[[touchesArray objectAtIndex:0] removeAllObjects];
			}
			if ([[directionArray objectAtIndex:0] count] > 0){
				[[directionArray objectAtIndex:0] removeAllObjects];
			}
			if (packed1.count > 0) {
				[packed1 removeAllObjects];
			}
			[recognition1 reset:pt];
			[[touchesArray objectAtIndex:0] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			numTouches++;
			ended1 = NO;
            
		}
		else if (touch2 == nil && touch!= touch1 && touch!= touch3) {
			touch2=touch;
			[mechanics setStart:pt.x andY:pt.y];
			if ([[touchesArray objectAtIndex:1] count] > 0){
				[[touchesArray objectAtIndex:1] removeAllObjects];
			}
			if ([[directionArray objectAtIndex:1] count] > 0){
				[[directionArray objectAtIndex:1] removeAllObjects];
			}
			if (packed2.count > 0) {
				[packed2 removeAllObjects];
			}
            
			[recognition2 reset:pt];
			[[touchesArray objectAtIndex:1] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			numTouches++;
			ended2 = NO;
            
		}
		else if (touch3 == nil && touch!= touch1 && touch!= touch2) {
			touch3=touch;
			[mechanics setStart:pt.x andY:pt.y];
			if ([[touchesArray objectAtIndex:2] count] > 0){
				[[touchesArray objectAtIndex:2] removeAllObjects];
			}
			if ([[directionArray objectAtIndex:2] count] > 0){
				[[directionArray objectAtIndex:2] removeAllObjects];
			}
			if (packed3.count > 0) {
				[packed3 removeAllObjects];
			}
            
			[recognition3 reset:pt];
			[[touchesArray objectAtIndex:2] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			numTouches++;
			ended3 = NO;
            
		}
        
	}
    
	if (touch1 == nil ) {
        
		if ([[touchesArray objectAtIndex:0] count] > 0){
			[[touchesArray objectAtIndex:0] removeAllObjects];
		}
		if ([[directionArray objectAtIndex:0] count] > 0){
			[[directionArray objectAtIndex:0] removeAllObjects];
		}
		if (packed1.count > 0) {
			[packed1 removeAllObjects];
		}
        
        
	}
	if (touch2 == nil ) {
        
		if ([[touchesArray objectAtIndex:1] count] > 0){
			[[touchesArray objectAtIndex:1] removeAllObjects];
		}
		if ([[directionArray objectAtIndex:1] count] > 0){
			[[directionArray objectAtIndex:1] removeAllObjects];
		}
		if (packed2.count > 0) {
			[packed2 removeAllObjects];
		}
        
        
	}
	if (touch3 == nil ) {
        
		if ([[touchesArray objectAtIndex:2] count] > 0){
			[[touchesArray objectAtIndex:2] removeAllObjects];
		}
		if ([[directionArray objectAtIndex:2] count] > 0){
			[[directionArray objectAtIndex:2] removeAllObjects];
		}
		if (packed3.count > 0) {
			[packed3 removeAllObjects];
		}
	}
	
	if (numTouches == 1) {
		
		
			
		[stateMachine startOfGestureStateRecogniser];
	}
	else {
		CGPoint point = [[[touchesArray objectAtIndex:0] objectAtIndex:0] CGPointValue];
		[mechanics setStart: point.x andY:point.y];
		[stateMachine endOfGestureStateRecogniser];
	}

	//[self setNeedsDisplay];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
    
    
	NSArray * array = [touches allObjects];
	for (int i=0; i<array.count; i++) {
		UITouch *touch = [array objectAtIndex:i];
		CGPoint pt = [touch locationInView:self];
        
		if (touch1 == touch) {
            
			[[touchesArray objectAtIndex:0] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			if([recognition1 recognitionDirection:CGPointMake(pt.x, pt.y)]){
				[packed1 addObject:[recognition1 getFeature]];
				if (numTouches == 1) {
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 array
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angle[1];
                    angle[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angle AndTouch:1];
					[packed1 removeObjectAtIndex:0];
					NSLog(@"One touch 1");
				}
				else if (numTouches == 2 && packed2.count != 0 && packed3.count == 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 and packed2 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
                    
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					NSLog(@"Two touches 1, 2");
				}
				else if (numTouches == 2 && packed3.count != 0 && packed2.count == 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 and packed3 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
					[packed1 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 1, 3");
				}
				else if (numTouches == 3 && packed3.count != 0 && packed2.count != 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1, packed2 and packed3 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    /*float angles[3];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];*/
					[stateMachine endOfGestureStateRecogniser];
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Three touches 1, 2, 3");
				}
				else{
					NSLog(@"Ignored for now 1");
				}
			}
            
		}
		else if (touch2 == touch) {
            
			[[touchesArray objectAtIndex:1] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			if([recognition2 recognitionDirection:CGPointMake(pt.x, pt.y)]){
				[packed2 addObject:[recognition2 getFeature]];
				if (numTouches == 1) {
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 array
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angles[1];
                    angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:1];
					[packed2 removeObjectAtIndex:0];
					NSLog(@"One touch 2");
				}
				else if (numTouches == 2 && packed1.count != 0 && packed3.count == 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 and packed2 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];                    
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					NSLog(@"Two touches 2, 1");
				}
				else if (numTouches == 2 && packed3.count != 0 && packed1.count == 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 and packed3 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angles[2];
                    angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];                    
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 2, 3");
				}
				else if (numTouches == 3 && packed3.count != 0 && packed1.count != 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1, packed2 and packed3 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    /*float angles[3];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];*/   
					[stateMachine endOfGestureStateRecogniser];
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Three touches 2, 1, 3");
				}
				else{
					NSLog(@"Ignored for now 2");
				}
			}
            
		}
		else if (touch3 == touch) {
            
			[[touchesArray objectAtIndex:2] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			if([recognition3 recognitionDirection:CGPointMake(pt.x, pt.y)]){
				[packed3 addObject: [recognition3 getFeature]];
				if (numTouches == 1) {
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 array
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angle[1];
                    angle[0] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angle AndTouch:1];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"One touch 3");
				}
				else if (numTouches == 2 && packed2.count != 0 && packed1.count == 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 and packed2 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    
                    float angles[2];
                    angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 3, 2");
				}
				else if (numTouches == 2 && packed1.count != 0 && packed2.count == 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1 and packed3 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];                    
					[packed1 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 3, 1");
				}
				else if (numTouches == 3 && packed1.count != 0 && packed2.count != 0){
					/* FUNCTION CALL GOES HERE
					 * Data is in packed1, packed2 and packed3 arrays
					 * 
					 * [0] (CGPoint)	endPoint
					 * [1] (float)		scale
					 * [2] (float)		angle
					 * [3] (float)		gradient angle
					 */
                    /*float angles[3];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3]; */  
					[stateMachine endOfGestureStateRecogniser];
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Three touches 3, 2, 1");
				}
				else{
					NSLog(@"Ignored for now 3");
				}
			}
            
		}
        
	}
    
    
	//[self setNeedsDisplay];
	//[self recognitionDirection:pt];
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
    
	NSArray * array = [touches allObjects];
	for (int i=0; i<array.count; i++) {
		UITouch *touch = [array objectAtIndex:i];
		CGPoint pt = [touch locationInView:self];
        
		if (touch1 == touch) {
            
			endCount++;
            
			[[touchesArray objectAtIndex:0] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			[packed1 addObject: [recognition1 end:CGPointMake(pt.x, pt.y)]];
			
			NSArray * temp = [recognition1 getSecond];
			if (temp != nil) {
				[packed1 addObject:temp];
			}
			if (numTouches == 1) {
				
				if (recognition1.tap) {
					[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
					[mechanics removeBlocks];
					NSLog(@"Single tap");
					[packed1 removeObjectAtIndex:0];
					continue;
				}
				
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 array
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[1];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:1];          
				[packed1 removeObjectAtIndex:0];
				NSLog(@"One touch 1");
			}
			else if (numTouches == 2 && packed2.count != 0 && packed3.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed2 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
				[packed1 removeObjectAtIndex:0];
				[packed2 removeObjectAtIndex:0];
				NSLog(@"Two touches 1, 2");
			}
			else if (numTouches == 2 && packed3.count != 0 && packed2.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed3 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
				[packed1 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Two touches 1, 3");
			}
			else if (numTouches == 3 && packed3.count != 0 && packed2.count != 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1, packed2 and packed3 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                /*float angles[3];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];  */
				
				/*float totalX= (([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x +
							   ([[[packed2 lastObject] objectAtIndex:0] CGPointValue]).x +
							   ([[[packed3 lastObject] objectAtIndex:0] CGPointValue]).x)/3.0;
				
				float totalY= (([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y +
							   ([[[packed2 lastObject] objectAtIndex:0] CGPointValue]).y +
							   ([[[packed3 lastObject] objectAtIndex:0] CGPointValue]).y)/3.0;*/
				
				[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
				
				
				[packed1 removeObjectAtIndex:0];
				[packed2 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Three touches 1, 2, 3");
			}
			else{
				NSLog(@"Ignored for now 1");
			}
            
            
		}
		else if (touch2 == touch) {
            
			endCount++;
            
			[[touchesArray objectAtIndex:1] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
            
			[packed2 addObject: [recognition2 end:CGPointMake(pt.x, pt.y)]];
			NSArray * temp = [recognition2 getSecond];
			if (temp != nil) {
				[packed2 addObject:temp];
			}
            
			if (numTouches == 1) {
				if (recognition2.tap) {
					[mechanics setEnd:([[[packed2 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed2 lastObject] objectAtIndex:0] CGPointValue]).y];
					[mechanics removeBlocks];
					NSLog(@"Single tap");
					[packed2 removeObjectAtIndex:0];
					continue;
				}
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 array
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angle[1];
                angle[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angle AndTouch:1];
                
				[packed2 removeObjectAtIndex:0];
				NSLog(@"One touch 2");
			}
			else if (numTouches == 2 && packed1.count != 0 && packed3.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed2 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];  
                
				[packed1 removeObjectAtIndex:0];
				[packed2 removeObjectAtIndex:0];
				NSLog(@"Two touches 2, 1");
			}
			else if (numTouches == 2 && packed3.count != 0 && packed1.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed3 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[2];
                angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];                  
				[packed2 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Two touches 2, 3");
			}
			else if (numTouches == 3 && packed3.count != 0 && packed1.count != 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1, packed2 and packed3 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
               /* float angles[3];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];   */
				[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
								
				
				[packed1 removeObjectAtIndex:0];
				[packed2 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Three touches 2, 1, 3");
			}
			else{
				NSLog(@"Ignored for now 2");
			}			
            
		}
		else if (touch3 == touch) {
            
			endCount++;
			[[touchesArray objectAtIndex:2] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
            
			[packed3 addObject: [recognition3 end:CGPointMake(pt.x, pt.y)]];
			NSArray * temp = [recognition3 getSecond];
			if (temp != nil) {
				[packed3 addObject:temp];
			}
			if (numTouches == 1) {
				
				if (recognition3.tap) {
					[mechanics setEnd:([[[packed3 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed3 lastObject] objectAtIndex:0] CGPointValue]).y];
					[mechanics removeBlocks];
					NSLog(@"Single tap");
					[packed3 removeObjectAtIndex:0];
					continue;
				}
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 array
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angle[1];
                angle[0] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angle AndTouch:1];
                
				[packed3 removeObjectAtIndex:0];
				NSLog(@"One touch 3");
			}
			else if (numTouches == 2 && packed2.count != 0 && packed1.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed2 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[2];
                angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];                  
				[packed2 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Two touches 3, 2");
			}
			else if (numTouches == 2 && packed1.count != 0 && packed2.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed3 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];                  
				[packed1 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Two touches 3, 1");
			}
			else if (numTouches == 3 && packed1.count != 0 && packed2.count != 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1, packed2 and packed3 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                /*float angles[3];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];  */
                
				
				[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
				
				
				[packed1 removeObjectAtIndex:0];
				[packed2 removeObjectAtIndex:0];
				[packed3 removeObjectAtIndex:0];
				NSLog(@"Three touches 3, 2, 1");
			}
			else{
				NSLog(@"Ignored for now 3");
			}
            
            
		}
        
	}
    int originalNum = numTouches;
	if (endCount == numTouches && endCount!=0) {
		NSLog(@"Removing last ones   %d", endCount);
		numTouches = 0;
		endCount = 0;
		touch1 = nil;
		touch2 = nil;
		touch3 = nil;
		
		// send remaining features - there may be backlog
		if (packed1.count > 0 && packed2.count > 0 && packed3.count > 0) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            /*float angles[3];
            angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
            angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
            angles[2] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];   */
            
			[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
			
			lastDist = [mechanics rotateCube];
			
			
			[packed1 removeAllObjects];
			[packed2 removeAllObjects];
			[packed3 removeAllObjects];
		}
		if (packed1.count > 0 && packed2.count > 0 ) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            float angles[2];
            angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
            angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];               
			[packed1 removeAllObjects];
			[packed2 removeAllObjects];
            
		}
		if (packed1.count > 0  && packed3.count > 0) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            
            float angles[2];
            angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
            angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];               
			[packed1 removeAllObjects];
            
			[packed3 removeAllObjects];
		}
		if (packed2.count > 0 && packed3.count > 0) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            float angles[2];
            angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
            angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];               
			[packed2 removeAllObjects];
			[packed3 removeAllObjects];
		}
		if (packed1.count > 0 ) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            float angles[1];
            angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:1];               
			[packed1 removeAllObjects];
            
		}
		if (packed2.count > 0 ) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            float angles[1];
            angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:1];               
			[packed2 removeAllObjects];
            
		}
		if (packed3.count > 0) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 */
            float angles[1];
            angles[0] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:1];                  
			[packed3 removeAllObjects];
		}
	}
	else {
		if (packed1.count == 0 && touch1 != nil) {
			numTouches--;
			endCount--;
		}
		if (packed2.count == 0 && touch2 != nil) {
			numTouches--;
			endCount--;
		}
		if (packed3.count == 0 && touch3 != nil) {
			numTouches--;
			endCount--;
		}
	}
    
    [stateMachine endOfGestureStateRecogniser];
	char* type = [stateMachine getGestureType];
	NSLog(@"%s found", type);
	
	if (type != NULL && originalNum!=3){
		if(strcmp(type, "left") == 0) {
		[mechanics rowLeft];
			NSLog(@"Calling left");
		}
		else if (strcmp(type, "right") == 0){
			[mechanics rowRight];
		}
		else if (strcmp(type, "up") == 0){
			[mechanics columnUp];
		}
		else if (strcmp(type, "down") == 0){
			[mechanics columnDown];
		}
		else if (strcmp(type, "diagonalU") == 0){
			[mechanics zForward];
		}
		else if (strcmp(type, "z") == 0){
			[mechanics moveIn];
		}
	}
	//[self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}





@end
