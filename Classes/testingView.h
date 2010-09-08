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
	// Holds points partitioned by feature
	NSMutableArray * currentFeature;
	// Holds offset values (from origin) for each feature
	NSMutableArray * offsetVals;
	// Holds a,b,c values for each feature
	NSMutableArray * lineValues;
	
	/*** Feature extraction ***/
	// Contains current offset
	CGPoint start;
	// Previous point in order to determine distance
	CGPoint previous;
	// Previous point in regression line	
	CGPoint startPos; 
	
	// Values used in regression calculation
	float xy,n,x,y,x2,x3,x4,x2y,cumulError,a,b,c,xy2,y2,y3,xc,yc,radius;
	// Calculated y values
	float startY,endY;
	// Size of rolling error window
	int rolErrSize;
	// Array of y values to calculated rolling error
	float * rollingError;
	// Index in rollingError
	int rollPlace;
	
	// Holds length of current feature
	float distance;
	
	// Array of all gestures
	//	Each element is a feature object which contains a pointer to the next feature and so on
	NSMutableArray * gestureList;
	// Previous feature in current gesture or nil if no previous
	feature * previousFeature;
	
	// Whether or not to clear save file
	BOOL clear;
	
	BOOL drawAverage;
	NSMutableArray * buttons;
	NSMutableArray * averaged;
	int averagePos;
	UILabel *label;
	UIButton * showDiscon;
	BOOL disconnect;
	
	float currentAngle;
	float xSum;
	float ySum;
	int xDir, yDir;
	
	NSMutableArray * directionArray;
	NSMutableArray * gradients;
	int gradientCounter;
	
}
- (void) recognition:(CGPoint)point;
- (void) recognitionDirection:(CGPoint)point;
- (void) recognitionArc:(CGPoint)point;
- (void) addFeature:(CGPoint)point;
- (void) removeGesture;
- (void) averageFeatures;
- (void) writeToFile;
- (void) createDisplayButtons;
@property (nonatomic, retain) NSMutableArray *touchesArray;
@end
