//
//  GestureStateMachine.m
//  Sandbox
//
//  Created by Pierre Benz on 2010/07/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GestureStateMachine.h"



@implementation GestureStateMachine

/*TODO: keep counter of features */


- (id) 
init
{
	if ((self = [super init])) {
        root = [[StateMachineNode alloc] init];
        [root setIdCh:"root" Length:4];
        [root setTouches:0];
		
		current = NULL;
        
        // Initialization code
		[self canReadGestureFile:@"swapDown"];
		[self canReadGestureFile:@"down"];
		
		[self canReadGestureFile:@"swapUp"];
		[self canReadGestureFile:@"up"];
		
		[self canReadGestureFile:@"right"];	
		[self canReadGestureFile:@"swapRight"];
		
		[self canReadGestureFile:@"z"];
		
		[self canReadGestureFile:@"left"];	
		[self canReadGestureFile:@"swapLeft"];
		
		[self canReadGestureFile:@"diagonalUp"];
		[self canReadGestureFile:@"diagonalDown"];
			
		


		
        //[self canReadGestureFile:@"spiralout"];         
        //[self canReadGestureFile:@"2down"];
        //[self canReadGestureFile:@"3down"];           
        //[self canReadGestureFile:@"v"];


        //[self canReadGestureFile:@"u"];
        
        
		
        //NSLog(@"Printing Gestures");
		[self print_gestures:root];
    }
    return self;
}

- (void) 
canReadGestureFile:(NSString*)value 
{
	//read in the file "foo.gesture"
	NSString *filePath	= [[NSBundle mainBundle]pathForResource:value ofType:@"gesture"];
	NSString *data		= [NSString stringWithContentsOfFile:filePath ];
	if (!data){
		NSLog(@"Error: cannot read gesture definition file :%s, exiting",[value UTF8String]);
	}else{
		//add each line to an NSArray
		[self processGestureRelations:[data componentsSeparatedByString:@"\n"]];
	}
}


/* process gesture relations from input files */
- (void)
processGestureRelations:(NSArray *)list
{
	//NSLog(@"Adding Gesture to Engine ");
    char *string = [[list objectAtIndex:0] UTF8String];
	//NSLog(@"Processing gesture file:%s", string);
	/* reset node to point to the root node */
	current = root;
    int features = [[list objectAtIndex:1] intValue];
	for (int i = 2; i < features * 3 +2; i+=3){
        int numAngles = [[list objectAtIndex:i] intValue];
        int touches = [[list objectAtIndex:i+1] intValue];
        NSArray *values = [[list objectAtIndex:i+2] componentsSeparatedByString:@" "];
        //peek ahead and get touches value
        float angles[numAngles * touches];
        
        /*generate angles */
        for (int j = 0; j < numAngles * touches; j++){
            angles[j] = [[values objectAtIndex:j] floatValue];
        }
        
        StateMachineNode *child = [self doesCurrentStateMachineNode:current haveChildrenWithAngle:angles OfNumber:numAngles AndTouch:touches];
        
        if (child != NULL){
            
            current = child;
        }else{
            //NSLog(@"Previous node doesn't exist, creating");
            StateMachineNode *node = [[[StateMachineNode alloc] init] autorelease];
            [node setTouches:touches];
            [node setNumAngles:numAngles];
            [node setAngle:angles];
            [current addChildNode:node];
            current = node;
        }
	}
	
    [current setIdCh:string Length:[[list objectAtIndex:0] length]];
	[current setClosure:YES];
}

- (StateMachineNode*)
doesCurrentStateMachineNode:(StateMachineNode*)currentNode
haveChildrenWithAngle:(float*)angle
OfNumber:(int)numAngles
AndTouch:(int)touch
{
    BOOL found = NO;
	StateMachineNode *returnNode = NULL;
    for (int i = 0; i < [[currentNode getChildren] count]; i++){
        
        int gestureTouches = [[[currentNode getChildren] objectAtIndex:i] getTouches];
        //instant fail if touches aren't the same    
        if (gestureTouches == touch){
            
            float *gestureAngles = [[[currentNode getChildren] objectAtIndex:i] getAngle];
            int gestureNumAngles = [[[currentNode getChildren]objectAtIndex:i] getNumAngles];
            
            if (numAngles <= gestureNumAngles){
                for (int j = 0; j < gestureNumAngles * gestureTouches; j+=gestureTouches){
                    for (int k = 0; k < gestureTouches; k++){
                        for (int l = 0; l < numAngles * touch; l+=touch){
                            for (int n = 0; n < touch; n++){
                                if (angle[l+n] == gestureAngles[j+k]){
                                    found = YES;
                                }
                            }
                        }
                    }
                }
            }
            if (found)
                returnNode = [[currentNode getChildren] objectAtIndex:i];
        }
    }
	return returnNode;
}

- (void)
print_gestures: (StateMachineNode*) node
{
    //NSLog(@"------------");	
    float *angles = [node getAngle];
    int touches = [node getTouches];
    int numAngles = [node getNumAngles];
    for (int i = 0; i < touches * numAngles; i+=touches){
        NSLog(@"touches: %d", touches);
        for (int j = 0; j < touches; j++){
            NSLog(@"angles: %f", angles[i+j]);
        }
    }
    if ([node getClosure]){
        NSLog(@"Node: %s [CLOSURE]", [node id_ch]);        
    }
    
	NSLog(@"Amount of children: %d", [[node getChildren] count]);
    
    
	for (int i = 0; i < [[node getChildren] count]; i++){
		[self print_gestures:[[node getChildren] objectAtIndex:i]];
	}
}

