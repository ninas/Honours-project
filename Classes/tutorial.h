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
	int gesCounter;
	int currentGesture;
}
- (BOOL) incrementGes:(int)type;

@end
