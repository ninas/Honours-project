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
#import "time.h"

@implementation EAGLView

@synthesize animating;
@synthesize touchesArray;
@synthesize maxDist;
@dynamic animationFrameInterval;
@synthesize gameVersion;

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
		srand(time(NULL));
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
		versionsDone[0] = NO;
		versionsDone[1] = NO;
		versionsDone[2] = NO;
        
		gameVersion = 3;
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
		checkValue = YES;
		mechanics = [[GameMechanics alloc] init];
		
		gestureCounter = (int*)malloc(13*sizeof(int));
		memset(gestureCounter, 0, sizeof(int)*13);
		
		mechanics.gestureCounter = gestureCounter;
		
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
		
		
		
		// UI elements on game screen
		score = [[UILabel alloc] initWithFrame:CGRectMake(1000, 5, -220, 50)];
		score.text=@"0";
		score.textAlignment = UITextAlignmentRight;
		score.backgroundColor = [UIColor clearColor];
		score.textColor = [UIColor whiteColor];
		score.font = [UIFont fontWithName: @"Marker Felt" size: 48];
		[self addSubview:score];
		
		restart = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		restart.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		restart.layer.cornerRadius = 5;
		restart.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		restart.titleLabel.textAlignment = UITextAlignmentCenter;
		[restart setTitle:@"New game" forState:UIControlStateNormal];
		[restart addTarget:mechanics action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
		restart.adjustsImageWhenHighlighted = YES;
		
		
		
		//[dm addSubview:rock];
		//dm.rock = rock;
		
		
		panel = [[sidePanel alloc] initWithFrame:CGRectMake(10, 10, 100, 750)];
		panel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		panel.layer.cornerRadius = 5;
		[self addSubview:panel];
		panelOn = YES;
		panel.restart = restart;
		[panel addSubview:restart];
		
		restart2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		restart2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		restart2.layer.cornerRadius = 5;
		restart2.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		restart2.titleLabel.textAlignment = UITextAlignmentCenter;
		[restart2 setTitle:@"New game" forState:UIControlStateNormal];
		[restart2 addTarget:mechanics action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
		restart2.adjustsImageWhenHighlighted = YES;
		
		dm = [[dmMenu alloc] initWithFrame:CGRectMake(10, 10, 100, 750)];
		dm.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		dm.layer.cornerRadius = 5;
		[self addSubview:dm];
		[dm setup:mechanics];
		dm.restart = restart2;
		[dm addSubview:restart2];
		
		dmSideMenu = [[dmSide alloc] initWithFrame:CGRectMake(120, 10, 100, 500)];
		dmSideMenu.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
		dmSideMenu.layer.cornerRadius = 5;
		[self addSubview:dmSideMenu];
		dm.gestPanel = dmSideMenu;
		dmSideMenu.hidden = YES;
		
		
		
		gestureDescriptor = [[UILabel alloc] initWithFrame:CGRectMake(340, 10, 400, 50)];
		gestureDescriptor.text=@"";
		gestureDescriptor.textAlignment = UITextAlignmentCenter;
		gestureDescriptor.backgroundColor = [UIColor clearColor]; 
		gestureDescriptor.textColor = [UIColor whiteColor];
		gestureDescriptor.alpha = 0;
		gestureDescriptor.font = [UIFont systemFontOfSize:25];
		[self addSubview:gestureDescriptor];
		
		
		gestPanel = [[gesturePanel alloc] initWithFrame:CGRectMake(120, 10, 600, 400)];
		//gestPanel.frame = CGRectMake(120, 10, 600, 400);
		gestPanel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
		gestPanel.layer.cornerRadius = 5;
		[self addSubview:gestPanel];
		[panel setGest:gestPanel];
		gestPanel.hidden = YES;
		
		gestureDCount = 101;
        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
		
		//[self setVersion];
		
		tut = [[tutorial alloc] initWithFrame:CGRectMake(10, 10, 400, 325)];
		tut.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
		tut.layer.cornerRadius = 5;
		[self addSubview:tut];
		
		UIButton * second = [[UIButton alloc] initWithFrame:CGRectMake(900, 650, 100, 100)];
		second.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		second.layer.cornerRadius = 5;
		second.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		second.titleLabel.textAlignment = UITextAlignmentCenter;
		[second setTitle:@"Start game" forState:UIControlStateNormal];
		[second addTarget:self action:@selector(setVersion) forControlEvents:UIControlEventTouchUpInside];
		[tut addSubview:second];
		tut.second = second;
		tut.second.hidden = YES;
		
		score.hidden = YES;
		panel.hidden = YES;
		dm.hidden = YES;
		tutCounter = 0;
    }
	
    return self;
}


