//
//  testingView.m
//  testing
//
//  Created by Nina Schiff on 2010/07/05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "testingView.h"
#import "limits.h"
#import "math.h"
#include <stdio.h>
#include <unistd.h>


@implementation testingView
@synthesize touchesArray;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
		
		
		
		// Initialization code
		
		// Drawing
		touchesArray = [[NSMutableArray alloc]init];
		buttons = [[NSMutableArray alloc] init];
		averaged = [[NSMutableArray alloc] init];
		
		distance = 0.0;
				
		gestureList = [[NSMutableArray alloc] init];
		directionArray = [[NSMutableArray alloc] init];
		
		gradientCounter = 0;
		
		clear = NO;
		
		averagePos = -1;
		label = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 400, 100)];
		label.text = @"";
		
		//add the label to the view
		[self addSubview:label];	
		label.hidden = YES;
		
		disconnect = NO;
		showDiscon = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
		
		showDiscon.frame = CGRectMake(600, 880, 150, 50);
		
		[showDiscon setTitle:@"Seperate features" forState:UIControlStateNormal];
		
		showDiscon.backgroundColor = [UIColor clearColor];
		
		[showDiscon addTarget:self action:@selector(sepFeatures:) forControlEvents:UIControlEventTouchUpInside];
		
		showDiscon.adjustsImageWhenHighlighted = YES;
		[self addSubview:showDiscon];
		showDiscon.hidden = YES;
		
    }
    return self;
}

/* Handles drawing */
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0, 1.0);
	
	/* Draw features */
	if (averagePos == -1){
		if (directionArray.count > 1){
			
			CGPoint val = [[directionArray objectAtIndex:0] CGPointValue];
			CGContextMoveToPoint(context, val.x, val.y);
			
			val = [[directionArray objectAtIndex:1] CGPointValue];
			
			CGContextAddLineToPoint(context, val.x , val.y);
			
			for (int i=1; i<directionArray.count/2; i++) {
				
				val = [[directionArray objectAtIndex:i*2] CGPointValue];
				CGContextAddLineToPoint(context, val.x , val.y);
				
				val = [[directionArray objectAtIndex:i*2+1] CGPointValue];
				
				CGContextAddLineToPoint(context, val.x , val.y);
				
				
				
				
				
			}
			CGContextSetLineWidth(context, 4.0); 
			CGContextStrokePath(context);
			
			
			for (int i=0; i<directionArray.count; i++) {
				//offset = [[offsetVals objectAtIndex:i] CGPointValue];
				val = [[directionArray objectAtIndex:i] CGPointValue];
				
				CGContextFillEllipseInRect(context, CGRectMake(val.x, val.y, 15, 15));
			}
			
		}
		
		/* Point drawing */	
		CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0, 1.0);
		CGContextSetLineWidth(context, 0.5);
		
		if (touchesArray.count > 0){
			CGPoint pt;
			NSValue *val;
			for (int i = 0; i < touchesArray.count; i++){
				val = [touchesArray objectAtIndex:(NSUInteger)i];
				pt = [val CGPointValue];
				
				CGContextFillEllipseInRect(context, CGRectMake(pt.x, pt.y, 5, 5));
			}
		}
		
		CGContextStrokePath(context);
	}
	else{
		/* Draws averaged gestures */
		NSMutableArray * data = [averaged objectAtIndex:averagePos];
		CGPoint offset = CGPointMake(200, 400);
		float extra = 0.0;
		if (disconnect){
			extra = 10;
		}
		for (int i=0; i<data.count-1; i++) {
			
			
			
			NSArray * values = [[data objectAtIndex:i] getValues];
			
			CGPoint tempEnd = CGPointMake([[values objectAtIndex:0] floatValue], [[values objectAtIndex:1] floatValue]);
			
			
			
			
			CGContextMoveToPoint(context, offset.x, offset.y);
			
			
			CGContextAddLineToPoint(context, tempEnd.x+offset.x , tempEnd.y+offset.y);
			
			offset.x += tempEnd.x+extra;
			offset.y += tempEnd.y+extra;
			
			
			CGContextSetLineWidth(context, 4.0); 
			
			CGContextStrokePath(context);
			
		}
		
	}
	
}

