//
//  ES1Renderer.m
//  tester
//
//  Created by Nina Schiff on 2010/06/14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ES1Renderer.h"

@implementation ES1Renderer
@synthesize doingRock;
@synthesize inRed;
//@synthesize counterAlpha;
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
		rotatedMatix = CATransform3DIdentity;
		check = NO;
		blockSize = 15;
		alphaVal = 255;
		counterAlpha = 300;
		doingRock = NO;
		rotMult = 1.0;
		inRed = NO;
		//changeAlpha = NO;
		/*float xRot=5;
		 float yRot = 5;
		 GLfloat totalRotation = sqrt(xRot*xRot + yRot*yRot);
		 //NSLog(@"x: %f   TempX: %f  y:  %f   tempY: %f", xRotation, xTemp, yRotation, yTemp);
		 CATransform3D temporaryMatrix = CATransform3DRotate(currentCalculatedMatrix, totalRotation * M_PI / 180.0, 
		 ((xRot/totalRotation) * currentCalculatedMatrix.m12 + (yRot/totalRotation) * currentCalculatedMatrix.m11),
		 ((xRot/totalRotation) * currentCalculatedMatrix.m22 + (yRot/totalRotation) * currentCalculatedMatrix.m21),
		 ((xRot/totalRotation) * currentCalculatedMatrix.m32 + (yRot/totalRotation) * currentCalculatedMatrix.m31));
		 if ((temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
		 rotatedMatix = temporaryMatrix;*/
		//currentCalculatedMatrix = CATransform3DMakeTranslation(-1.0f, -3.0f, -1.0f);
		/*rotationAngleX = 0.0f;
		 rotationAngleY = 0.0f;
		 distX = 0.0f;
		 distY=0.0f;
		 rotateX=FALSE;
		 rotateY=FALSE;
		 rotateA=FALSE;*/
		extraRot = YES;
        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		// Create depth buffer
		glGenRenderbuffersOES(1, &depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, 
									 GL_DEPTH_ATTACHMENT_OES, 
									 GL_RENDERBUFFER_OES, 
									 depthRenderbuffer);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
    }
	
    return self;
}
- (void) resetCounterA{
	counterAlpha = 0;
}
- (void) setBlockArray:(NSMutableArray *) array andTrans:(NSMutableSet*)trans{
	
	
	blocks = array;
	translate = trans;
	
}

- (void) resetMatrices{
	currentCalculatedMatrix = CATransform3DIdentity;
	rotatedMatix = CATransform3DIdentity;
	check = NO;
	blockSize = 15;
	alphaVal = 255;
	counterAlpha = 300;
	doingRock = NO;
	rotMult = 1.0;
	inRed = NO;
	extraRot = YES;
	rotCounter = 0;
}

- (void) setTouchesArray:(NSMutableArray*)touches{
	touchesArray = touches;
}

- (void) clearTouches{
	if ([[touchesArray objectAtIndex:0] count] > 0) {
		[[touchesArray objectAtIndex:0] removeAllObjects];
	}
	if ([[touchesArray objectAtIndex:1] count] > 0) {
		[[touchesArray objectAtIndex:1] removeAllObjects];
	}
	if ([[touchesArray objectAtIndex:2] count] > 0) {
		[[touchesArray objectAtIndex:2] removeAllObjects];
	}
	
}
/*
 * Render function
 */
