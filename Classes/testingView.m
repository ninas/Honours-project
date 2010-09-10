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
		for (int i=0; i<3; i++) {
			[touchesArray addObject:[[NSMutableArray alloc] init]];
		}
		
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
		
		[self setMultipleTouchEnabled:YES];
    }
    return self;
}

/* Handles drawing */
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0, 1.0);
	NSArray * array;
	/* Draw features */
	for (int i=0; i<3; i++) {
		
		array = [directionArray objectAtIndex:i];
		if (array.count > 1){
			
			CGPoint val = [[array objectAtIndex:0] CGPointValue];
			CGContextMoveToPoint(context, val.x, val.y);
			
			val = [[array objectAtIndex:1] CGPointValue];
			
			CGContextAddLineToPoint(context, val.x , val.y);
			
			for (int i=1; i<array.count/2; i++) {
				
				val = [[array objectAtIndex:i*2] CGPointValue];
				CGContextAddLineToPoint(context, val.x , val.y);
				
				val = [[array objectAtIndex:i*2+1] CGPointValue];
				
				CGContextAddLineToPoint(context, val.x , val.y);
				
			}
			CGContextSetLineWidth(context, 4.0); 
			CGContextStrokePath(context);
			
			for (int i=0; i<array.count; i++) {
				//offset = [[offsetVals objectAtIndex:i] CGPointValue];
				val = [[array objectAtIndex:i] CGPointValue];
				
				CGContextFillEllipseInRect(context, CGRectMake(val.x, val.y, 15, 15));
			}
			
		}
	}
	/* Point drawing */	
	CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0, 1.0);
	CGContextSetLineWidth(context, 0.5);
	
	for (int i=0; i<3; i++) {
		array = [touchesArray objectAtIndex:i];
		if (array.count > 0){
			CGPoint pt;
			NSValue *val;
			for (int i = 0; i < array.count; i++){
				val = [array objectAtIndex:(NSUInteger)i];
				pt = [val CGPointValue];
				
				CGContextFillEllipseInRect(context, CGRectMake(pt.x, pt.y, 5, 5));
			}
		}
	}
	CGContextStrokePath(context);
	
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
	
	
	
	
	
	
	
	
	
	
	
	[self setNeedsDisplay];
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
	
	
	
	
	
	
	[self setNeedsDisplay];
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
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 array
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
				
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
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 array
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
				
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
				/* FUNCTION CALL GOES HERE
				 * Data is in packed1 array
				 * [0] (CGPoint)	endPoint
				 * [1] (float)		scale
				 * [2] (float)		angle
				 * [3] (float)		gradient angle
				 */
				
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
	
	if (endCount == numTouches && endCount!=0) {
		numTouches = 0;
		endCount = 0;
		touch1 = nil;
		touch2 = nil;
		touch3 = nil;
		NSLog(@"Removing last ones   %d", endCount);
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