/* Handles feature segmentation according to changes in direction */
- (void) recognitionDirection:(CGPoint)point{
	
	
	// set initial gradient for feature - gives indication of curve
	if (gradientCounter == 3 && [curFeature chordAngle] == 500) {
		[curFeature setAngles:CGPointMake(point.x, point.y)];
	}
	
	// Determine current direction
	float secX = previous.x - point.x;
	float secY = previous.y - point.y;
	
	
	distance+=sqrtf((point.x-previous.x)*(point.x-previous.x) + (point.y-previous.y)*(point.y-previous.y));
	
	
	int tempX = 5.0;
	int tempY = 5.0;
	
	// Determine which quadrant the line falls in
	// -10 -> 10 is considered to be a straight line
	if (secX > 10.0){
		tempX = 1;
	}
	else if (secX < -10.0){
		tempX = -1;
	}
	else{
		tempX = 0;
	}
	
	if (secY > 10.0){
		tempY = 1;
	}
	else if (secY < -10.0){
		tempY = -1;
	}
	else{
		tempY = 0;
	}					
	
	// If there has been a change in direction
	if (!(xDir == tempX && yDir == tempY)){
		
		// If the distance is large enough to warrant a new feature
		if (distance > 100){
			
			//float chordLength = sqrt((point.x - startPos.x)*(point.x - startPos.x) + (point.y - startPos.y)*(point.y - startPos.y)) ;
			// Determine the angle the new feature would have when drawn from the origin		
			float tempAngle = 180 + (atan2f(point.y-startPos.y,  startPos.x - point.x))*180/3.1415926;
			
			// if there is enough difference between this angle and the angle of the previous feature, create a new feature
			if (fabs(currentAngle - tempAngle) > 20 && fabs(currentAngle - (tempAngle + 360)) > 20 && fabs(tempAngle - (currentAngle + 360)) > 20 ){
				// for drawing
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				
				// update current feature
				[curFeature setChange:CGPointMake(startPos.x, startPos.y) andEnd:CGPointMake(point.x, point.y)];
				[curFeature setScaleD:distance];
								
				currentAngle = tempAngle;
				
				distance=0.0;
				startPos.x = point.x;
				startPos.y= point.y;
				
				
				gradientCounter = 0;
				
				// and create new one				
				feature * nextFeature = [[feature alloc] init];
				[curFeature setNext:nextFeature];
				[nextFeature setPrevious:curFeature];
				[nextFeature setStep:curFeature.step+1];
				curFeature = nextFeature;
			}
			else if ([directionArray count] > 1){ 
				// otherwise extend the previous feature
				// this helps counter the effect of small outliers
				[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				
				CGPoint first = [[directionArray objectAtIndex:directionArray.count-2] CGPointValue];
				CGPoint second = [[directionArray lastObject] CGPointValue];
				currentAngle = 180 + (atan2f(second.y-first.y,  first.x - second.x))*180/3.1415926;
				
				[curFeature.previous resetEnd:CGPointMake(point.x, point.y) andDist:distance];
				
				startPos.x = point.x;
				startPos.y = point.y;
				distance = 0.0;
				gradientCounter = 0;
			}
			else{
				// if this is the first feature found
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
								
				[curFeature setChange:CGPointMake(startPos.x, startPos.y) andEnd:CGPointMake(point.x, point.y)];
				[curFeature setScaleD:distance];
				
				feature * nextFeature = [[feature alloc] init];
				[curFeature setNext:nextFeature];
				[nextFeature setPrevious:curFeature];
				[nextFeature setStep:curFeature.step+1];
				
				curFeature = nextFeature;
				
				currentAngle = tempAngle;
				distance=0.0;
				startPos.x = point.x;
				startPos.y= point.y;
				gradientCounter = 0;
				
				
			}
			
			
			// reset direction values
			xDir = tempX;
			yDir = tempY;
			
		}
		else{
			
			xDir = tempX;
			yDir = tempY;
		}
	}
	previous.x = point.x;
	previous.y= point.y;
	
	gradientCounter++;
	
	
}





/* Removes most recent feature when 'Ignore' pressed in gesture capture */
- (void) removeGesture{
	if (gestureList.count != 0){
		[gestureList removeLastObject];
	}
}

/* Writes all current gestures to file and loads any saved gestures in order to do averaging */
- (void) writeToFile{
	
	// So it doesn't re-write gestures already in the file
	int beforeRead = gestureList.count;
	
	/* Determine path to file, etc, etc */
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// CHANGE FILE NAME FOR DIFFERENT GESTURES ----------------------------------------------------------------------
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"w.txt"];
	
	/* Reading */
	if (appFile){
		NSString *myText = [NSString stringWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:NULL];  
		NSLog(@"Data from file:\n %@", myText);
		NSArray *chunks = [myText componentsSeparatedByString: @"\n"];
		
		int place =0;
		
		while (place < chunks.count){
			// Number of features in gesture
			
			int numFeatures = [[chunks objectAtIndex:place] intValue];
			
			place++;
			
			feature * prevFeature = nil;
			for (int i=0; i<numFeatures; i++) {
				feature * currFeature = [[[feature alloc] init] autorelease];
				// If first feature in gesture
				if (i==0){
					[currFeature setMaxNum:numFeatures];
					
					[gestureList addObject:currFeature];
				}
				
				// values describing feature
				NSArray * data = [[chunks objectAtIndex:place] componentsSeparatedByString:@" "];
				place++;
				
				// end points
				[currFeature setChange:CGPointMake(0, 0) andEnd:CGPointMake([[data objectAtIndex:0] floatValue], [[data objectAtIndex:1] floatValue])];
							
				// scale
				[currFeature setScale:[[data objectAtIndex:2] floatValue]] ;
				
				// chord angle
				currFeature.chordAngle = [[data objectAtIndex:3] floatValue];
								
				// Step
				[currFeature setStep:i];
				
				// Create linked list
				if (prevFeature != nil){
					[prevFeature setNext:currFeature];
					[currFeature setPrevious:prevFeature];
					prevFeature = currFeature;
				}
				else{
					
					prevFeature = currFeature;
				}
				
			}
			
		}
	}
	
	/* Writing data */	
	NSMutableString * data= [NSMutableString stringWithString:@""];
	
	// Loop through all gestures and write to file
	feature * current;
	for (int i=0; i<beforeRead; i++) {
		current = [gestureList objectAtIndex:i];
		
		[data appendFormat:@"%d\n",current.maxNum];
		
		// Step through links to get data from all features in gesture
		while (current!=nil) {
			NSArray * array = [current getValues];								
			[data appendFormat:@"%f %f %f %f\n", [[array objectAtIndex:0] floatValue],[[array objectAtIndex:1] floatValue],[[array objectAtIndex:2] floatValue],[[array objectAtIndex:3] floatValue]];			
			current = current.next;
			
		}
	}
	if (beforeRead != 0){
		NSData *theData = [data dataUsingEncoding:NSUTF8StringEncoding];
		
		// Write to file
		if (clear || !appFile){
			[theData writeToFile:appFile atomically:YES];
		}
		else{
			NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:appFile];
			[myHandle seekToEndOfFile];
			[myHandle writeData:theData];
			[myHandle closeFile];
		}
	}
	
}


