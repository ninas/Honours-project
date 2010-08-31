//
//  ES1Renderer.m
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ES1Renderer.h"

@implementation ES1Renderer

/*@synthesize rotationAngleX;
@synthesize rotationAngleY;
@synthesize distX;
@synthesize distY;
@synthesize moveAmountX;*/
// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }
		currentCalculatedMatrix = CATransform3DIdentity;
		//currentCalculatedMatrix = CATransform3DMakeTranslation(-1.0f, -3.0f, -1.0f);
		/*rotationAngleX = 0.0f;
		rotationAngleY = 0.0f;
		distX = 0.0f;
		distY=0.0f;
		rotateX=FALSE;
		rotateY=FALSE;
		rotateA=FALSE;*/
		
        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		glEnable(GL_CULL_FACE);
    }

    return self;
}
- (void)renderByRotatingAroundX:(float)xRotation rotatingAroundY:(float)yRotation
{
	static const GLfloat cubeVertices[] = {
		-1.0, -1.0,  1.0,
		1.0, -1.0,  1.0,
		-1.0,  1.0,  1.0,
		1.0,  1.0,  1.0,
		-1.0, -1.0, -1.0,
		1.0, -1.0, -1.0,
		-1.0,  1.0, -1.0,
		1.0,  1.0, -1.0,
	};
	

	
	static const GLushort cubeIndices[] = {
		0, 1, 2, 3, 7, 1, 5, 4, 7, 6, 2, 4, 0, 1
	};
	

    static const GLubyte cubeColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255
    };
	
	static const GLfloat cubePosition [] = {
		-2.0, 0.0, 0.0,
		-2.0, -2.0, 0.0,
		0.0, 0.0, 0.0,
		2.0, 0.0, 0.0,
		0.0, -2.0, 0.0,
		2.0, -2.0, 0.0,
		-2.0, 2.0, 0.0,
		0.0, 2.0, 0.0,
		2.0, 2.0, 0.0
		
	};

	
    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
	
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
	
    glMatrixMode(GL_PROJECTION);
	
	float xTemp=0.0, yTemp=0.0;
	float xRot = xRotation/100.0, yRot=yRotation/100.0;
	for (int i=0; i<140; i++){
		if (i==80){
			xRot/=3;
			yRot/=3;
		}
		glLoadIdentity();
		glOrthof(-2.0, 2.0, -2.0 * 480.0 / 320.0, 2.0 * 480.0 / 320.0, -3.0, 3.0);
		//xTemp+=xRot;
		//yTemp+=yRot;
		
		glMatrixMode(GL_MODELVIEW);
		// Perform incremental rotation based on current angles in X and Y	
		
		GLfloat totalRotation = sqrt(xRot*xRot + yRot*yRot);
		//NSLog(@"x: %f   TempX: %f  y:  %f   tempY: %f", xRotation, xTemp, yRotation, yTemp);
		CATransform3D temporaryMatrix = CATransform3DRotate(currentCalculatedMatrix, totalRotation * M_PI / 180.0, 
															((xRot/totalRotation) * currentCalculatedMatrix.m12 + (yRot/totalRotation) * currentCalculatedMatrix.m11),
															((xRot/totalRotation) * currentCalculatedMatrix.m22 + (yRot/totalRotation) * currentCalculatedMatrix.m21),
															((xRot/totalRotation) * currentCalculatedMatrix.m32 + (yRot/totalRotation) * currentCalculatedMatrix.m31));
		if ((temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
			currentCalculatedMatrix = temporaryMatrix;	
		
		GLfloat currentModelViewMatrix[16];
		[self convert3DTransform:&currentCalculatedMatrix toMatrix:currentModelViewMatrix];
		
		glLoadMatrixf(currentModelViewMatrix);
		
		//[self configureLighting];
		
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);
		
		glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColors);
		glEnableClientState(GL_COLOR_ARRAY);
		
		
		
		//	glDrawElements(GL_LINE_STRIP, 14, GL_UNSIGNED_SHORT, cubeIndices);
		//glDrawElements(GL_TRIANGLE_STRIP, 14, GL_UNSIGNED_SHORT, cubeIndices);
		/*float currentX=0.0, currentY=0.0, currentZ=0.0;
		for (int j = 0; j < 1; j++)
		{
			glLoadIdentity();
			glTranslatef(cubePosition[j*3]-currentX,cubePosition[j*3+1]-currentY,0 );
			currentX=cubePosition[j*3];
			currentY=cubePosition[j*3+1];
			//glTranslatef(0.0, 0.0, 0.0);
			//NSLog(@"Position: %f", -1.0f*i);*/
			
			glDrawElements(GL_TRIANGLE_STRIP, 14, GL_UNSIGNED_SHORT, cubeIndices);
		
		//}
		//	glDrawElements(GL_LINE_STRIP, 14, GL_UNSIGNED_SHORT, cubeIndices);
		
	/*	GLenum err = glGetError();
	 if (err != GL_NO_ERROR)
	 NSLog(@"Error in frame. glError: 0x%04X", err);*/
	
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
		
		NSLog(@"xTemp: %f   xRotation: %f   yTemp: %f yRotation: %f", xTemp, xRotation, yTemp, yRotation);
		if (xRot==0.0 && yRot==0.0){
			break;
		}
	}
	//while (xTemp<xRotation || yTemp<yRotation);

}