- (void) changeGameVersion{
	[self stopGameTimer];
	int prevVersion = gameVersion;
	BOOL check = NO;
	for (int i=0; i<3; i++) {
		if (versionsDone[i] == NO) {
			check=YES;
		}
	}
	if (check) {
		do {
			gameVersion = rand()%3;
		} while (versionsDone[gameVersion] != NO);
		
		versionsDone[gameVersion] = YES;
		
	}
	
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"gameLog.txt"];
	
	
	NSMutableString * data = [NSMutableString stringWithString:@""];
	if (prevVersion != 3) {
		// write gesture info
		
		for (int i=0; i<13; i++) {
			[data appendFormat:@"%d:  %d\n",i,gestureCounter[i]];
		}
		[data appendFormat:@"\n"];
		
		
		memset(gestureCounter, 0, sizeof(int)*13);
	}
	if (check) {
		[data appendFormat:@"%d\n",gameVersion];
	}
	
	NSData *theData = [data dataUsingEncoding:NSUTF8StringEncoding];
	
		if (appFile){
			NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:appFile];
			[myHandle seekToEndOfFile];
			[myHandle writeData:theData];
			[myHandle closeFile];
			NSLog(@"writing2");
		}
		
		
	[tut showFirstScreen:gameVersion];
	tut.hidden = NO;

	
}
- (void) setVersion{
	
	[self startGameTimer];
	tut.hidden = YES;
	if ([[touchesArray objectAtIndex:0] count] > 0) {
		[[touchesArray objectAtIndex:0] removeAllObjects];
	}
	
	[mechanics restart];
	[renderer setBlockArray:mechanics.blockArray andTrans:mechanics.translateArray];
	score.hidden = NO;
	if (gameVersion == 0) {
		panel.hidden = YES;
		[panel hideWindow];
		
		dm.hidden = NO;
		dm.frame = CGRectMake(10, 10, 100, 750);
		[dm enable];
		[dm clearOthers];
		dmSideMenu.hidden = YES;
		userRotation = NO;
		
		[self setMultipleTouchEnabled:NO]; 
		
		UIButton * rock = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.layer.cornerRadius = 5;
		rock.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rock.titleLabel.textAlignment = UITextAlignmentCenter;
		[rock setTitle:@"Rock shape" forState:UIControlStateNormal];
		[rock addTarget:self action:@selector(setDoRock) forControlEvents:UIControlEventTouchUpInside];
		rock.adjustsImageWhenHighlighted = YES;
		[dm addSubview:rock];
		dm.rock = rock;
		
		
		UIButton * rotate = [[UIButton alloc] initWithFrame:CGRectMake(10, 410, 80, 80)];
		rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotate.layer.cornerRadius = 5;
		rotate.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rotate.titleLabel.textAlignment = UITextAlignmentCenter;
		[rotate setTitle:@"Rotate shape" forState:UIControlStateNormal];
		[rotate addTarget:self action:@selector(setRotateOn) forControlEvents:UIControlEventTouchUpInside];
		rotate.adjustsImageWhenHighlighted = YES;
		[dm addSubview:rotate];
		dm.rotate = rotate;
		
		
		UIButton * rowL = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		rowL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rowL.layer.cornerRadius = 5;
		rowL.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rowL.titleLabel.textAlignment = UITextAlignmentCenter;
		[rowL setTitle:@"Move row left" forState:UIControlStateNormal];
		[rowL addTarget:self action:@selector(lineSelector:) forControlEvents:UIControlEventTouchUpInside];
		rowL.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:rowL];
		rowL.hidden = YES;
		
		UIButton * rowR = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 80, 80)];
		rowR.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rowR.layer.cornerRadius = 5;
		rowR.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rowR.titleLabel.textAlignment = UITextAlignmentCenter;
		[rowR setTitle:@"Move row right" forState:UIControlStateNormal];
		[rowR addTarget:self action:@selector(lineSelector:) forControlEvents:UIControlEventTouchUpInside];
		rowR.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:rowR];
		rowR.hidden = YES;
		
		UIButton * columnU = [[UIButton alloc] initWithFrame:CGRectMake(10, 210, 80, 80)];
		columnU.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		columnU.layer.cornerRadius = 5;
		columnU.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		columnU.titleLabel.textAlignment = UITextAlignmentCenter;
		[columnU setTitle:@"Move column up" forState:UIControlStateNormal];
		[columnU addTarget:self action:@selector(lineSelector:) forControlEvents:UIControlEventTouchUpInside];
		columnU.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:columnU];
		columnU.hidden = YES;
		
		UIButton * columnD = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		columnD.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		columnD.layer.cornerRadius = 5;
		columnD.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		columnD.titleLabel.textAlignment = UITextAlignmentCenter;
		[columnD setTitle:@"Move column down" forState:UIControlStateNormal];
		[columnD addTarget:self action:@selector(lineSelector:) forControlEvents:UIControlEventTouchUpInside];
		columnD.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:columnD];
		columnD.hidden = YES;
		
		UIButton * backward = [[UIButton alloc] initWithFrame:CGRectMake(10, 410, 80, 80)];
		backward.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		backward.layer.cornerRadius = 5;
		backward.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		backward.titleLabel.textAlignment = UITextAlignmentCenter;
		[backward setTitle:@"Move line backward" forState:UIControlStateNormal];
		[backward addTarget:self action:@selector(lineSelector:) forControlEvents:UIControlEventTouchUpInside];
		backward.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:backward];
		backward.hidden = YES;
		
		UIButton * forward = [[UIButton alloc] initWithFrame:CGRectMake(10, 510, 80, 80)];
		forward.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		forward.layer.cornerRadius = 5;
		forward.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		forward.titleLabel.textAlignment = UITextAlignmentCenter;
		[forward setTitle:@"Move line forward" forState:UIControlStateNormal];
		[forward addTarget:self action:@selector(lineSelector:) forControlEvents:UIControlEventTouchUpInside];
		forward.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:forward];
		forward.hidden = YES;
		
		lineButtons = [[NSMutableArray alloc] init];
		[lineButtons addObject:rowL];
		[lineButtons addObject:rowR];
		[lineButtons addObject:columnD];
		[lineButtons addObject:columnU];
		[lineButtons addObject:backward];
		[lineButtons addObject:forward];
		dmSideMenu.lineButtons = lineButtons;
		
		UIButton * swapL = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		swapL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapL.layer.cornerRadius = 5;
		swapL.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapL.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapL setTitle:@"Swap block left" forState:UIControlStateNormal];
		[swapL addTarget:self action:@selector(swapSelector:) forControlEvents:UIControlEventTouchUpInside];
		swapL.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:swapL];
		swapL.hidden = YES;
		
		UIButton * swapR = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 80, 80)];
		swapR.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapR.layer.cornerRadius = 5;
		swapR.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapR.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapR setTitle:@"Swap block right" forState:UIControlStateNormal];
		[swapR addTarget:self action:@selector(swapSelector:) forControlEvents:UIControlEventTouchUpInside];
		swapR.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:swapR];
		swapR.hidden = YES;
		
		UIButton * swapU = [[UIButton alloc] initWithFrame:CGRectMake(10, 210, 80, 80)];
		swapU.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapU.layer.cornerRadius = 5;
		swapU.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapU.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapU setTitle:@"Swap block up" forState:UIControlStateNormal];
		
		[swapU addTarget:self action:@selector(swapSelector:) forControlEvents:UIControlEventTouchUpInside];
		swapU.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:swapU];
		swapU.hidden = YES;
		
		UIButton * swapD = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		swapD.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		swapD.layer.cornerRadius = 5;
		swapD.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		swapD.titleLabel.textAlignment = UITextAlignmentCenter;
		[swapD setTitle:@"Swap block down" forState:UIControlStateNormal];
		[swapD addTarget:self action:@selector(swapSelector:) forControlEvents:UIControlEventTouchUpInside];
		swapD.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:swapD];
		swapD.hidden = YES;
		
		swapButtons = [[NSMutableArray alloc] init];
		[swapButtons addObject:swapL];
		[swapButtons addObject:swapR];
		[swapButtons addObject:swapD];
		[swapButtons addObject:swapU];
		dmSideMenu.swapButtons = swapButtons;
		
		
		
		UIButton * rotL = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
		rotL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotL.layer.cornerRadius = 5;
		rotL.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rotL.titleLabel.textAlignment = UITextAlignmentCenter;
		[rotL setTitle:@"Rotate left" forState:UIControlStateNormal];
		[rotL addTarget:self action:@selector(rotateSelector:) forControlEvents:UIControlEventTouchUpInside];
		rotL.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:rotL];
		rotL.hidden = YES;
		
		UIButton * rotR = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 80, 80)];
		rotR.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotR.layer.cornerRadius = 5;
		rotR.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rotR.titleLabel.textAlignment = UITextAlignmentCenter;
		[rotR setTitle:@"Rotate right" forState:UIControlStateNormal];
		[rotR addTarget:self action:@selector(rotateSelector:) forControlEvents:UIControlEventTouchUpInside];
		rotR.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:rotR];
		rotR.hidden = YES;
		
		UIButton * rotU = [[UIButton alloc] initWithFrame:CGRectMake(10, 210, 80, 80)];
		rotU.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotU.layer.cornerRadius = 5;
		rotU.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rotU.titleLabel.textAlignment = UITextAlignmentCenter;
		[rotU setTitle:@"Rotate up" forState:UIControlStateNormal];
		
		[rotU addTarget:self action:@selector(rotateSelector:) forControlEvents:UIControlEventTouchUpInside];
		rotU.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:rotU];
		rotU.hidden = YES;
		
		UIButton * rotD = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 80, 80)];
		rotD.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rotD.layer.cornerRadius = 5;
		rotD.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rotD.titleLabel.textAlignment = UITextAlignmentCenter;
		[rotD setTitle:@"Rotate down" forState:UIControlStateNormal];
		[rotD addTarget:self action:@selector(rotateSelector:) forControlEvents:UIControlEventTouchUpInside];
		rotD.adjustsImageWhenHighlighted = YES;
		[dmSideMenu addSubview:rotD];
		rotD.hidden = YES;
		
		rotateButtons = [[NSMutableArray alloc] init];
		[rotateButtons addObject:rotL];
		[rotateButtons addObject:rotR];
		[rotateButtons addObject:rotU];
		[rotateButtons addObject:rotD];
		dmSideMenu.rotateButtons = rotateButtons;
		
	}
	else if (gameVersion == 1){
		panel.hidden = NO;
		[panel hideWindow];
		[panel enable];
		
		dm.hidden = YES;
		dmSideMenu.hidden = YES;
		
		panel.frame = CGRectMake(10, 10, 100, 750);
		
		[self setMultipleTouchEnabled:YES]; 
		
	}
	else if (gameVersion == 2){
		panel.hidden = NO;
		[panel disable];
		[panel hideWindow];
		dm.hidden = NO;
		[dm clearOthers];
		dmSideMenu.hidden = YES;
		dm.frame = CGRectMake(10, 10, 100, 300);
		panel.frame = CGRectMake(10, 460, 100, 300);
		[dm disable];
		[self setMultipleTouchEnabled:YES];
		
		UIButton * rock = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 80, 80)];
		rock.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		rock.layer.cornerRadius = 5;
		rock.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		rock.titleLabel.textAlignment = UITextAlignmentCenter;
		[rock setTitle:@"Rock shape" forState:UIControlStateNormal];
		[rock addTarget:self action:@selector(setDoRock) forControlEvents:UIControlEventTouchUpInside];
		rock.adjustsImageWhenHighlighted = YES;
		[dm addSubview:rock];
		dm.rock = rock;
	}
}

