    //
//  testingViewController.m
//  testing
//
//  Created by Nina Schiff on 2010/06/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "testingViewController.h"


@implementation testingViewController
//@synthesize touchData;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	//create a frame that sets the bounds of the view
	CGRect frame = CGRectMake(0, 0, 800, 1050);
	
	//allocate the view
	self.view = [[testingView alloc] initWithFrame:frame];
	 
	
	//set the view's background color
	self.view.backgroundColor = [UIColor whiteColor];
	
	
	
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
	
	//Get all the touches.
	NSSet *allTouches = [event allTouches];
	
	//Number of touches on the screen
	switch ([allTouches count])
	{
		case 1:
		{
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			CGPoint currentTouchPosition = [touch locationInView:self.view];
			switch([touch tapCount])
			{
				case 1://Single tap
					NSLog(@"single tap %f", currentTouchPosition.y);
					touchData.text = [NSString stringWithFormat:@"single tap %f", currentTouchPosition.y];
					break;
				case 2://Double tap.
					NSLog(@"double tap");
					break;
			}
		} 
			break;
	}
	
}*/

@end
