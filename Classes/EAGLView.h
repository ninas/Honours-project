//
//  EAGLView.h
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ES1Renderer.h"
#import "block.h"

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{  
	CGPoint lastPos;
@private
    ES1Renderer * renderer;

    BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    // Use of the CADisplayLink class is the preferred method for controlling your animation timing.
    // CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
    // The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
    // isn't available.
    id displayLink;
    NSTimer *animationTimer;
	
	CGPoint startPos;
	CGPoint endPos;
	float maxDist;
	NSMutableArray * blockArray;
	block **** blockPlace;
	CGPoint  lastDist;
	float counter;
	int totalCounter;
	CGPoint startArray;
	
	
	int yAxis [3];
	int xAxis [3];
	int zAxis[3];
	
	
	
	
	
	
	
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic) CGPoint startPos;
@property (nonatomic) CGPoint endPos;
@property (nonatomic) float maxDist;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView:(id)sender;
- (void)rowLeft;

- (void)rowRight;
- (void) columnUp;
- (void) columnDown;
- (void) zForward;
- (void) zBackward;
- (void) swapBlocks:(int)direction;
//- (void) removeBlocks;
- (block *) getBlock:(int)x andY:(int)y andZ:(int)z;

//- (void) calcRotation;

@end