- (void) 
startOfGestureStateRecogniser
{
	//initialise some stuff here
	current = root;	
    //NSLog(@"------------------");
	//NSLog(@"Gesture Started");
}

- (void)
endOfGestureStateRecogniser
{
	if ([current getClosure]){
		
            gestureType = [current id_ch];
		
		
	}	
	else {
		gestureType = '\0';
	}

    featureCount = 0;
    //NSLog(@"Gesture Ended");
}

/* TODO: keep tracker for multiple positive finds */
- (void)
doesGestureStateExistWithAngle:(float*)angle
AndTouch:(int)touches
{	
    
	BOOL found = NO;
	
    
    /*modify the input angle to 0.0*/
    for (int i = 0; i < touches; i++){
        if (angle[i] >= 350)
            angle[i] = 0;
    }
    
    
    //NSLog(@"touches %d", touches);
    //NSLog(@"--checking features in engine");
    
    if (current != root && current != NULL){ //make sure we don't check the current node if we're still in root
        /* check if current node can't point to itself again */
        float   *currentAngles      = [current getAngle];
        int     currentTouches      = [current getTouches];
        int     currentNumAngles    = [current getNumAngles];
        int     count               = 0;        
        float   *tempAngles;         
        
        if (touches == currentTouches){
            for (int i = 0; i < currentTouches * currentNumAngles; i+= currentTouches){
                //NSLog(@"touch %d", currentTouches);
                if (count < currentTouches){                
                    /* get touches with angles into a tempAngle variable, for easier coding*/
                    for (int j = 0; j < currentTouches; j++){
                        tempAngles = &currentAngles[i + j];
                        //NSLog(@"angles %f %f", angle[j], *tempAngles);
                        
                        
                        if (*tempAngles == 0.0 || *tempAngles == 90.0 || *tempAngles == 180.0 ||
                            *tempAngles == 270){
                            if (angle[j] < *tempAngles + 10.0 && angle[j] > *tempAngles - 10.0){
                                count++;
                            }
                        }else{
                            if (angle[j] < *tempAngles + 35.0 && angle[j] > *tempAngles - 35.0){
                                count++;
                            }
                        }
                        
                    }
                    //NSLog(@"count %d", count);
                    if (count == currentTouches){
                        //NSLog(@"feature found in current node, staying");
                        found = YES;                                
                    }                    
                }
                
                
            }             
        }else{
            //NSLog(@"failed being equal to touch number");
        }        
    }
    
    
    if (!found){
        //NSLog(@"Checking children");
        if ([[current getChildren] count] > 0){ //hard fail if no where else to go 
			//NSLog(@"Number of children %d", [[current getChildren] count]);
            for (int i = 0; i < [[current getChildren] count]; i++){
                float* gestureAngle     = [[[current getChildren] objectAtIndex:i] getAngle];
                int    gestureTouches   = [[[current getChildren] objectAtIndex:i] getTouches];
                int    gestureNumAngles = [[[current getChildren] objectAtIndex:i] getNumAngles];
                float  *tempAngles;
                int    count  = 0;                
                
                if (touches == gestureTouches){ /* hard fail if touches don't equal */
                    // NSLog(@"touches equal");
                    for (int j = 0; j < gestureTouches * gestureNumAngles; j+= gestureTouches){
                        
                        if (count < gestureTouches){
                            
                            for (int k = 0; k < gestureTouches; k++){
                                tempAngles = &gestureAngle[j+k]; 
                                //NSLog(@"angles %f %f", angle[k], *tempAngles);
                                
                                if ( *tempAngles == 0 || *tempAngles == 90 || *tempAngles == 180||
                                    *tempAngles == 270){
                                    if (angle[k] < *tempAngles + 10.0 && angle[k] > *tempAngles - 10.0){
                                        count++;
                                    }
                                }else{
                                    if (angle[k] < *tempAngles + 35.0 && angle[k] > *tempAngles - 35.0){
                                        count++;
                                    }
                                }                                      
                                
                                
                                
                            }
                            //NSLog(@"count %d", count);
                            if (!found && count == gestureTouches){
                                found = YES;
                                current = [[current getChildren] objectAtIndex:i];
                                //NSLog(@"feature found in child, moving");
                            }                                
                        }
                    }                    
                    
                }else{
                    //NSLog(@"touches not equal");
                }
            }
        }
        if (!found){ //last check before fail
            current = NULL;
            
        }
    }else {
        /* keep current looking itself */        
    }
    
}

- (char*) 
getGestureType
{
    return gestureType;
}

- (void)
releaseStateMachineNode:(StateMachineNode*) node
{
	for (int i = 0; i < [[node getChildren] count]; i++){
		[self releaseStateMachineNode:[[node getChildren] objectAtIndex:i]];
	}
	[node release];
}

- (void)
dealloc
{
	current = NULL;
	[self releaseStateMachineNode:root];
    
	[super dealloc];
}
@end