/* Average the values of all gestures */
- (void) averageFeatures{
	[self writeToFile];
	
	NSMutableDictionary * lengthData = [NSMutableDictionary dictionary];
	feature * temp;
	
	// Group gestures by number of features
	for (int i=0; i<gestureList.count; i++) {
		temp = [gestureList objectAtIndex:i];
		NSString * key = [NSString stringWithFormat:@"%d", temp.maxNum];
		
		if ([lengthData objectForKey:key] != nil){
			[[lengthData objectForKey:key] addObject:temp];
		}
		else{
			NSMutableArray * array = [[NSMutableArray alloc] init];
			[array autorelease];
			[array addObject:temp];
			[lengthData setObject:array forKey:key];
		}
		
	}
	
	NSArray *keys = [lengthData allKeys];
	
	// Average within each feature length category
	int counter = 0;
	[averaged removeAllObjects];
	for (NSString * keyV in keys) {
		
		NSArray * current = [lengthData objectForKey:keyV];
		// Initialise feature objects for each feature in gesture (depending on gesture length)
		NSMutableArray * gesture = [NSMutableArray array];
		for (int i=0; i<[keyV intValue]; i++) {
			feature * currFeature = [[feature alloc] init];
			[currFeature autorelease];
			[currFeature setChange:CGPointMake(0, 0) andEnd:CGPointMake(0, 0) ];
			[currFeature setStep:0];
			currFeature.scale = 0;
			currFeature.chordAngle = 0;
			
			
			[gesture addObject:currFeature];
			
		}
		
		// Add values of all festures in this length together
		feature * foundFeature;
		for (int i=0; i<current.count; i++){
			foundFeature = [current objectAtIndex:i];
			for (int j=0; j<[keyV intValue]; j++){
				[[gesture objectAtIndex:j] incrementAll:[foundFeature getValues]] ;
				foundFeature = foundFeature.next;
				
			}
		}
		
		// Divide by total for each gesture length
		for (int i=0; i<[keyV intValue]; i++) {
			[[gesture objectAtIndex:i] divideValues:current.count];
		}
		
		counter++;
		[gesture addObject:[NSNumber numberWithInt:current.count]];
		[averaged addObject:gesture];
		// Print results to screen
		NSLog(@"Gesture with %d features averaged from %d gestures", [gesture count]-1, current.count);
		for (int j=0; j<[gesture count]-1; j++) {
			[[gesture objectAtIndex:j] printValues];
		}
		
	}
	[self createDisplayButtons];
	[gestureList removeAllObjects];
	
}