- (void) lineSelector:(id)select{
	for (int i=0; i<lineButtons.count; i++) {
		UIButton * temp = [lineButtons objectAtIndex:i];
		if (temp == select) {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
			
			if (dmSwitches[i]) {
				dmSwitches[i] = NO;
			}
			else{
				dmSwitches[i] = YES;
			}
		}
		else {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
			dmSwitches[i] = NO;
		}
		
	}
	for (int i = 6; i<10; i++) {
		dmSwitches[i]=NO;
	}
	
}

- (void) swapSelector:(id)select{
	for (int i=0; i<swapButtons.count; i++) {
		UIButton * temp = [swapButtons objectAtIndex:i];
		if (temp == select) {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
			if (dmSwitches[i+6]) {
				dmSwitches[i+6] = NO;
			}
			else{
				dmSwitches[i+6] = YES;
			}
		}
		else {
			temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
			dmSwitches[i+6] = NO;
		}
		
	}
	for (int i = 0; i<6; i++) {
		dmSwitches[i]=NO;
	}
	
	
	
}

- (void) rotateSelector:(id)select{
	if (lastDist.x == 0 && lastDist.y ==0) {
		for (int i=0; i<rotateButtons.count; i++) {
			UIButton * temp = [rotateButtons objectAtIndex:i];
			if (temp == select) {
				temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
				[mechanics setStartPos:CGPointMake(0.0, 0.0)];
				if (i == 0) {
					[mechanics setEnd:-90 andY:0];
					
					
				}
				else if (i == 1) {
					[mechanics setEnd:90 andY:0];
				}
				else if (i == 2) {
					[mechanics setEnd:0 andY:-90];
				}
				else if (i == 3) {
					[mechanics setEnd:0 andY:90];
				}
				
				
				lastDist = [mechanics rotateCube];
			}
			else {
				temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
				
			}
			
		}
	}
	
	
}



