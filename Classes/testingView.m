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
		currentFeature = [[NSMutableArray alloc]init];
		lineValues = [[NSMutableArray alloc]init];
		offsetVals = [[NSMutableArray alloc] init];
		buttons = [[NSMutableArray alloc] init];
		averaged = [[NSMutableArray alloc] init];
		
		distance = 0.0;
		x=0.0f;
		y=0.0f;
		xy=0.0f;
		x2=0.0f;
		x3=0.0f;
		x4=0.0f;
		n=0.0f;
		x2y=0.0f;
		y2=0.0;
		y3=0.0;
		xy2=0.0;
		cumulError=0.0f;
		a=0.0f;
		b=0.0f;
		c=0.0f;
		startY=0.0f;
		endY=0.0f;
		rolErrSize = 0;
		rollPlace=0;
		rollingError = malloc(5*sizeof(float));
		
		gestureList = [[NSMutableArray alloc] init];
		directionArray = [[NSMutableArray alloc] init];
		previousFeature = nil;
		gradients = [[NSMutableArray alloc] init];
		gradientCounter = 0;
		
		clear = NO;
		drawAverage = NO;
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
			CGPoint offset = [[offsetVals objectAtIndex:0] CGPointValue];
			CGPoint val = [[directionArray objectAtIndex:0] CGPointValue];
			CGContextMoveToPoint(context, val.x, val.y);
			
			val = [[directionArray objectAtIndex:1] CGPointValue];
			
			CGContextAddLineToPoint(context, val.x , val.y);
			
			for (int i=1; i<directionArray.count/2; i++) {
				//offset = [[offsetVals objectAtIndex:i] CGPointValue];
				val = [[directionArray objectAtIndex:i*2] CGPointValue];
				CGContextAddLineToPoint(context, val.x , val.y);
				
				val = [[directionArray objectAtIndex:i*2+1] CGPointValue];
				//CGContextFillEllipseInRect(context, CGRectMake(val.x+offset.x, val.y+offset.y, 15, 15));
				CGContextAddLineToPoint(context, val.x , val.y);
				
				
				
				
				
			}
			CGContextSetLineWidth(context, 4.0); 
			CGContextStrokePath(context);
			NSLog(@"Number in draw array: %d",directionArray.count);
			
			for (int i=0; i<directionArray.count; i++) {
				//offset = [[offsetVals objectAtIndex:i] CGPointValue];
				val = [[directionArray objectAtIndex:i] CGPointValue];

				CGContextFillEllipseInRect(context, CGRectMake(val.x, val.y, 15, 15));
			}
			
		}
		/*int counter = 0;
		if (currentFeature.count > 1){
			
			for (int i=0; i<currentFeature.count-1; i++){
				
				NSMutableArray * temp = [currentFeature objectAtIndex:(NSUInteger)i];
				float tempA, tempB, tempC;
				//NSLog(@"Loop: %d",i);
				//NSLog(@"currentFeature: %d",currentFeature.count);
				//NSLog(@"lineValue: %d",lineValues.count);
				tempA = [[lineValues objectAtIndex:(NSUInteger)counter*3] floatValue];
				tempB = [[lineValues objectAtIndex:(NSUInteger)counter*3+1] floatValue];
				tempC = [[lineValues objectAtIndex:(NSUInteger)counter*3+2] floatValue];
				
				CGPoint offset = [[offsetVals objectAtIndex:i] CGPointValue];
				int place =0;
				float newY = -1;
				float val;
				while (newY < 0) {
					val = ([[temp objectAtIndex:(NSUInteger)place] CGPointValue]).x ;
					newY = tempC*tempC - (val - tempA)*(val - tempA);
					place++;
				}
				
				if (newY >= 0){
					NSLog(@"In");
					float multiplier = 1;
					if (([[temp objectAtIndex:(NSUInteger)0] CGPointValue]).y < tempB){
						
						multiplier=-1;
					}
					
					newY = multiplier*sqrtf(newY) + tempB;
					CGContextMoveToPoint(context, val+ offset.x, newY+offset.y);
					
					for(int j=place; j<temp.count; j++){
						val = ([[temp objectAtIndex:(NSUInteger)j] CGPointValue]).x ;
						newY = tempC*tempC - (val - tempA)*(val - tempA);
						if (newY < 0){
							NSLog(@"Returning");
							continue;
						}
						float multiplier = 1;
						if (([[temp objectAtIndex:(NSUInteger)j] CGPointValue]).y < tempB){
							
							multiplier=-1;
						}
						
						newY = multiplier*sqrtf(newY) + tempB;
						
						CGContextAddLineToPoint(context, val + offset.x, newY+offset.y);
						
					}
					counter++;
					
					CGContextSetLineWidth(context, 4.0); 
					
					CGContextStrokePath(context);
					for(int j=place; j<temp.count; j++){
						val = ([[temp objectAtIndex:(NSUInteger)j] CGPointValue]).x ;
						newY = tempC*tempC - (val - tempA)*(val - tempA);
						if (newY < 0){
							NSLog(@"Returning");
							continue;
						}
						float multiplier = 1;
						if (([[temp objectAtIndex:(NSUInteger)j] CGPointValue]).y < tempB){
							
							multiplier=-1;
						}
						
						newY = multiplier*sqrtf(newY) + tempB;
						
						
						CGContextFillEllipseInRect(context, CGRectMake(val + offset.x, newY+offset.y, 15, 15));
					}
				}
				else{
					NSLog(@"Ooops");
				}
			}
		}*/
		
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
		NSMutableArray * data = [averaged objectAtIndex:averagePos];
		CGPoint offset = CGPointMake(200, 400);
		float extra = 0.0;
		if (disconnect){
			extra = 10;
		}
		for (int i=0; i<data.count-1; i++) {
			NSLog(@"Offset values: %f %f", offset.x, offset.y);
			
			float count = 0;
			NSArray * values = [[data objectAtIndex:i] getValues];
			float tempA = [[values objectAtIndex:0] floatValue];
			float tempB = [[values objectAtIndex:1] floatValue];
			float tempC = [[values objectAtIndex:2] floatValue];
			CGPoint tempEnd = [[values objectAtIndex:4] CGPointValue];
			NSLog(@"\tEnd pos: %f %f", tempEnd.x, tempEnd.y);
			NSLog(@"\ta: %f  b:%f   c:%f",tempA, tempB, tempC);
			CGContextMoveToPoint(context, offset.x, offset.y);
			float newY;
			float increment;
			if (tempEnd.x < 0.0){
				increment = -1;
				NSLog(@"\tDecrementing");
				while (count >= tempEnd.x){
					newY = tempC*count*count + tempB*count + tempA;
					
					CGContextAddLineToPoint(context, count+offset.x , newY+offset.y);
					//NSLog(@"X: %f Y:%f",count+offset.x, newY+offset.y);
					count+=increment;
					//NSLog(@"Count: %f  increment:%f",count, increment);
				}
			}
			else{
				increment = 1;
				while (count <= tempEnd.x){
					newY = tempC*count*count + tempB*count + tempA;
					
					CGContextAddLineToPoint(context, count+offset.x , newY+offset.y);
					//NSLog(@"X: %f Y:%f",count+offset.x, newY+offset.y);
					count+=increment;
					//NSLog(@"Count: %f  increment:%f",count, increment);
				}
			}
			
			
			NSLog(@"\tCount: %f   newY:%f", count,newY);
			offset.x += count+extra;
			offset.y += newY+extra;
			
			
			CGContextSetLineWidth(context, 4.0); 
			
			CGContextStrokePath(context);
			
		}
		
	}
	
}

