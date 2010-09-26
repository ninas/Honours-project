//
//  StateMachineNode.h
//  Sandbox
//
//  Created by Pierre Benz on 2010/07/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct _Node Node;

@interface StateMachineNode : NSObject {
	char *id_ch;
	int step;
    int touches;
	float *angle;
    int numAngles;
	NSMutableArray *children;
	bool closure;
}

- (id) init;

- (void) setIdCh:				(char*)value 
		  Length:				(int)length;
- (char*) id_ch;

- (void) setStep:				(int)value;
- (int)  getStep;

- (void) setAngle:				(float*) _angle;
- (float*) getAngle;

- (void) setNumAngles:             (int) _angles;
- (int) getNumAngles;

- (void) setTouches:            (int) _touches;
- (int) getTouches;
- (void) addChildNode:			(StateMachineNode*)node;
- (NSMutableArray*) getChildren;


- (void) setClosure:			(BOOL)value;
- (BOOL) getClosure;
@end
