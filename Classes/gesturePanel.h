//
//  gesturePanel.h
//  tester
//
//  Created by Nina Schiff on 2010/09/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface gesturePanel : UIView {
	
	
	NSMutableArray * lineButtons;
	NSMutableArray * swapButtons;
	
	NSMutableArray * descriptions;
	
	UIButton * hide;
	
	UITextView * otherControls;
	UILabel * descripLabel;
	UILabel * secLabel;
	UIImageView * imageView;
	NSMutableArray * images;
	
}

- (void) rowLeft:(id)select;
- (void) swapMen:(id)select;
- (void) setupLine;
- (void) setupSwap;
- (void) setupOther:(int)num;
- (void) fadeOut;
- (void) fadeIn;

@property (nonatomic, retain) UIButton * hide;
@end
