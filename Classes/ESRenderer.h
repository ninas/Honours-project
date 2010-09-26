//
//  ESRenderer.h
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>
- (void)renderByRotatingAroundX:(float)xRotation rotatingAroundY:(float)yRotation;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
