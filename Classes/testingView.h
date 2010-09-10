//
//  testingView.h
//  testing
//
//  Created by Nina Schiff on 2010/07/05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recognition.h"

@interface testingView : UIView {
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
	
	
	
	
}




@property (nonatomic, retain) NSMutableArray *touchesArray;
@end
