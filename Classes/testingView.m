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
		touchesArray = [[NSMutableArray alloc]init];
		distance = 0.0;
		directionArray = [[NSMutableArray alloc] init];
		gradientCounter = 0;
		cAngle = 500;
		
    }
    return self;
}

/* Handles drawing */
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0, 1.0);
	
	/* Draw features */
	
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

/* Handles feature segmentation according to changes in direction */
- (void) recognitionDirection:(CGPoint)point{
	
	
	// set initial gradient for feature - gives indication of curve
	if (gradientCounter == 3 && cAngle == 500) {
		cAngle = 180 + (atan2f(point.y-startPos.y,  startPos.x - point.x))*180/3.1415926;
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
				
				if (prevEnd.x != 0 && prevEnd.y != 0) {
					/*  FUNCTION CALL GOES HERE  */
					/* Values to use are:
					 * prevEnd - end values
					 * prevScale - scale
					 * prevAngle - angle of line
					 * prevCAngle - angle of starting gradient
					 */
				}
				
				
				// for drawing
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				
				// update current feature
				
				prevStart = CGPointMake(startPos.x, startPos.y);
				prevEnd.x = point.x - startPos.x;
				prevEnd.y = point.y - startPos.y;
				
				if (startDist != -1) {
					prevScale = distance / startDist;
				}
				else {
					startDist = distance;
					prevScale = 1;
				}
				
				prevAngle = tempAngle;
				if (cAngle != 500) {
					prevCAngle = cAngle;
				}
				else{
					prevCAngle = prevAngle;
				}
				
				currentAngle = tempAngle;
				distance=0.0;
				startPos.x = point.x;
				startPos.y= point.y;
				gradientCounter = 0;
				
			}
			else if ([directionArray count] > 1){ 
				// otherwise extend the previous feature
				// this helps counter the effect of small outliers
				[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				prevEnd = CGPointMake(point.x - prevStart.x, point.y - prevStart.y);
				if (prevScale != 1) {
					prevScale += distance / startDist;
				}
				else {
					startDist += distance;
					
				}
				
				CGPoint first = [[directionArray objectAtIndex:directionArray.count-2] CGPointValue];
				CGPoint second = [[directionArray lastObject] CGPointValue];
				currentAngle = 180 + (atan2f(second.y-first.y,  first.x - second.x))*180/3.1415926;
				prevAngle = currentAngle;
				
				startPos.x = point.x;
				startPos.y = point.y;
				distance = 0.0;
				gradientCounter = 0;
			}
			else{
				// if this is the first feature found
				// for drawing
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				
				// update current feature
				
				prevStart = CGPointMake(startPos.x, startPos.y);
				prevEnd.x = point.x - startPos.x;
				prevEnd.y = point.y - startPos.y;
				
				if (startDist != -1) {
					prevScale = distance / startDist;
				}
				else {
					startDist = distance;
					prevScale = 1;
				}
				
				prevAngle = tempAngle;
				if (cAngle != 500) {
					prevCAngle = cAngle;
				}
				else{
					prevCAngle = prevAngle;
				}
				
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


/* Built in touch methods --------------------------------------------------------------------------- */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesBegan:touches withEvent:event];	
	
	// Reset values
	if (touchesArray.count > 0){
		[touchesArray removeAllObjects];
	}
	if (directionArray.count > 0){
		[directionArray removeAllObjects];
	}
	
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	distance=0;
	
	previous = pt;
	startPos.x = pt.x;
	startPos.y= pt.y;
	currentAngle = 0.0;
	
	gradientCounter = 1;
	cAngle = 500;
	startDist = -1;
	prevEnd = CGPointMake(0.0, 0.0);
	
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
	
	// does much the same stuff as in recognitionDirection
	if (fabs(currentAngle - tempAngle) > 20 && fabs(currentAngle - (tempAngle + 360)) > 20 && fabs(tempAngle - (currentAngle + 360)) > 20 ){
		
		/*  FUNCTION CALL GOES HERE  */
		/* Values to use are:
		 * prevEnd - end values
		 * prevScale - scale
		 * prevAngle - angle of line
		 * prevCAngle - angle of starting gradient
		 */
		
		if (distance > 100){
			
			// for drawing
			[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
			[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
			
			// update current feature
			
			prevStart = CGPointMake(startPos.x, startPos.y);
			prevEnd.x = pt.x - startPos.x;
			prevEnd.y = pt.y - startPos.y;
			
			if (startDist != -1) {
				prevScale = distance / startDist;
			}
			else {
				startDist = distance;
				prevScale = 1;
			}
			
			prevAngle = tempAngle;
			if (cAngle != 500) {
				prevCAngle = cAngle;
			}
			else{
				prevCAngle = prevAngle;
			}
			
			/*  FUNCTION CALL GOES HERE  */
			/* Values to use are:
			 * prevEnd - end values
			 * prevScale - scale
			 * prevAngle - angle of line
			 * prevCAngle - angle of starting gradient
			 */
			
		}
		
	}
	else if ([directionArray count] > 1 ){
		
		[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		prevEnd = CGPointMake(pt.x - prevStart.x, pt.y - prevStart.y);
		if (prevScale != 1) {
			prevScale += distance / startDist;
		}
		else {
			startDist += distance;
			
		}
		
		CGPoint first = [[directionArray objectAtIndex:directionArray.count-2] CGPointValue];
		CGPoint second = [[directionArray lastObject] CGPointValue];
		prevAngle = 180 + (atan2f(second.y-first.y,  first.x - second.x))*180/3.1415926;
		
		/*  FUNCTION CALL GOES HERE  */
		/* Values to use are:
		 * prevEnd - end values
		 * prevScale - scale
		 * prevAngle - angle of line
		 * prevCAngle - angle of starting gradient
		 */
		
	}
	else{
		/*  FUNCTION CALL GOES HERE  */
		/* Values to use are:
		 * prevEnd - end values
		 * prevScale - scale
		 * prevAngle - angle of line
		 * prevCAngle - angle of starting gradient
		 */
		
		// for drawing
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		
		// update current feature
		
		prevStart = CGPointMake(startPos.x, startPos.y);
		prevEnd.x = pt.x - startPos.x;
		prevEnd.y = pt.y - startPos.y;
		
		if (startDist != -1) {
			prevScale = distance / startDist;
		}
		else {
			startDist = distance;
			prevScale = 1;
		}
		
		prevAngle = tempAngle;
		if (cAngle != 500) {
			prevCAngle = cAngle;
		}
		else{
			prevCAngle = prevAngle;
		}
		
		/*  FUNCTION CALL GOES HERE  */
		/* Values to use are:
		 * prevEnd - end values
		 * prevScale - scale
		 * prevAngle - angle of line
		 * prevCAngle - angle of starting gradient
		 */
		
	}
	
	[self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
	[touchesArray autorelease];
	[directionArray autorelease];
	
    [super dealloc];
}
@end