- (void)renderByRotatingAroundX:(float)xRotation rotatingAroundY:(float)yRotation
{
	
	
	if (check) {
		xRot = xRotation;
		yRot = yRotation;
		check = NO;
	}	
	else if (xRot == 0 && yRot == 0 && (xRotation !=0 || yRotation != 0)) { // rotation started
		/*beginCalculatedMatrix = currentCalculatedMatrix;
		 xRot = xRotation;
		 yRot = yRotation;*/
		/*float xR=-5;
		 float yR = -5;
		 GLfloat totalRotation = sqrt(xR*xR + yR*yR);
		 //NSLog(@"x: %f   TempX: %f  y:  %f   tempY: %f", xRotation, xTemp, yRotation, yTemp);
		 CATransform3D temporaryMatrix = CATransform3DRotate(currentCalculatedMatrix, totalRotation * M_PI / 180.0, 
		 ((xR/totalRotation) * currentCalculatedMatrix.m12 + (yR/totalRotation) * currentCalculatedMatrix.m11),
		 ((xR/totalRotation) * currentCalculatedMatrix.m22 + (yR/totalRotation) * currentCalculatedMatrix.m21),
		 ((xR/totalRotation) * currentCalculatedMatrix.m32 + (yR/totalRotation) * currentCalculatedMatrix.m31));
		 if ((temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
		 currentCalculatedMatrix = temporaryMatrix;*/
		
		beginCalculatedMatrix = currentCalculatedMatrix;
		
		xRot = xRotation;
		yRot = yRotation;
		
		
		
	}
	else if ((xRot != 0 || yRot !=0 ) && xRotation ==0 && yRotation ==0){ // rotation ended
		currentCalculatedMatrix = beginCalculatedMatrix;
		
		if (doingRock) {
			doingRock = NO;
		}
		else if (xRot > 0) {
			xRot = 90;
			yRot = 0;
		}
		else if (xRot < 0){
			xRot = -90;
			yRot = 0;
		}
		else if (yRot > 0){
			yRot = 90;
			xRot = 0;
		}
		else if (yRot < 0){
			yRot = -90;
			xRot = 0;
		}
		
		check = YES;
		extraRot = YES;
		rotCounter = 0;
		rotMult = 1;
		/*float xR=5;
		 float yR = 5;
		 GLfloat totalRotation = sqrt(xR*xR + yR*yR);
		 //NSLog(@"x: %f   TempX: %f  y:  %f   tempY: %f", xRotation, xTemp, yRotation, yTemp);
		 CATransform3D temporaryMatrix = CATransform3DRotate(currentCalculatedMatrix, totalRotation * M_PI / 180.0, 
		 ((xR/totalRotation) * currentCalculatedMatrix.m12 + (yR/totalRotation) * currentCalculatedMatrix.m11),
		 ((xR/totalRotation) * currentCalculatedMatrix.m22 + (yR/totalRotation) * currentCalculatedMatrix.m21),
		 ((xR/totalRotation) * currentCalculatedMatrix.m32 + (yR/totalRotation) * currentCalculatedMatrix.m31));
		 if ((temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
		 currentCalculatedMatrix = temporaryMatrix;*/
		
	}
	else{
		
		xRot = xRotation;
		yRot = yRotation;
	}
	
	
	static const GLfloat cubeVertices[] = {
		-1.0, -1.0,  1.0,
		1.0, -1.0,  1.0,
		-1.0,  1.0,  1.0,
		1.0, 1.0, 1.0,
		
		1.0, -1.0, 1.0,
		1.0, -1.0, -1.0,
		1.0, 1.0, 1.0,
		1.0, 1.0, -1.0,
		
		1.0, -1.0, -1.0,
		-1.0,-1.0, -1.0,
		1.0, 1.0, -1.0,
		-1.0,1.0, -1.0,
		
		-1.0, -1.0, -1.0,
		-1.0, -1.0, 1.0,
		-1.0, 1.0, -1.0,
		-1.0, 1.0, 1.0,
		
		-1.0, 1.0, 1.0,
		1.0, 1.0, 1.0,
		-1.0, 1.0, -1.0,
		1.0, 1.0, -1.0,
		
		-1.0, -1.0, -1.0,
		1.0, -1.0, -1.0,
		-1.0, -1.0, 1.0,
		1.0, -1.0, 1.0
		
		/*
		 -1.0, -1.0,  1.0,
		 1.0, -1.0,  1.0,
		 -1.0,  1.0,  1.0,
		 1.0, 1.0, 1.0,
		 
		 1.0, -1.0, 1.0,
		 1.0, -1.0, -1.0,
		 1.0, 1.0, 1.0,
		 1.0, 1.0, -1.0,
		 
		 
		 1.0,  1.0,  1.0,
		 -1.0, -1.0, -1.0,
		 1.0, -1.0, -1.0,
		 -1.0,  1.0, -1.0,
		 1.0,  1.0, -1.0,*/
	};
	
	static const GLushort cubeIndices[] = {
		0,1,2,1,3,2,		4,5,6,5,7,6,		8,9,10,9,11,10,  12,13,14,13,15,14,
		16,17,18,17,19,18,	20,21,22,21,23,22	
		//		0, 1, 2, 3, 7, 1, 5, 4, 7, 6, 2, 4, 0, 1
		//0,1,2,2,1,3,1,5,7,1,7,3,5,4,7,7,4,6,6,2,4,2,4,0,3,7,2,6,2,7,1,0,5,4,5,0
	};
	
	
    static const GLubyte cubeColorsRed[] = {
        /*255, 0,   0, 255,
		 255, 0,   255, 255,
		 255, 255,   0, 255,
		 255, 0,   0, 255,
		 255, 0,   255, 255,
		 255, 255,   0, 255,
		 255, 0,   0, 255,
		 255, 0,   255, 255*/
		243, 148,148,255,
		200, 15,15,255,
		200, 15,15,255,
		200, 15,15,255,
		
		200, 15,15,255,
		200, 15,15,255,
		200, 15,15,255,
		243, 148,148,255,
		
		200, 15,15,255,
		200, 15,15,255,
		243, 148,148,255,
		200, 15,15,255,
		
		200, 15,15,255,
		243, 148,148,255,
		200, 15,15,255,
		200, 15,15,255,
		
		200, 15,15,255,
		200, 15,15,255,
		200, 15,15,255,
		243, 148,148,255,
		
		200, 15,15,255,
		200, 15,15,255,
		243, 148,148,255,
		200, 15,15,255
		
    };
	
	static const GLubyte cubeColorsGreen[] = {
        /*0, 255,   0, 255,
		 255, 255,   0, 255,
		 0, 255,   255, 255,
		 0, 255,   0, 255,
		 255, 255,   0, 255,
		 0, 255,   255, 255,
		 255, 255,   0, 255,
		 0, 255,   255, 255*/
		173,207,170,255,
		28,179,16,255,
		28,179,16,255,
		28,179,16,255,
		
		28,179,16,255,
		28,179,16,255,
		28,179,16,255,
		173,207,170,255,
		
		28,179,16,255,
		28,179,16,255,
		173,207,170,255,
		28,179,16,255,
		
		28,179,16,255,
		173,207,170,255,
		28,179,16,255,
		28,179,16,255,
		
		28,179,16,255,
		28,179,16,255,
		28,179,16,255,
		173,207,170,255,
		
		28,179,16,255,
		28,179,16,255,
		173,207,170,255,
		28,179,16,255
    };
	
	static const GLubyte cubeColorsBlue[] = {
		/* 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 255, 0,   255, 255*/
		184,181,255,255,
		67,59,232,255,
		67,59,232,255,
		67,59,232,255,
		
		67,59,232,255,
		67,59,232,255,
		67,59,232,255,
		184,181,255,255,
		
		67,59,232,255,
		67,59,232,255,
		184,181,255,255,
		67,59,232,255,
		
		67,59,232,255,
		184,181,255,255,
		67,59,232,255,
		67,59,232,255,
		
		67,59,232,255,
		67,59,232,255,
		67,59,232,255,
		184,181,255,255,
		
		67,59,232,255,
		67,59,232,255,
		184,181,255,255,
		67,59,232,255
    };
	
	static const GLubyte cubeColorsOrange[] = {
		/* 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 0, 0,   255, 255,
		 255, 0,   255, 255*/
		246,219,154,255,
		239,175,22,255,
		239,175,22,255,
		239,175,22,255,
		
		239,175,22,255,
		239,175,22,255,
		239,175,22,255,
		246,219,154,255,
		
		239,175,22,255,
		239,175,22,255,
		246,219,154,255,
		239,175,22,255,
		
		239,175,22,255,
		246,219,154,255,
		239,175,22,255,
		239,175,22,255,
		
		239,175,22,255,
		239,175,22,255,
		239,175,22,255,
		246,219,154,255,
		
		239,175,22,255,
		239,175,22,255,
		246,219,154,255,
		239,175,22,255
    };
	
	
	static const GLfloat normals [] = {
		/*-0.57735026918962573, -0.57735026918962573,0.57735026918962573,
		 0.57735026918962573, -0.57735026918962573,0.57735026918962573,
		 -0.57735026918962573, 0.57735026918962573,0.57735026918962573,
		 0.57735026918962573, 0.57735026918962573,0.57735026918962573,
		 -0.57735026918962573, -0.57735026918962573,-0.57735026918962573,
		 0.57735026918962573, -0.57735026918962573,-0.57735026918962573,
		 -0.57735026918962573, 0.57735026918962573,-0.57735026918962573,
		 0.57735026918962573, 0.57735026918962573,-0.57735026918962573*/
		.0, .0, 1.0,
		.0, .0, 1.0,
		.0, .0, 1.0,
		.0, .0, 1.0,
		
		1.0, .0, .0,
		1.0, .0, .0,
		1.0, .0, .0,
		1.0, .0, .0,
		
		.0, .0, -1.0,
		.0, .0, -1.0,
		.0, .0, -1.0,
		.0, .0, -1.0,
		
		-1.0, .0, .0,
		-1.0, .0, .0,
		-1.0, .0, .0,
		-1.0, .0, .0,
		
		.0, 1.0, .0,
		.0, 1.0, .0,
		.0, 1.0, .0,
		.0, 1.0, .0,
		
		.0, -1.0, .0,
		.0, -1.0, .0,
		.0, -1.0, .0,
		.0, -1.0, .0,
		
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
	glOrthof(-1*blockSize*backingWidth/backingHeight, blockSize*backingWidth/backingHeight, -1*blockSize , blockSize , -3.0*blockSize/2.0, 3.0*blockSize/2.0);
	
	glMatrixMode(GL_MODELVIEW);
	// Perform incremental rotation based on current angles in X and Y	
	
	
	
	
	
    // Enable lighting
    glEnable(GL_LIGHTING);
	
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const GLfloat light0Ambient[] = {0.1, 0.1, 0.1, 1.0};
	glLightfv(GL_LIGHT0, GL_AMBIENT, light0Ambient);
    
    // Define the diffuse component of the first light
    static const GLfloat light0Diffuse[] = {0.9, 0.9, 0.9, 1.0};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, light0Diffuse);
    
    // Define the specular component and shininess of the first light
    static const GLfloat light0Specular[] = {0.7, 0.7, 0.7, 1.0};
    glLightfv(GL_LIGHT0, GL_SPECULAR, light0Specular);
    
    // Define the position of the first light
	static const GLfloat direction0Position[] = {11.0, 13.0, 15.0, .0};
	glLightfv(GL_LIGHT0, GL_POSITION, direction0Position); 
	
    // Calculate light vector so it points at the object
    
    
    //glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, direction0Position);
	
    // Define a cutoff angle. This defines a 90° field of vision, since the cutoff
    // is number of degrees to each side of an imaginary line drawn from the light's
    // position along the vector supplied in GL_SPOT_DIRECTION above
	//    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 45.0);
	glEnable(GL_COLOR_MATERIAL);
	
	
	
		
		CATransform3D temporaryMatrix = currentCalculatedMatrix;
		if (xRot != 0) { // rotate around y
			
			temporaryMatrix = CATransform3DRotate(currentCalculatedMatrix, xRot * M_PI / 180.0, 
												  (currentCalculatedMatrix.m12 ),
												  ( currentCalculatedMatrix.m22),
												  (currentCalculatedMatrix.m32 ));
		}
	if ( (temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
		currentCalculatedMatrix = temporaryMatrix;	
		if (yRot!= 0){ // rotate around x
			temporaryMatrix = CATransform3DRotate(currentCalculatedMatrix, yRot * M_PI / 180.0, 
												  (currentCalculatedMatrix.m11),
												  (currentCalculatedMatrix.m21),
												  (currentCalculatedMatrix.m31));
		}
		if ( (temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
			currentCalculatedMatrix = temporaryMatrix;	
		if (xRot!=0 || yRot!=0) {
			rotatedMatix = currentCalculatedMatrix;
		}
		
		
		
		if (extraRot && !doingRock) { // rotate around y
			
			float xR=0.5*rotMult;
			float yR = 0.5*rotMult;
			GLfloat totalRotation = sqrt(xR*xR + yR*yR);
			//NSLog(@"x: %f   TempX: %f  y:  %f   tempY: %f", xRotation, xTemp, yRotation, yTemp);
			CATransform3D temporaryMatrix = CATransform3DRotate(rotatedMatix, totalRotation * M_PI / 180.0, 
																((xR/totalRotation) * rotatedMatix.m12 + (yR/totalRotation) * rotatedMatix.m11),
																((xR/totalRotation) * rotatedMatix.m22 + (yR/totalRotation) * rotatedMatix.m21),
																((xR/totalRotation) * rotatedMatix.m32 + (yR/totalRotation) * rotatedMatix.m31));
			//if ((temporaryMatrix.m11 >= -100.0) && (temporaryMatrix.m11 <= 100.0))
			rotatedMatix = temporaryMatrix;
			rotCounter++;
			if (rotCounter>=10) {
				extraRot = NO;
			}
			
		}
		GLfloat currentModelViewMatrix[16];
		
		[self convert3DTransform:&rotatedMatix toMatrix:currentModelViewMatrix];
	
	
	glClearColor(0, 0, 0, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	
	
	glNormalPointer(GL_FLOAT, 0, normals);
	glEnableClientState(GL_NORMAL_ARRAY);
    
    
	
	for (int i=0; i < blocks.count; i++) {
		
		
		glLoadIdentity();
		glLoadMatrixf(currentModelViewMatrix);
		//glRotatef(5, 1, 0, 0);
		block * temp = [blocks objectAtIndex:i];
		glTranslatef(temp.x*2, temp.y*2, temp.z*2 );
		
		if (temp.colour == 0) {
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsRed);
			glEnableClientState(GL_COLOR_ARRAY);
		}
		else if (temp.colour == 1) {
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsGreen);
			glEnableClientState(GL_COLOR_ARRAY);
		}
		else if (temp.colour == 2){
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsBlue);
			glEnableClientState(GL_COLOR_ARRAY);
			
		}
		else {
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsOrange);
			glEnableClientState(GL_COLOR_ARRAY);
			
		}
		//glDrawElements(GL_TRIANGLE_STRIP, 14, GL_UNSIGNED_SHORT, cubeIndices);
		glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_SHORT, cubeIndices);
		
	}
	int counter = 0;
	//NSLog(@"Length of translate     %d     vs.    %d", translate.count, blocks.count);
	NSArray * data = [translate allObjects];
	while (counter < data.count) {
				
		
		glLoadIdentity();
		glLoadMatrixf(currentModelViewMatrix);
		//glRotatef(5, 1, 0, 0);
		block * temp = [data objectAtIndex:counter];
		BOOL ans = [temp updatePos];
		if (ans) {
			glTranslatef(temp.x*2, temp.y*2, temp.z*2 );
			[translate removeObject:temp];
			
			[blocks addObject:temp];
		}
		else {
			//NSLog(@"Is translating");
			glTranslatef(temp.newX*2, temp.newY*2, temp.newZ*2 );
		}

		
		
		if (temp.colour == 0) {
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsRed);
			glEnableClientState(GL_COLOR_ARRAY);
		}
		else if (temp.colour == 1) {
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsGreen);
			glEnableClientState(GL_COLOR_ARRAY);
		}
		else if (temp.colour == 2){
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsBlue);
			glEnableClientState(GL_COLOR_ARRAY);
			
		}
		else {
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColorsOrange);
			glEnableClientState(GL_COLOR_ARRAY);
			
		}
		//glDrawElements(GL_TRIANGLE_STRIP, 14, GL_UNSIGNED_SHORT, cubeIndices);
		glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_SHORT, cubeIndices);
		counter++;
	}
	
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_NORMAL_ARRAY);
	
	NSMutableArray * drawingArray;
	/*draw user interactions */
    for (int i = 0; i < 3 ; i++){
        
        drawingArray = [touchesArray objectAtIndex:i];
        
        if ([drawingArray count] > 0){
			//NSLog(@"In     %d", drawingArray.count);
			for (int i = 0; i < drawingArray.count; i++){
                float interactionPoints[[drawingArray count]*2];
                GLubyte interactionColors[[drawingArray count]*4];
                for (int i = 0; i < [drawingArray count]; i++){
                    CGPoint pt = [[drawingArray objectAtIndex:(NSUInteger)i] CGPointValue];
					
					
					
					interactionPoints[i*2] = (pt.x - 512)/512*15*1024/768;
					interactionPoints[i * 2 +1] = (pt.y- 384)/384*-15;
					
                    if (!inRed) {
						interactionColors[i*4]      = 255;
						interactionColors[i*4 + 1]  = 255;
						interactionColors[i*4 + 2]  = 255;
						
						
						interactionColors[i*4 + 3]  = 255;
					}
					else {
						interactionColors[i*4]      = 255;
						interactionColors[i*4 + 1]  = 0;
						interactionColors[i*4 + 2]  = 0;
						
						
						interactionColors[i*4 + 3]  = 255;
					}

                    
                }
                glLoadIdentity();
                glTranslatef(0, 0,16);
				
                glLineWidth(20);                
                glVertexPointer(2, GL_FLOAT, 0, interactionPoints);
                glEnableClientState(GL_VERTEX_ARRAY);
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, interactionColors);
				glEnableClientState(GL_COLOR_ARRAY);
                
                
                glDrawArrays(GL_LINE_STRIP, 0, [drawingArray count]);      
                
                glDisableClientState(GL_VERTEX_ARRAY);
                glDisableClientState(GL_COLOR_ARRAY);
			}
        }
    }
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	
	
}


- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	// depth buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, 
                             GL_DEPTH_COMPONENT16_OES, 
                             backingWidth, backingHeight);
	
	if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

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
	if (depthRenderbuffer) 
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
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
