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
	
	
	//frame = CGRectMake(50, 70, 200, 100);
	save = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
	
	save.frame = CGRectMake(120, 980, 200, 50);
	
	[save setTitle:@"Create gesture file" forState:UIControlStateNormal];
	
	save.backgroundColor = [UIColor clearColor];
	
	[save addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
	
	save.adjustsImageWhenHighlighted = YES;
	[self.view addSubview:save];
	
	UIButton * ignore = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
	
	ignore.frame = CGRectMake(0, 980, 100, 50);
	
	[ignore setTitle:@"Ignore" forState:UIControlStateNormal];
	
	ignore.backgroundColor = [UIColor clearColor];
	
	[ignore addTarget:self action:@selector(ignorePressed:) forControlEvents:UIControlEventTouchUpInside];
	
	ignore.adjustsImageWhenHighlighted = YES;
	[self.view addSubview:ignore];
	
	
	UIButton * clearF = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
	
	clearF.frame = CGRectMake(340, 980, 200, 50);
	
	[clearF setTitle:@"Clear gesture file" forState:UIControlStateNormal];
	
	clearF.backgroundColor = [UIColor clearColor];
	
	[clearF addTarget:self action:@selector(clearPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	clearF.adjustsImageWhenHighlighted = YES;
	[self.view addSubview:clearF];
	
	//set the position of the label
	//frame = CGRectMake(50, 170, 200, 100);
	
	//allocate the label
	//UILabel *label = [[UILabel alloc] initWithFrame:frame];
	
	//set the label's text
	//label.text = @"Touch event detected:";
	
	//add the label to the view
	//[self.view addSubview:label];
	//frame = CGRectMake(50, 270, 200, 100);
	//touchData = [[UILabel alloc] initWithFrame:frame];
	//touchData.text = @"poo";
	
	//[self.view addSubview:touchData];
	
	//release the label
	//[label release];
}


-(void)savePressed:(id)sender 
{
	
    //[self.textField resignFirstResponder];
	[self.view averageFeatures];
	
    //self.delegateRef.view2Controller.label.text = self.textField.text;
	
}

-(void)ignorePressed:(id)sender 
{
	
    //[self.textField resignFirstResponder];
	//[sender setTitle:@"Pressed gesture" forState:UIControlStateNormal];
	
	
		
	[self.view removeGesture];
    //self.delegateRef.view2Controller.label.text = self.textField.text;
	
}

-(void)clearPressed:(id)sender 
{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// CHANGE FILE NAME FOR DIFFERENT GESTURES ----------------------------------------------------------------------
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"w.txt"];
	
	
	if (appFile){
		NSData *theData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
		
		// Write to file
		
		[theData writeToFile:appFile atomically:YES];
		
	}
	
}

- (void) createButtons
{
		
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
