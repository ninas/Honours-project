//
//  testingView.h
//  testing
//
//  Created by Nina Schiff on 2010/07/05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feature.h"

@interface testingView : UIView {
	/*** For drawing ***/
	// Holds all points recieved
	NSMutableArray *touchesArray;
	// Holds features
	NSMutableArray * directionArray;
	
	/*** Feature extraction ***/
	// Previous point in order to determine distance
	CGPoint previous;
	// Previous point in regression line	
	CGPoint startPos; 
	
	// Holds length of current feature
	float distance;
	
	// Array of all gestures
	//	Each element is a feature object which contains a pointer to the next feature and so on
	NSMutableArray * gestureList;
		
	// Whether or not to clear save file
	BOOL clear;
	
	// Holds the data from the averaged gestures	
	NSMutableArray * averaged;
	
	// Holds which of the various averaged gestures should be displayed
	int averagePos;
	
	UILabel *label;
	UIButton * showDiscon;
	NSMutableArray * buttons;
	BOOL disconnect;
	
	float currentAngle;
	float xSum;
	float ySum;
	int xDir, yDir;
		
	int gradientCounter;
	feature * curFeature;
	
	
}

- (void) recognitionDirection:(CGPoint)point;


- (void) removeGesture;
- (void) averageFeatures;
- (void) writeToFile;
- (void) createDisplayButtons;

@property (nonatomic, retain) NSMutableArray *touchesArray;
@end