/* Performs feature extraction */
- (void) recognition:(CGPoint)point{
	// Offset to origin
	point.x -=start.x;
	point.y -=start.y;
	
	// Regression values
	xy+=point.x*point.y;
	n+=1.0;
	x+=point.x;
	y+=point.y;
	x2+=point.x*point.x;
	x3+=point.x*point.x*point.x;
	x2y+=point.x*point.x*point.y;
	x4+=point.x*point.x*point.x*point.x;
	
	float j=x2*n - x*x;
	float k = x3*n - x*x2;
	
	// Calculate equation of line
	float bottom = (x4*n-x2*x2)*j - k*k;
	if (bottom == 0.0){
		bottom = FLT_MIN;
		NSLog(@"Zero c");
		
	}
	
	c = (x2y*n*j - y*x2*j - n*xy*k + y*x*k)/bottom;
	
	bottom = j;
	if (bottom == 0.0){
		bottom = FLT_MIN;
		NSLog(@"Zero b");
		
	}
	
	b = (n*xy - y*x - c*k)/bottom;
	
	bottom = n;
	if (bottom == 0.0){
		bottom = FLT_MIN;
		NSLog(@"Zero a");
		
	}
	
	
	NSLog(@"Vals: c - %f   b- %f   a - %f",c,b,a);
	a = (y - b*x - c*x2)/bottom;
	
	// Predicted y values
	startY = c*startPos.x*startPos.x + b*startPos.x + a;
	endY = c*point.x*point.x + b*point.x + a;
	
	// Distance between current point and previous added to distance of rest of feature	
	distance+=sqrtf((point.x-previous.x)*(point.x-previous.x) + (endY-previous.y)*(endY-previous.y));
	previous = point;
	
	/* Error checking */
	cumulError += point.y-endY;
	if (rollPlace >= 5){
		rollPlace=0;
	}
	
	if (rolErrSize<5){ 
		rolErrSize++;
	}
	
	if (rolErrSize == 5){
		cumulError-=rollingError[rollPlace];
	}
	rollingError[rollPlace] = point.y-endY;	
	rollPlace++;
	
	// To draw feature
	[[currentFeature objectAtIndex:(NSUInteger)(currentFeature.count-1)] addObject: [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
	
	/* If error too large, end feature and create next feature */
	if (fabs(cumulError/(float)rolErrSize) > 5.0){
		
		// If length of current feature is not too small
		if (distance > 100.0){
			// Add as gesture feature
			[self addFeature:point];
			
			
			// For drawing
			[lineValues addObject:[NSNumber numberWithFloat:a]];
			[lineValues addObject:[NSNumber numberWithFloat:b]];
			[lineValues addObject:[NSNumber numberWithFloat:c]];
			
			// Unoffset points
			start.x += point.x;
			start.y += point.y;
			[offsetVals addObject:[NSValue valueWithCGPoint:CGPointMake(start.x, start.y)]];
			[currentFeature addObject: [[[NSMutableArray alloc]init] autorelease]];
			
			
			// CURVATURE
			//float curvature = fabs(2*a) / powf((powf(2*a*point.x/2 + b, 2) + 1), 1.5);
			//NSLog(@"Curvature: %f", curvature);
		}
		else {
			[[currentFeature lastObject] removeAllObjects];
		}
		
		/* Reset values for new feature */
		point.x = 0;
		point.y = 0;
		
		
		startPos.x = point.x;
		startPos.y= point.y;
		[[currentFeature objectAtIndex:(NSUInteger)(currentFeature.count-1)] addObject: [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
		
		xy=point.x*point.y;
		n=1.0;
		x=point.x;
		y=point.y;
		x2=point.x*point.x;
		x3=x2*x;
		x2y=x2*y;
		x4=x3*x;
		cumulError=0.0;
		distance = 0.0;
		rolErrSize = 0;
		
	}			
	
}

- (void) recognitionArc:(CGPoint)point{
	// Offset to origin
	point.x -=start.x;
	point.y -=start.y;
	
	
	xy+=point.x*point.y;
	n+=1.0;
	x+=point.x;
	y+=point.y;
	x2+=point.x*point.x;
	x3+=point.x*point.x*point.x;
	x2y+=point.x*point.x*point.y;
	x4+=point.x*point.x*point.x*point.x;
	y2 += point.y*point.y;
	y3 += point.y*point.y*point.y;
	xy2 += point.x*point.y*point.y;
	
	float xBar = x/(float)n;
	float yBar = y/(float)n;
	
	float Suu = x2 - 2*x*xBar + xBar*xBar*n;
	float Svv = y2 - 2*y*yBar + yBar*yBar*n;
	float Suv = xy - x*yBar - y*xBar +n*xBar*yBar;
	
	
	float Suuu = x3 - 3*x2*xBar + 3*x*xBar*xBar - xBar*xBar*xBar*n;
	float Svvv = y3 - 3*y2*yBar + 3*y*yBar*yBar - yBar*yBar*yBar*n;
	float Suvv = xy2 - 2*xy*yBar + x*yBar*yBar - xBar*y2 + 2*yBar*y*xBar - xBar*yBar*yBar*n;
	float Svuu = x2y - 2*xy*xBar + y*xBar*xBar - x2*yBar + 2*yBar*x*xBar - yBar*xBar*xBar*n;
	
	
	
	float bottom = 2.0*(Svv*Suu - Suv*Suv);
	if (2.0*(Svv*Suu - Suv*Suv) == 0){
		bottom = FLT_MIN;
	}
	float vc = (Svvv*Suu + Svuu*Suu - Suv*Suuu - Suv*Suvv)/bottom;
	
	bottom = (2.0*Suu);
	if (bottom == 0){
		bottom = FLT_MIN;
	}
	float uc = (Suuu + Suvv - 2*vc*Suv)/bottom;
	
	
	float rad = uc*uc + vc*vc + (Suu+Svv)/n;
	radius = sqrtf(rad);
	xc = uc + xBar;
	yc = vc + yBar;
	
	
	
	endY = rad - (point.x - xc)*(point.x - xc);
	
	
	
	
	if (endY < 0){
		//NSLog(@"Returning");
		return;
	}
	float multiplier = 1;
	if (point.y < yc){
		
		multiplier=-1;
	}
	
	endY = multiplier*sqrtf(endY) + yc;
	
	
	
	distance+=sqrtf((point.x-previous.x)*(point.x-previous.x) + (endY-previous.y)*(endY-previous.y));
	previous = point;
	
	cumulError += point.y-endY;
	if (rollPlace >= 5){
		rollPlace=0;
	}
	
	if (rolErrSize<5){ 
		rolErrSize++;
	}
	
	if (rolErrSize == 5){
		cumulError-=rollingError[rollPlace];
	}
	rollingError[rollPlace] = point.y-endY;	
	rollPlace++;
	
	// To draw feature
	[[currentFeature objectAtIndex:(NSUInteger)(currentFeature.count-1)] addObject: [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
	//NSLog(@"Error: %f",fabs(cumulError/(float)rolErrSize));
	/* If error too large, end feature and create next feature */
	if (fabs(cumulError/(float)rolErrSize) > 15.0){
		NSLog(@"New feature");
		// If length of current feature is not too small
		if (distance > 200.0){
			// Add as gesture feature
			[self addFeature:point];
			
			
			// For drawing
			[lineValues addObject:[NSNumber numberWithFloat:xc]];
			[lineValues addObject:[NSNumber numberWithFloat:yc]];
			[lineValues addObject:[NSNumber numberWithFloat:radius]];
			
			// Unoffset points
			start.x += point.x;
			start.y += point.y;
			[offsetVals addObject:[NSValue valueWithCGPoint:CGPointMake(start.x, start.y)]];
			[currentFeature addObject: [[[NSMutableArray alloc]init] autorelease]];
			
			
			// CURVATURE
			//float curvature = fabs(2*a) / powf((powf(2*a*point.x/2 + b, 2) + 1), 1.5);
			//NSLog(@"Curvature: %f", curvature);
			
			/* Reset values for new feature */
			point.x = 0;
			point.y = 0;
			
			
			startPos.x = point.x;
			startPos.y= point.y;
			[[currentFeature objectAtIndex:(NSUInteger)(currentFeature.count-1)] addObject: [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
			
			xy=point.x*point.y;
			n=1.0;
			x=point.x;
			y=point.y;
			x2=point.x*point.x;
			x3=x2*x;
			x2y=x2*y;
			x4=x3*x;
			
			y2=y*y;
			y3=y2*y;
			xy2=xy*y;
			cumulError=0.0;
			distance = 0.0;
			rolErrSize = 0;
		}
		else {
			//[[currentFeature lastObject] removeAllObjects];
		}
		
		
		
	}			
	
	
	
	
	
	
	
}

- (void) recognitionDirection:(CGPoint)point{
	
	
	// Offset to origin
	//point.x -=start.x;
	//point.y -=start.y;
	if (gradientCounter == 3) {
		[gradients addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
	}
	
	float secX = previous.x - point.x;
	float secY = previous.y - point.y;
	distance+=sqrtf((point.x-previous.x)*(point.x-previous.x) + (point.y-previous.y)*(point.y-previous.y));
	int tempX = 5.0;
	int tempY = 5.0;
	n+=1;
	x+=point.x;
	x2+=point.x*point.x;
	
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
	
	NSLog(@"xDir:  %d    yDir:  %d",xDir, yDir);
	NSLog(@"secX:  %f    secY:  %f",secX, secY);
	NSLog(@"temX:  %d    temY:  %d",tempX, tempY);
	
	
	
	if (!(xDir == tempX && yDir == tempY)){
		
		
		if (distance > 100){
			NSLog(@"Distance : %f", distance);
			float chordLength = sqrt((point.x - startPos.x)*(point.x - startPos.x) + (point.y - startPos.y)*(point.y - startPos.y)) ;
			//print 'Chord length: ',chordLength, 'Arc length: ',prevDistance
			NSLog(@"Curvature: %f",sqrtf(24*(distance - chordLength)/(chordLength*chordLength*chordLength)));
			
			float tempAngle = 180 + (atan2f(point.y-startPos.y,  startPos.x - point.x))*180/3.1415926;
			NSLog(@"Temp angle: %f   prev angle: %f", tempAngle, currentAngle);
			if (fabs(currentAngle - tempAngle) > 20 && fabs(currentAngle - (tempAngle + 360)) > 20 && fabs(tempAngle - (currentAngle + 360)) > 20 ){
				//featureList.append([startPos[0], startPos[1], event.x, event.y])
				
				
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				NSLog(@"New");
				
				start.x += point.x;
				start.y += point.y;
				[offsetVals addObject:[NSValue valueWithCGPoint:CGPointMake(start.x, start.y)]];
				currentAngle = tempAngle;
				distance=0.0;
				startPos.x = point.x;
				startPos.y= point.y;
				gradientCounter = 0;
				
				NSLog(@"Number in gradients: %d", gradients.count);
			}
			else if ([directionArray count] > 1){
				[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				NSLog(@"Extended");
				CGPoint first = [[directionArray objectAtIndex:directionArray.count-2] CGPointValue];
				CGPoint second = [[directionArray lastObject] CGPointValue];
				currentAngle = 180 + (atan2f(second.y-first.y,  first.x - second.x))*180/3.1415926;
				startPos.x = point.x;
				startPos.y = point.y;
				distance = 0.0;
			}
			else{
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
				[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
				NSLog(@"New");
				start.x += point.x;
				start.y += point.y;
				[offsetVals addObject:[NSValue valueWithCGPoint:CGPointMake(start.x, start.y)]];
				currentAngle = tempAngle;
				distance=0.0;
				startPos.x = point.x;
				startPos.y= point.y;
				gradientCounter = 0;
			}
			
			
			
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



/* Adds feature to current gesture */
- (void) addFeature:(CGPoint)point{
	
	feature * newFeature = [[feature alloc] init];
	
	[newFeature setLine:xc andB:yc andC:radius];
	[newFeature setChange:CGPointMake(point.x, endY)];
	
	// If first feature of gesture
	if (previousFeature == nil) {
		[newFeature setStep:0];
		previousFeature = newFeature;
		[gestureList addObject:newFeature];
	}
	else {
		[newFeature setStep:(*previousFeature).step+1];
		[newFeature setPrevious:previousFeature];
		[previousFeature setNext:newFeature];
	}
	
	[newFeature setScaleD:distance];
	
	previousFeature = newFeature;
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
				
				// a,b,c values
				NSArray * abc = [[chunks objectAtIndex:place] componentsSeparatedByString:@" "];
				[currFeature setLine:[[abc objectAtIndex:0] floatValue] andB:[[abc objectAtIndex:1] floatValue] andC:[[abc objectAtIndex:2] floatValue]];
				place++;
				
				// scale
				[currFeature setScale:[[chunks objectAtIndex:place] floatValue]];
				place++;
				
				// End position (x,y)
				abc = [[chunks objectAtIndex:place] componentsSeparatedByString:@" "];
				[currFeature setChange:CGPointMake([[abc objectAtIndex:0] floatValue], [[abc objectAtIndex:1] floatValue])];
				place++;
				
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
		
		[data appendFormat:@"%d\n",(*current).maxNum];
		
		// Step through links to get data from all features in gesture
		while (current!=nil) {
			NSArray * array = [current getValues];								
			[data appendFormat:@"%f %f %f\n%f\n%f %f\n", [[array objectAtIndex:0] floatValue],[[array objectAtIndex:1] floatValue],[[array objectAtIndex:2] floatValue],[[array objectAtIndex:3] floatValue],[[array objectAtIndex:4] CGPointValue].x,[[array objectAtIndex:4] CGPointValue].y];			
			current = current.next;
			
		}
	}
	
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


/* Average the values of all gestures */
- (void) averageFeatures{
	[self writeToFile];
	
	NSMutableDictionary * lengthData = [NSMutableDictionary dictionary];
	feature * temp;
	
	// Group gestures by number of features
	for (int i=0; i<gestureList.count; i++) {
		temp = [gestureList objectAtIndex:i];
		NSString * key = [NSString stringWithFormat:@"%d", (*temp).maxNum];
		
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
			[currFeature setLine:0 andB:0 andC:0];
			[currFeature setStep:0];
			currFeature.scale = 0;
			[currFeature setChange:CGPointMake(0.0, 0.0)];
			
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
	if (currentFeature.count > 0){
		[currentFeature removeAllObjects];
		
	}
	if (lineValues.count > 0){
		[lineValues removeAllObjects];
		
	}
	if (offsetVals.count > 0){
		[offsetVals removeAllObjects];
		
	}
	[currentFeature addObject:[[[NSMutableArray alloc]init] autorelease]];
	
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	distance=0;
	
	start = pt;
	[offsetVals addObject:[NSValue valueWithCGPoint:CGPointMake(start.x, start.y)]];
	//pt.x=0;
	//pt.y=0;
	previous = pt;
	startPos.x = pt.x;
	startPos.y= pt.y;
	currentAngle = 0.0;
	[directionArray removeAllObjects];
	gradientCounter = 1;
	/*xy=pt.x*pt.y;
	 n=1.0;
	 x=pt.x;
	 y=pt.y;
	 x2=pt.x*pt.x;
	 x3=x2*x;
	 x2y=x2*y;
	 x4=x3*x;
	 cumulError=0.0;*/
	n=1.0;
	x=pt.x;
	y=pt.y;
	x2=pt.x*pt.x;
	x3=pt.x*pt.x*pt.x;
	y2=pt.y*pt.y;
	y3=pt.y*pt.y*pt.y;
	xy=pt.x*pt.y;
	xy2=pt.x*pt.y*pt.y;
	x2y=pt.x*pt.x*pt.y;
	
	[[currentFeature objectAtIndex:(NSUInteger)0] addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
	
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
	CGPoint offset;
	if (directionArray.count > 1){
	 offset = [[offsetVals objectAtIndex:offsetVals.count - 2] CGPointValue];
	}
	else {
		offset = start;
	}

	//pt.x = pt.x - offset.x;
	//pt.y = pt.y-offset.y;
	[touchesArray addObject: [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
	NSLog(@"End distance %f",distance);
	// End feature	
	/*if (distance > 200.0){
		NSLog(@"adding end");
		[lineValues addObject:[NSNumber numberWithFloat:xc]];
		[lineValues addObject:[NSNumber numberWithFloat:yc]];
		[lineValues addObject:[NSNumber numberWithFloat:radius]];
		
		[currentFeature addObject: [[[NSMutableArray alloc]init] autorelease]];
		[self addFeature:pt];
	}
	[previousFeature setNext:nil];
	// Set size of gesture
	if (gestureList.count > 0) {
		
		
		[[gestureList objectAtIndex:gestureList.count-1] setMaxNum:(*previousFeature).step+1];
	}
	previousFeature = nil;*/
	NSLog(@"Initial last value: (%f, %f)", ([[directionArray lastObject] CGPointValue]).x, ([[directionArray lastObject] CGPointValue]).y);
	float tempAngle = 180 + (atan2f(pt.y-startPos.y, startPos.x - pt.x))*180/3.1415926;
	NSLog(@"Temp angle: %f  prev angle: %f", tempAngle, currentAngle); 
	if (distance < 100) {
		[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		NSLog(@"replaced1");
	}
	
	else if (fabs(currentAngle - tempAngle) > 20 && fabs(currentAngle - (tempAngle + 360)) > 20 && fabs(tempAngle - (currentAngle + 360)) > 20){
		//featureList.append([startPos[0], startPos[1], event.x, event.y])
		
		
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		
		NSLog(@"Added1");
		
	}
	else if ([directionArray count] > 1){
		[directionArray replaceObjectAtIndex:directionArray.count-1 withObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		NSLog(@"replaced2");
		
	}
	else{
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(startPos.x, startPos.y)]];
		[directionArray addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
		NSLog(@"Added2");
		
		
	}
	NSLog(@"Final last value: (%f, %f)", ([[directionArray lastObject] CGPointValue]).x, ([[directionArray lastObject] CGPointValue]).y);
	
	if (directionArray.count/2 != gradients.count) {
		[gradients addObject:[NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)]];
	}
	
	NSLog(@"Number in gradients array: %d", gradients.count);
	NSLog(@"____________________________________________________________________________");
	
	[self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
	[touchesArray autorelease];
	free(rollingError);
	[currentFeature removeAllObjects];
	[currentFeature autorelease];
	[lineValues autorelease];
	[offsetVals autorelease];
	[gestureList removeAllObjects];
	[gestureList autorelease];
    [super dealloc];
}
@end