- (void) createDisplayButtons{
	//UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 800, 200)];
	
	//set the label's text
	//label.text = @"The average gestures were determined by averaging the values based on number of features.\nSelect one of the below buttons to have the average gesture drawn.";
	
	//add the label to the view
	//[self addSubview:label];	
	showDiscon.hidden = NO;
	
	for (int i=0; i <averaged.count; i++) {
		UIButton * button = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
		
		button.frame = CGRectMake(20, 50+i*100, 50, 50);
		
		[button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
		
		button.backgroundColor = [UIColor clearColor];
		
		[button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
		
		button.adjustsImageWhenHighlighted = YES;
		[self addSubview:button];
		[buttons addObject:button];
	}
	
}

-(void)buttonPress:(id)sender{
	averagePos = [[sender titleForState:UIControlStateNormal] intValue];
	
	
	
	//set the label's text
	label.text = [NSString stringWithFormat:@"Gesture with %d features averaged from %d gestures", [[averaged objectAtIndex:averagePos] count]-1, [[[averaged objectAtIndex:averagePos] lastObject] intValue]];
	
	label.hidden = NO;
	
	
	[self setNeedsDisplay];
	
}

- (void) sepFeatures:(id)sender{
	if (disconnect){
		[showDiscon setTitle:@"Seperate features" forState:UIControlStateNormal];
		disconnect = NO;
	}
	else{
		[showDiscon setTitle:@"Join features" forState:UIControlStateNormal];
		disconnect=YES;
	}
	[self setNeedsDisplay];
	
}
/* Built in touch methods --------------------------------------------------------------------------- */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesBegan:touches withEvent:event];	
	
	// Reset values
	averagePos = -1;
	label.hidden = YES;
	showDiscon.hidden = YES;
	if (buttons.count !=0 ){
		for (int i=0; i<buttons.count; i++) {
			UIButton * button = [buttons objectAtIndex:i];
			button.hidden = YES;
		}
		[buttons removeAllObjects];
	}
	if (touchesArray.count > 0){
		[touchesArray removeAllObjects];
	}
	if (directionArray.count > 0){
		[directionArray removeAllObjects];
	}
	
	
	
	curFeature = [[feature alloc] init];
	[curFeature setStep:0];
	[gestureList addObject:curFeature];
	
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	distance=0;
	
	
	
	previous = pt;
	startPos.x = pt.x;
	startPos.y= pt.y;
	currentAngle = 0.0;
	
	gradientCounter = 1;
	
	
	
	[touchesArray addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
	
	[self setNeedsDisplay];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	CGPoint pt = [touch locationInView:self];
	
	[touchesArray addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
	[self setNeedsDisplay];
	[self recognitionDirection:pt];
	
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	
	
	
	[touchesArray addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
	
	float tempAngle = 180 + (atan2f(pt.y-startPos.y, startPos.x - pt.x))*180/3.1415926;
	
	int maxNum=-1;
	// does much the same stuff as in recognitionDirection
	if (fabs(currentAngle - tempAngle) > 20 && fabs(currentAngle - (tempAngle + 360)) > 20 && fabs(tempAngle - (currentAngle + 360)) > 20 ){
		
		
		if (distance > 100){
			
			[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
			[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			[curFeature setChange:CGPointMake(startPos.x, startPos.y) andEnd:CGPointMake(pt.x, pt.y)];
			[curFeature setScaleD:distance];
			
			
			[curFeature setNext:nil];
			maxNum = curFeature.step;
			
			
			
		}
		else {
			// ignore the new data - too short to be worth considering
			[curFeature.previous setNext:nil];
			maxNum = curFeature.previous.step;
			[curFeature release];
		}
		
		
	}
	else if ([directionArray count] > 1 ){
		[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
				
		[curFeature.previous resetEnd:CGPointMake(pt.x, pt.y) andDist:distance];
		
		
		[curFeature.previous setNext:nil];
		maxNum = curFeature.previous.step;
		[curFeature release];
		
	}
	else{
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		
		[curFeature setChange:CGPointMake(startPos.x, startPos.y) andEnd:CGPointMake(pt.x, pt.y)];
		[curFeature setScaleD:distance];
		
		maxNum = curFeature.step;
		[curFeature setNext:nil];
		
		
		
		
	}
	
	
	
	[[gestureList lastObject] setMaxNum:maxNum+1];
	
	[self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
	[touchesArray autorelease];
	[directionArray autorelease];
	
	[gestureList removeAllObjects];
	[gestureList autorelease];
    [super dealloc];
}
@end
