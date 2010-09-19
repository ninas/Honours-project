//
//  GestureStateMachine.h
//  Sandbox
//
//  Created by Pierre Benz on 2010/07/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StateMachineNode.h"
#import <math.h>


@interface GestureStateMachine : NSObject {
	StateMachineNode *root;
	StateMachineNode *current;
	int featureCount;
	char * gestureType;
}

- (id)init;
- (void) canReadGestureFile:						(NSString*)value;
- (void) processGestureRelations:					(NSArray *)list;
- (void) doesGestureStateExistWithAngle:            (float*)angle 
                               AndTouch:            (int)touches;
- (void) print_gestures:							(StateMachineNode*)node;
- (StateMachineNode*)doesCurrentStateMachineNode:	(StateMachineNode*)currentNode
					       haveChildrenWithAngle:	(float*)angle
                                        OfNumber:   (int)number
                                        AndTouch:   (int)touch;
- (void) startOfGestureStateRecogniser;
- (void) endOfGestureStateRecogniser;
- (char*) getGestureType;
@end
