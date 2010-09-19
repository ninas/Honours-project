//
//  ES1Renderer.h
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "ESRenderer.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "block.h"

@interface ES1Renderer : NSObject 
{
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;
	
	CATransform3D currentCalculatedMatrix;
	CATransform3D beginCalculatedMatrix;
	NSMutableArray * blocks;
	GLfloat xRot;
	GLfloat yRot;
	
	BOOL check;
	float blockSize;
	NSMutableArray * touchesArray;
@public
	/*float rotationAngleX;
	float rotationAngleY;
	float distX;
	float distY;
	float moveAmountX;
	float moveAmountY;
	float moveAmountA;
	BOOL rotateX;
	BOOL rotateY;
	BOOL rotateA;*/
}

/*@property float rotationAngleX;
@property float rotationAngleY;
@property float distX;
@property float distY;
@property float moveAmountX;*/

//- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
//- (void) setVals:(float)rotX andRot:(float)rotY andDist:(float)x andDist2:(float)y;
- (void)renderByRotatingAroundX:(float)xRotation rotatingAroundY:(float)yRotation;
- (void)convert3DTransform:(CATransform3D *)transform3D toMatrix:(GLfloat *)matrix;
- (void) setBlockArray:(NSMutableArray*)array;
- (void) setTouchesArray:(NSMutableArray*)touches;
@end