- (void) setDoRock{
	doRock = YES;
	gestureCounter[11]+=1;
	[dm clearOthers];
	[dmSideMenu fadeOut];
	dm.rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
	dm.rotateVis = NO;
	
	for (int i=0; i<10; i++) {
		dmSwitches[i]=NO;
	}
}

- (void) setRotateOn{
	
	if (dm.rotateVis) {
		[dmSideMenu fadeOut];
		dm.rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		dm.rotateVis = NO;
	}
	else{
		[dm clearOthers];
		[dmSideMenu setFrame:CGRectMake(120, 360, 100, 400)];
		[dmSideMenu setupRotate];
		[dmSideMenu fadeIn];
		dm.rotate.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
		dm.rotateVis = YES;
	}
	NSLog(@"Rotate being called");
	for (int i=0; i<10; i++) {
		dmSwitches[i]=NO;
	}
}

/*
 * Game loop
 */
- (void)drawView:(id)sender
{
	
	score.text = [NSString stringWithFormat:@"%d", mechanics.score];
	if (gameVersion != 0 && touch1 == nil && touch2 == nil && touch3 == nil) {
		checkValue = YES;
		if (packed1.count > 0) {
			[packed1 removeAllObjects];
		}
		if (packed2.count > 0) {
			[packed2 removeAllObjects];
		}
		if (packed3.count > 0) {
			[packed3 removeAllObjects];
		}
	}
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
			for (int i=0; i<rotateButtons.count; i++) {
				UIButton * temp = [rotateButtons objectAtIndex:i];
				temp.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
				
			}
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

- (void) startGameTimer{
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeGameVersion) userInfo:nil repeats:FALSE];
	
	
}
- (void) stopGameTimer{
	[gameTimer invalidate];
	gameTimer = nil;
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
	[mechanics release];
	[panel release];
	[gestPanel release];
	[dm release];
	[dmSideMenu release];
	
	[touchesArray removeAllObjects];
	[touchesArray release];
	
	[recognition1 release];
	[recognition2 release];
	[recognition3 release];
    
    [packed1 removeAllObjects];
	[packed1 release];
	
	[packed2 removeAllObjects];
	[packed2 release];
	
	[packed3 removeAllObjects];
	[packed3 release];
	
    
	[stateMachine release];
	
	[score release];
	[gestureDescriptor release];
	[newGame release];
	
	[lineButtons removeAllObjects];
	[lineButtons release];
	
	[swapButtons removeAllObjects];
	[swapButtons release];
	
	[rotateButtons removeAllObjects];
	[rotateButtons release];
	[tut release];
	
	
    [super dealloc];
}





