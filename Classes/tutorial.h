//
//  tutorial.h
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface tutorial : UIView {

	UILabel * counter;
	
	UILabel * instructions;
	int gesCounter;
	int currentGesture;
	NSMutableArray * text;
	CGRect fullScreen;
	UIButton * first;
	UIButton * second;
	int version;
	BOOL wasTraining;
	UITextView * description;
	int gameCounter;
}
- (BOOL) incrementGes:(int)type;
- (void) showFirstScreen:(int)vers;
- (void) showSecondScreen;

@property UIButton * second;
@end
