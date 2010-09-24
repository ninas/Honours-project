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
		doRock = NO;
		rocking = 0;
		
		mechanics = [[GameMechanics alloc] init];
		
		[renderer setBlockArray:mechanics.blockArray andTrans:mechanics.translateArray];
		
		
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
		
		// UI elements on game screen
		score = [[UILabel alloc] initWithFrame:CGRectMake(1000, 5, -220, 50)];
		score.text=@"0";
		score.textAlignment = UITextAlignmentRight;
		score.backgroundColor = [UIColor clearColor];
		score.textColor = [UIColor whiteColor];
		score.font = [UIFont fontWithName: @"Marker Felt" size: 48];
		[self addSubview:score];
		
		panel = [[sidePanel alloc] initWithFrame:CGRectMake(10, 10, 100, 750)];
		panel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		panel.layer.cornerRadius = 5;
		[self addSubview:panel];
		panelOn = YES;
		
		gestureDescriptor = [[UILabel alloc] initWithFrame:CGRectMake(340, 10, 400, 50)];
		gestureDescriptor.text=@"";
		gestureDescriptor.textAlignment = UITextAlignmentCenter;
		gestureDescriptor.backgroundColor = [UIColor clearColor]; 
		gestureDescriptor.textColor = [UIColor whiteColor];
		gestureDescriptor.alpha = 0;
		gestureDescriptor.font = [UIFont systemFontOfSize:25];
		[self addSubview:gestureDescriptor];
		
		gestureDCount = 101;
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
	
	score.text = [NSString stringWithFormat:@"%d", mechanics.score];
	if (gestureDCount < 30) {
		gestureDCount++;
	}
	else if (gestureDCount == 30){
		gestureDCount++;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.5];
		[gestureDescriptor setAlpha:0.0];
		[UIView commitAnimations];
		[renderer resetCounterA];
		//renderer.changeAlpha = YES;
	}
	
	if (doRock) {
		renderer.doingRock = YES;
		if (rocking == 0) {
			rockRotat.x = -8;
			rockRotat.y = 5;
			divideBy = 10;
		}
		else if (rocking == 10){
			rockRotat.x = 16;
			rockRotat.y = 0;
			divideBy = 20;
		}
		else if (rocking == 30){
			rockRotat.x = -8;
			rockRotat.y = -5;
			divideBy = 10;
			
		}
		else if (rocking == 40){
			rockRotat.x = 5;
			rockRotat.y = -8;
			divideBy = 10;
			
		}
		else if (rocking == 50){
			rockRotat.x = 0;
			rockRotat.y = 16;
			divideBy = 20;
			
		}
		else if (rocking == 70){
			rockRotat.x = -5;
			rockRotat.y = -8;
			divideBy = 10;
			
		}
		else if (rocking == 80){
			rocking = 0;
			doRock = NO;
			
			
		}
		
		float xRot = rockRotat.x/divideBy;
		float yRot = rockRotat.y/divideBy;
		rocking++;
		[renderer renderByRotatingAroundX:xRot rotatingAroundY:yRot];

	}
	else {
		
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
	panelStart.x = -1;
	panelStart.y = -1;
	if (numTouches == 1) {
		
		
			
		[stateMachine startOfGestureStateRecogniser];
	}
	else if (numTouches == 3){
		panelStart = [[[touchesArray objectAtIndex:0] objectAtIndex:0] CGPointValue];
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
        if (touch1 == touch && numTouches!=3) {
            
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
                   /* float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];*/
                    [stateMachine endOfGestureStateRecogniser];
					
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
                    /*float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];*/
					[stateMachine endOfGestureStateRecogniser];
					[packed1 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 1, 3");
				}
				else{
					NSLog(@"Ignored for now 1");
				}
			}
            
		}
		else if (touch2 == touch && numTouches!=3) {
            
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
                    /*float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];    */
					[stateMachine endOfGestureStateRecogniser];
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
                    /*float angles[2];
                    angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];  */
					[stateMachine endOfGestureStateRecogniser];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 2, 3");
				}
				/*else if (numTouches == 3 && packed3.count != 0 && packed1.count != 0){
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
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];   
					[stateMachine endOfGestureStateRecogniser];
					if (pt.x < 100 && panelStart.x != -1 && panelStart.y != -1) {
						float changeX = pt.x - panelStart.x;
						if (changeX < 0 && panelOn) {
							[panel slideIn];
							panelOn = NO;
						}
						else if (changeX > 0 && !panelOn){
							[panel slideOut];
							panelOn = YES;
						}
					}
					
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Three touches 2, 1, 3");
				}*/
				else{
					NSLog(@"Ignored for now 2");
				}
			}
            
		}
		else if (touch3 == touch && numTouches!=3) {
            
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
                    
                   /* float angles[2];
                    angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];*/
					[stateMachine endOfGestureStateRecogniser];
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
                    /*float angles[2];
                    angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                    angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];  */
					[stateMachine endOfGestureStateRecogniser];
					[packed1 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Two touches 3, 1");
				}
				/*else if (numTouches == 3 && packed1.count != 0 && packed2.count != 0){
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
                    [stateMachine doesGestureStateExistWithAngle:angles AndTouch:3];   
					[stateMachine endOfGestureStateRecogniser];
					if (pt.x < 100 && panelStart.x != -1 && panelStart.y != -1) {
						float changeX = pt.x - panelStart.x;
						if (changeX < 0 && panelOn) {
							[panel slideIn];
							panelOn = NO;
						}
						else if (changeX > 0 && !panelOn){
							[panel slideOut];
							panelOn = YES;
						}
					}
					[packed1 removeObjectAtIndex:0];
					[packed2 removeObjectAtIndex:0];
					[packed3 removeObjectAtIndex:0];
					NSLog(@"Three touches 3, 2, 1");
				}*/
				else{
					NSLog(@"Ignored for now 3");
				}
			}
            
		}
        
	}
    
	if (numTouches == 3 ){
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
		UITouch *touch = [array objectAtIndex:0];
		CGPoint pt = [touch locationInView:self];
		if (pt.x < 100 && panelStart.x != -1 && panelStart.y != -1) {
			float changeX = pt.x - panelStart.x;
			if (changeX < 0 && panelOn) {
				[panel slideOut];
				panelOn = NO;
			}
			else if (changeX > 0 && !panelOn){
				[panel slideIn];
				panelOn = YES;
			}
		}
		[packed1 removeAllObjects];
		[packed2 removeAllObjects];
		[packed3 removeAllObjects];
		NSLog(@"Three touches 1, 2, 3");
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
			/*else if (numTouches == 2 && packed2.count != 0 && packed3.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed2 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
               /* float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
				[stateMachine endOfGestureStateRecogniser];
				[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
				[packed1 removeAllObjects];
				[packed2 removeAllObjects];
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
                /*float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
				[stateMachine endOfGestureStateRecogniser];
				[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
				[packed1 removeAllObjects];
				[packed3 removeAllObjects];
				NSLog(@"Two touches 1, 3");
			}*/
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
				
				/*[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];*/
				
				
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
			/*else if (numTouches == 2 && packed1.count != 0 && packed3.count == 0){
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 and packed2 arrays
				 * 
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
                /*float angles[2];
                angles[0] = [[[packed1 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2]; 
				[stateMachine endOfGestureStateRecogniser];
                [mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
				[packed1 removeAllObjects];
				[packed2 removeAllObjects];
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
                /*float angles[2];
                angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
                angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
                [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];
				
				[stateMachine endOfGestureStateRecogniser];
                [mechanics setEnd:([[[packed2 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed2 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];
				[packed3 removeAllObjects];
				[packed2 removeAllObjects];
				
				NSLog(@"Two touches 2, 3");
			}*/
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
				/*[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];*/
								
				
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
                
				
				/*[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
				
				lastDist = [mechanics rotateCube];*/
				
				
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
	NSLog(@"End and num touches: %d   %d", numTouches,endCount);
    int originalNum = numTouches;
	if ((touch1 == nil && touch2 !=nil && touch3!=nil) || (touch2==nil && touch1!=nil && touch2!=nil) || (touch3==nil && touch1!=nil && touch2!=nil)) {
		NSLog(@"Doing rotation for 2");
		[stateMachine endOfGestureStateRecogniser];
		if (lastDist.x == 0 && lastDist.y == 0) {
			
		CGPoint val;
		CGPoint startV;
		if (touchesArray.count > 0) {
			val = [[[touchesArray objectAtIndex:0] lastObject] CGPointValue];
			startV = [[[touchesArray objectAtIndex:0] objectAtIndex:0] CGPointValue];
		}
		else if (touchesArray.count > 0){
			val = [[[touchesArray objectAtIndex:1] lastObject] CGPointValue];
			startV = [[[touchesArray objectAtIndex:1] objectAtIndex:0] CGPointValue];
		}
		else if (touchesArray.count > 0){
				val = [[[touchesArray objectAtIndex:2] lastObject] CGPointValue];
			startV = [[[touchesArray objectAtIndex:2] objectAtIndex:0] CGPointValue];
		}
		[mechanics setStartPos:startV];
		[mechanics setEnd:val.x andY:val.y];
		
		lastDist = [mechanics rotateCube];
		}
		[packed1 removeAllObjects];
		[packed2 removeAllObjects];
		[packed3 removeAllObjects];
		
		
		//[self touchesCancelled:touches withEvent:event];
		
		
		numTouches = 0;
		endCount = 0;
		touch1 = nil;
		touch2 = nil;
		touch3 = nil;
	}
	else if (endCount == numTouches && endCount!=0) {
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
            
			/*[mechanics setEnd:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).x andY:([[[packed1 lastObject] objectAtIndex:0] CGPointValue]).y];
			
			lastDist = [mechanics rotateCube];*/
			
			
			[packed1 removeAllObjects];
			[packed2 removeAllObjects];
			[packed3 removeAllObjects];
		}
		/*if (packed1.count > 0 && packed2.count > 0 ) {
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Take EVERYTHING in the arrays !!!!!!!!!!!!!!!!!!!!!!!!!!
			/* FUNCTION CALL GOES HERE
			 * Data is in packed1, packed2 and packed3 arrays
			 * 
			 * [0] (CGPoint)	endPoint
			 * [1] (float)		scale
			 * [2] (float)		angle
			 * [3] (float)		gradient angle
			 
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
			 
            float angles[2];
            angles[0] = [[[packed2 objectAtIndex:0] objectAtIndex:2] floatValue];
            angles[1] = [[[packed3 objectAtIndex:0] objectAtIndex:2] floatValue];
            [stateMachine doesGestureStateExistWithAngle:angles AndTouch:2];               
			[packed2 removeAllObjects];
			[packed3 removeAllObjects];
		}*/
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
	
	if (type != NULL && originalNum==1){
		NSString * descrip =[[NSString string] init];
		if(strcmp(type, "left") == 0) {
		[mechanics rowLeft];
			NSLog(@"Calling left");
			descrip = @"Row left";
		}
		else if (strcmp(type, "right") == 0){
			[mechanics rowRight];
			descrip = @"Row right";
		}
		else if (strcmp(type, "up") == 0){
			[mechanics columnUp];
			descrip = @"Column up";
		}
		else if (strcmp(type, "down") == 0){
			[mechanics columnDown];
			descrip = @"Column down";
		}
		else if (strcmp(type, "diagonalU") == 0){
			[mechanics zForward];
			descrip = @"Forward";
		}
		else if (strcmp(type, "diagonalDown") == 0){
			[mechanics zBackward];
			descrip = @"Backward";
		}
		else if (strcmp(type, "z") == 0){
			[mechanics moveIn];
			descrip = @"Move together";
		}
		else if (strcmp(type, "sLeft") == 0){
			[mechanics swapBlocks:0];
			descrip = @"Swap left";
		}
		else if (strcmp(type, "sRight") == 0){
			[mechanics swapBlocks:1];
			descrip = @"Swap right";
		}
		else if (strcmp(type, "sDown") == 0){
			[mechanics swapBlocks:3];
			descrip = @"Swap down";
		}
		else if (strcmp(type, "sUp") == 0){
			[mechanics swapBlocks:2];
			descrip = @"Swap up";
		}
		else if (strcmp(type, "square") == 0){
			doRock = YES;
			descrip = @"Rock cube";
		}
		gestureDescriptor.text = descrip;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.75];
		[gestureDescriptor setAlpha:50];
		[UIView commitAnimations];
		gestureDCount = 0;
	}
	//[self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}





@end
