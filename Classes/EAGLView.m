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
    [renderer renderByRotatingAroundX:0 rotatingAroundY:0];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
	
	// New touches are not yet included in the current touches for the view
	startPos = [[touches anyObject] locationInView:self];
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
	
		[renderer renderByRotatingAroundX:(lastPos.x - startPos.x) rotatingAroundY:(lastPos.y - startPos.y)];
	

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
