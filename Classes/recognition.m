//
//  recognition.m
//  testing
//
//  Created by Nina Schiff on 2010/09/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "recognition.h"


@implementation recognition
- (id)init {
    if ((self = [super init])) {
        // Initialization code
        
		distance = 0.0;
        
		gradientCounter = 0;
		cAngle = 500;
		packed = [[NSMutableArray alloc] init];
		packed2 = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}

- (void) setDirArray:(NSMutableArray*)dir{
	directionArray = dir;
}

- (NSMutableArray *) getFeature{
	return packed;
}

- (NSMutableArray *) getSecond{
	if (packed2.count == 0) {
		return nil;
	}
	return packed2;
}


/* Handles feature segmentation according to changes in direction */
- (BOOL) recognitionDirection:(CGPoint)point{
	BOOL check = NO;
    
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
					[packed removeAllObjects];
					[packed addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
					[packed addObject:[NSNumber numberWithFloat:prevScale]];
					[packed addObject:[NSNumber numberWithFloat:prevAngle]];
					[packed addObject:[NSNumber numberWithFloat:prevCAngle]];
                    
					check = YES;
                    
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
				cAngle = 500;
                
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
				cAngle = 500;
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
				cAngle = 500;
                
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
    
	return check;
    
}




- (void) reset:(CGPoint)pt {
    
    
    
	// Reset values
	if (directionArray.count > 0){
		[directionArray removeAllObjects];
	}
    
    
	distance=0;
    
	previous = pt;
	startPos.x = pt.x;
	startPos.y= pt.y;
	currentAngle = 0.0;
    
	gradientCounter = 1;
	cAngle = 500;
	startDist = -1;
	prevEnd = CGPointMake(0.0, 0.0);
    
}


- (NSMutableArray*) end:(CGPoint)pt {
    
    
    
    
	float tempAngle = 180 + (atan2f(pt.y-startPos.y, startPos.x - pt.x))*180/3.1415926;
	[packed removeAllObjects];
	[packed2 removeAllObjects];
	// does much the same stuff as in recognitionDirection
	if (directionArray.count == 0) {
        
        
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
        
            [packed addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
            [packed addObject:[NSNumber numberWithFloat:prevScale]];
            [packed addObject:[NSNumber numberWithFloat:prevAngle]];
            [packed addObject:[NSNumber numberWithFloat:prevCAngle]];
        
        
    }
    else if (fabs(currentAngle - tempAngle) > 20 && fabs(currentAngle - (tempAngle + 360)) > 20 && fabs(tempAngle - (currentAngle + 360)) > 20 ){
                    
            
            [packed addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
            [packed addObject:[NSNumber numberWithFloat:prevScale]];
            [packed addObject:[NSNumber numberWithFloat:prevAngle]];
            [packed addObject:[NSNumber numberWithFloat:prevCAngle]];
            
        
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
            
                
                [packed2 addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
                [packed2 addObject:[NSNumber numberWithFloat:prevScale]];
                [packed2 addObject:[NSNumber numberWithFloat:prevAngle]];
                [packed2 addObject:[NSNumber numberWithFloat:prevCAngle]];
            
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
        
        
            [packed addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
            [packed addObject:[NSNumber numberWithFloat:prevScale]];
            [packed addObject:[NSNumber numberWithFloat:prevAngle]];
            [packed addObject:[NSNumber numberWithFloat:prevCAngle]];
        
        
	}
	else{
        
       
            [packed addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
            [packed addObject:[NSNumber numberWithFloat:prevScale]];
            [packed addObject:[NSNumber numberWithFloat:prevAngle]];
            [packed addObject:[NSNumber numberWithFloat:prevCAngle]];
            
        
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
        
            
            
            [packed2 addObject:[NSValue valueWithCGPoint:CGPointMake(prevEnd.x, prevEnd.y)]];
            [packed2 addObject:[NSNumber numberWithFloat:prevScale]];
            [packed2 addObject:[NSNumber numberWithFloat:prevAngle]];
            [packed2 addObject:[NSNumber numberWithFloat:prevCAngle]];
        
	}
    
	return packed;
    
}




- (void)dealloc {
    
	[directionArray autorelease];
	[packed autorelease];
    
    [super dealloc];
}

@end