/*- (void)render
{
    // Replace the implementation of this method to do your own custom drawing

    static const GLfloat squareVertices[] = {
        // FRONT
        -0.5f, -0.5f,  0.5f,
        0.5f, -0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        // BACK
        -0.5f, -0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        // LEFT
        -0.5f, -0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        // RIGHT
        0.5f, -0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        // TOP
        -0.5f,  0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        // BOTTOM
        -0.5f, -0.5f,  0.5f,
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f, -0.5f, -0.5f,
        
        
    };
    
	
    

    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

	
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-1, 1, -1, 1, -5, 5);
	//glFrustumf(-1, 1, -1, 1, 5, 10);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
    //glTranslatef(0,0,-7);
    static float positionX = 0.0f;
	static float positionY = 0.0f;
	static float positionA = 0.0f;
	static float oldX=0.0f;
	static float oldY=0.0f;
	/*if (rotateA){
		if (rotationAngleX<0){
			if (moveAmountA>rotationAngleX){
				moveAmountA-=0.5f;
				
			}
			else {
				positionA+=moveAmountA;
				moveAmountA=0.0f;
				rotateA=FALSE;
			}
			
			
		}
		else{
			if (moveAmountA<rotationAngleX){
				moveAmountA+=0.5f;
			}
			else {
				positionA+=moveAmountA;
				moveAmountA=0.0f;
				rotateA=FALSE;
				
			}
		}
	}
	else{
		positionX = distX;
		positionY=distY;
	}
	
	
	if (rotateX){
		
		
	if (distX<0 ){
		if (moveAmountX>distX){
			moveAmountX+=distX/100.0f;
			
		}
		else {
			positionX+=distX;
			moveAmountX=0.0f;
			rotateX=FALSE;
		}

		
	}
	else{
		if (moveAmountX<distX){
			moveAmountX+=distX/100.0f;
		}
		else {
			positionX+=distX;
			moveAmountX=0.0f;
			rotateX=FALSE;
			
		}
	}
		//positionX +=distX;
		//rotateX=FALSE;
	}
	else{
		oldX=distX;
	}
	NSLog(@"Y values:   distY:%f  distX:%f  positionY:%f    positionX:%f   moveX:%f",distY/100.0f,distX/100.0f,distY, distX,moveAmountX);
	if (rotateY){
		if (distY<0){
			if (moveAmountY>distY){
				moveAmountY+=distY/100.0f;
				
			}
			else {
				positionY+=distY;
				moveAmountY=0.0f;
				rotateY=FALSE;
			}
			
			
		}
		else{
			if (moveAmountY<distY){
				moveAmountY+=distY/100.0f;
			}
			else {
				positionY+=distY;
				moveAmountY=0.0f;
				rotateY=FALSE;
				
			}
		}
		//positionY+=distY;
		//rotateY=FALSE;
	}
	else{
		oldY=distY;
	}
	
	glRotatef(positionY+moveAmountY, 1,0, 0);
	glRotatef(positionX+moveAmountX, 0,1, 0);
	
	/*if (rotateA){
    
	}
	//glTranslatef(positionX/320.0f, positionY/480.0f, 0);
	
    

    glVertexPointer(3, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    /*glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);

    glDrawArrays(GL_TRIANGLES, 0, 4);
	
	glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    
    glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
    glDrawArrays(GL_TRIANGLE_STRIP, 8, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 12, 4);
    
    glColor4f(0.0f, 0.0f, 1.0f, 1.0f);
    glDrawArrays(GL_TRIANGLE_STRIP, 16, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 20, 4);
    
    glFlush ();
    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}*/

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

/*- (void) setVals:(float)rotX andRot:(float)rotY andDist:(float)x andDist2:(float)y{
	self.rotationAngleX=rotX;
	self.rotationAngleY = rotY;
	self.distX=x;
	self.distY=y;
	moveAmountX=0.0f;
	moveAmountY = 0.0f;
	moveAmountA=0.0f;
	rotateA=TRUE;
	rotateX=TRUE;
	rotateY=TRUE;
	NSLog(@"new values set");
}*/
- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

- (void)convert3DTransform:(CATransform3D *)transform3D toMatrix:(GLfloat *)matrix;
{
	//	struct CATransform3D
	//	{
	//		CGFloat m11, m12, m13, m14;
	//		CGFloat m21, m22, m23, m24;
	//		CGFloat m31, m32, m33, m34;
	//		CGFloat m41, m42, m43, m44;
	//	};
	
	matrix[0] = (GLfloat)transform3D->m11;
	matrix[1] = (GLfloat)transform3D->m12;
	matrix[2] = (GLfloat)transform3D->m13;
	matrix[3] = (GLfloat)transform3D->m14;
	matrix[4] = (GLfloat)transform3D->m21;
	matrix[5] = (GLfloat)transform3D->m22;
	matrix[6] = (GLfloat)transform3D->m23;
	matrix[7] = (GLfloat)transform3D->m24;
	matrix[8] = (GLfloat)transform3D->m31;
	matrix[9] = (GLfloat)transform3D->m32;
	matrix[10] = (GLfloat)transform3D->m33;
	matrix[11] = (GLfloat)transform3D->m34;
	matrix[12] = (GLfloat)transform3D->m41;
	matrix[13] = (GLfloat)transform3D->m42;
	matrix[14] = (GLfloat)transform3D->m43;
	matrix[15] = (GLfloat)transform3D->m44;
}
@end