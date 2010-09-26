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
#import "GameMechanics.h"
#import "GestureStateMachine.h"
#import "recognition.h"
#import "sidePanel.h"
#import "gesturePanel.h"
#import "dmMenu.h"
#import "dmSide.h"
#import "tutorial.h"

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
	
	float maxDist;
	//NSMutableArray * blockArray;
	
	CGPoint  lastDist;
	float counter;
	int totalCounter;
	
	GameMechanics * mechanics;
	sidePanel * panel;
	gesturePanel * gestPanel;
	dmMenu * dm;
	dmSide * dmSideMenu;
	tutorial * tut;
		
	/*** For drawing ***/
	// Holds all points recieved
	NSMutableArray *touchesArray;
	// Holds features
	NSMutableArray * directionArray;
    
    
	recognition * recognition1;
	recognition * recognition2;
	recognition * recognition3;
    
	UITouch * touch1;
	UITouch * touch2;
	UITouch * touch3;
    
	int numTouches;
    
	NSMutableArray * packed1;
	NSMutableArray * packed2;
	NSMutableArray * packed3;
    
	BOOL ended1;
	BOOL ended2;
	BOOL ended3;
    
	int endCount;
	
	GestureStateMachine *stateMachine;
	
	CGPoint panelStart;
	UILabel * score;
	UILabel * gestureDescriptor;
	int gestureDCount;
	
	BOOL panelOn;
	int rocking;
	BOOL doRock;
	CGPoint rockRotat;
	float divideBy;
	
	BOOL checkValue;
	
	
	UIButton * newGame;
	int gameVersion;
	BOOL versionsDone [3];
	
	CGPoint tapPosition;
	BOOL userRotation;
	
	NSMutableArray * lineButtons;
	NSMutableArray * swapButtons;
	NSMutableArray * rotateButtons;
	UIButton * restart;
	UIButton * restart2;
	int tutCounter;
	BOOL dmSwitches[10];
	
	
	NSTimer * gameTimer;
	
	int * gestureCounter;
	
	UILabel * highScore;
	
	int highSc;
	
	
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic) int gameVersion;
@property (nonatomic) float maxDist;
@property (nonatomic, retain) NSMutableArray *touchesArray;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView:(id)sender;
- (void) beginTouch:(NSArray*) array;
- (void) movedTouch:(NSArray*)array;
- (void) endedTouch:(NSArray*)array;
- (void) setVersion;
- (void) setDoRock;
- (void) setRotateOn;
- (void) lineSelector:(id)select;
- (void) swapSelector:(id)select;
- (void) rotateSelector:(id)select;
- (void) startGameTimer;
- (void) stopGameTimer;
- (void) changeGameVersion;
- (void) readHighScore;


@end