/* Built in touch methods --------------------------------------------------------------------------- */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	[super touchesBegan:touches withEvent:event];	
	NSLog(@"Touches began");
	if (gameVersion != 0) {
		renderer.inRed = NO;
		NSArray * array = [touches allObjects];
		[self beginTouch:array];
	}
	else {
		UITouch * touch = [touches anyObject];
		CGPoint pt = [touch locationInView:self];
		
		tapPosition = CGPointMake(pt.x, pt.y);
		[mechanics setStart:pt.x andY:pt.y];
		if ([[touchesArray objectAtIndex:0] count] > 0) {
			[[touchesArray objectAtIndex:0] removeAllObjects];
		}
		[[touchesArray objectAtIndex:0] addObject:[NSValue valueWithCGPoint:CGPointMake(1100, 900)]];
	}
	
    
	
	
	
	
	//[self setNeedsDisplay];
}

- (void) beginTouch:(NSArray*) array{
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
		checkValue = NO;
		panelStart = [[[touchesArray objectAtIndex:0] objectAtIndex:0] CGPointValue];
	}
	else {
		checkValue = NO;
		if ([[touchesArray objectAtIndex:0] count] > 0) {
			CGPoint point = [[[touchesArray objectAtIndex:0] objectAtIndex:0] CGPointValue];
			[mechanics setStart: point.x andY:point.y];
			
		}
		else{
		[mechanics setStart:0 andY:0];
		}
		[stateMachine endOfGestureStateRecogniser];
	}
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
    
    if (gameVersion != 0) {
		NSArray * array = [touches allObjects];
		[self movedTouch:array];
	}
	else {
		//[[touchesArray objectAtIndex:0] addObject:[NSValue valueWithCGPoint:[[touches anyObject] locationInView:self]]];
	}
	
	
	
    
}

