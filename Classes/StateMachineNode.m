//
//  StateMachineNode.m
//  Sandbox
//
//  Created by Pierre Benz on 2010/07/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StateMachineNode.h"


@implementation StateMachineNode

- (id)
init
{
	children	= [[NSMutableArray alloc] init];
	closure		= NO;
	return self;
}

- (void)
setIdCh:(char*)value Length:(int)length
{
	id_ch = (char*) malloc (length * sizeof (char));
	strcpy (id_ch, value);
}

- (char*)
id_ch
{
	return id_ch;
}

- (void)
setStep: (int) value
{
	step = value;
}

- (int) 
getStep
{
	return step;
}

- (void)
setAngle:(float*) _angle
{
    angle = (float*) malloc (sizeof (float) * numAngles * touches);
    memcpy(angle, _angle, sizeof (float) * touches * numAngles);
}

- (float*)
getAngle
{
	return angle;
}

- (void) 
setNumAngles:(int) _numAngles
{
	numAngles = _numAngles;
}

- (int) 
getNumAngles
{
	return numAngles;
}

- (void)
setTouches:(int)_touches
{
    touches = _touches;
}

- (int)
getTouches
{
    return touches;
}

- (void)
addChildNode:(StateMachineNode*)node
{
	[children addObject:node];
}
- (NSMutableArray*)
getChildren
{
	return children;
}


- (void) 
setClosure: (BOOL)value
{
	closure = value;
}

- (BOOL)
getClosure
{
	return closure;
}

- (void)
dealloc
{ 
	[children release];
	free (id_ch);
	[super dealloc];
}
@end