- (void) movedTouch:(NSArray*)array{
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
					checkValue = NO;
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
					checkValue = NO;
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
					checkValue = NO;
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
					checkValue = NO;
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
					checkValue = NO;
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
					checkValue = NO;
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
		checkValue = NO;
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
		[renderer clearTouches];
		NSLog(@"Three touches 1, 2, 3");
	}
    
	//[self setNeedsDisplay];
	//[self recognitionDirection:pt];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
    if (gameVersion!=0) {
		NSArray * array = [touches allObjects];
		[self endedTouch:array];
	}
	else {
		UITouch * touch = [touches anyObject];
		CGPoint pt = [touch locationInView:self];
		/*if (dm.rotateVis) {
		 [mechanics setStartPos:tapPosition];
		 [mechanics setEnd:pt.x andY:pt.y];
		 
		 lastDist = [mechanics rotateCube];
		 }
		 else */if (sqrt((pt.x - tapPosition.x)*(pt.x - tapPosition.x) +  (pt.y - tapPosition.y)*(pt.y - tapPosition.y)) < 10){
			 if (dm.lineVis) {
				 
				 if (dmSwitches[0]) {
					 [mechanics rowLeft];
				 }
				 else if (dmSwitches[1]) {
					 [mechanics rowRight];
				 }
				 else if (dmSwitches[2]) {
					 [mechanics columnDown];
				 }
				 else if (dmSwitches[3]) {
					 [mechanics columnUp];
				 }
				 else if (dmSwitches[4]) {
					 [mechanics zBackward];
				 }
				 else if (dmSwitches[5]) {
					 [mechanics zForward];
				 }
			 }
			 else if (dm.swapVis){
				 if (dmSwitches[6]) {
					 [mechanics swapBlocks:0];
				 }
				 else if (dmSwitches[7]) {
					 [mechanics swapBlocks:1];
				 }
				 else if (dmSwitches[8]) {
					 [mechanics swapBlocks:3];
				 }
				 else if (dmSwitches[9]) {
					 [mechanics swapBlocks:2];
				 }
			 }
			 else{
				 [mechanics setEnd:pt.x andY:pt.y];
				 [mechanics removeBlocks];
				 
				 for (int i=0; i<10; i++) {
					 dmSwitches[i] = NO;
				 }
			 }
		 }
		
	}
	
	
	//[self setNeedsDisplay];
}

- (void) endedTouch:(NSArray*)array{
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
				checkValue = NO;
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
				[renderer clearTouches];
				
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
				checkValue = NO;
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
				[renderer clearTouches];		
				
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
				checkValue = NO;
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
				[renderer clearTouches];
				
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
		checkValue = NO;
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
			checkValue = NO;
			[renderer clearTouches];
			
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
	
	if (type != NULL && originalNum==1 && checkValue && gameVersion!=3){
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
			if (gameVersion!=2){
				[mechanics moveIn];
				descrip = @"Move together";
			}
			else {
				renderer.inRed = YES;
			}
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
		else if ( strcmp(type, "square") == 0){
			if (gameVersion!=2){
				doRock = YES;
				descrip = @"Rock cube";
				gestureCounter[11]++;
			}
			else {
				renderer.inRed = YES;
			}
			
		}
		gestureDescriptor.text = descrip;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.75];
		[gestureDescriptor setAlpha:50];
		[UIView commitAnimations];
		gestureDCount = 0;
		
	}
	else if (type != NULL && originalNum==1 && checkValue && gameVersion==3){
		NSString * descrip =[[NSString string] init];
		BOOL rightGes = NO;
		if(strcmp(type, "left") == 0) {
			
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:0];
			if (rightGes) {
				tutCounter++;
				if (tutCounter == 3) {
					[self changeGameVersion];
				}
			}
		}
		else if (strcmp(type, "right") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:1];
		}
		else if (strcmp(type, "up") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:2];
		}
		else if (strcmp(type, "down") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:3];
		}
		else if (strcmp(type, "diagonalU") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:4];
		}
		else if (strcmp(type, "diagonalDown") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:5];
		}
		else if (strcmp(type, "z") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:6];
		}
		else if (strcmp(type, "sLeft") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:7];
		}
		else if (strcmp(type, "sRight") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:8];
		}
		else if (strcmp(type, "sDown") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:9];
		}
		else if (strcmp(type, "sUp") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:10];
		}
		else if ( strcmp(type, "square") == 0){
			descrip = @"Gesture found";
			rightGes = [tut incrementGes:11];
			if (rightGes) {
				tutCounter++;
				if (tutCounter == 10) {
					[self changeGameVersion];
				}
			}
			
		}
		
		if (rightGes) {
			gestureDescriptor.text = descrip;
			
		}
		else{
			renderer.inRed = YES;
			
			
			gestureDescriptor.text = @"Gesture not found";
			
			
			
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.75];
		[gestureDescriptor setAlpha:50];
		[UIView commitAnimations];
		gestureDCount = 0;
	}
	else if (type == NULL && originalNum==1 && checkValue){
		renderer.inRed = YES;
		if (gameVersion==3) {
			
			gestureDescriptor.text = @"Gesture not found";
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.75];
			[gestureDescriptor setAlpha:50];
			[UIView commitAnimations];
			gestureDCount = 0;
			
		}
	}
	
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}





@end
