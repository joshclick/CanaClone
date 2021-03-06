//
//  Runner.m
//  CanaClone
//
//  Created by Josh Click on 12/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Runner.h"
#import "BuildingsLayer.h"

@implementation Runner

@synthesize isTouched;

-(void)changeState:(CharacterStates)newState
{
    [self stopAllActions];
    id action = nil;
    //id movementAction = nil;
    //CGPoint newPosition;
    characterState = newState;
	
    switch (newState) {
        case kStateRunning:
			action = [CCAnimate actionWithAnimation:runningAnim];
			break;
		case kStateJumping:
			action = [CCAnimate actionWithAnimation:jumpingAnim];
			break;
		case kStateFalling:
			action = [CCAnimate actionWithAnimation:fallingAnim];
			break;
		case kStateRolling:
			action = [CCAnimate actionWithAnimation:rollingAnim];
			break;
	}
	
	if (action) {
		if (newState == kStateRunning)
			//[self runAction:[CCRepeatForever actionWithAction:action]];
			[self runAction:action];

		else
			[self runAction:action];
	}
	
}

#pragma mark -
-(void)updateStateWithDeltaTime:(ccTime)deltaTime currentPlatHeight:(int)platHeight
{
	minPos = platHeight;
	
	if ((characterState == kStateRunning) ||
		(characterState == kStateRolling)) {
		
		if (isTouched) {
			[self changeState:kStateJumping];
			if (velocity.y == 0) velocity.y = 4.5f; //initial jump speed
		}
	}
	if (velocity.y > 3.2 && isTouched) { //if in process of jumping but below max speed
		velocity.y += 0.40f;
	}
	if (self.position.y > minPos) {  //if above platform level
		velocity.y += gravity; //apply gravity

		if ([self numberOfRunningActions] == 0)
			[self changeState:kStateFalling];
	}

	[self addYPosition:velocity.y * deltaTime * 50];
	
	
	if (self.position.y < minPos) { //if below platform level
		[self stopAllActions];
		
		[self setPosition:ccp(self.position.x, minPos)];
		
		if (velocity.y < -11) //if downward speed fast enough, roll animation
			[self changeState:kStateRolling];
		velocity.y = 0;
	}
		
	if ([self numberOfRunningActions] == 0) {
		if (self.position.y == minPos)
			[self changeState:kStateRunning];
	}

}

- (void)addYPosition:(CGFloat)yDelta
{
	[self setPosition:ccp(self.position.x, self.position.y + yDelta)];
}
	
- (void)initAnimations {
	runningAnim = [self loadPlistForAnimationWithName:@"runningAnim"
												andClassName:NSStringFromClass([self class])];
	jumpingAnim = [self loadPlistForAnimationWithName:@"jumpingAnim"
												andClassName:NSStringFromClass([self class])];
	fallingAnim = [self loadPlistForAnimationWithName:@"fallingAnim"
												andClassName:NSStringFromClass([self class])];
    rollingAnim = [self loadPlistForAnimationWithName:@"rollingAnim"
												andClassName:NSStringFromClass([self class])];
}

-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
								andClassName:(NSString*)className
{
	
    CCAnimation *animationToReturn = nil;
	
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
	
    // 1: Get the Path to the plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask,
															  YES)
						  objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		plistPath = [[NSBundle mainBundle] pathForResource:className
													ofType:@"plist"];
	}
	
	// 2: Read in the plist file
	NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	// 3: If the plistDictionary was null, the file was not found.
	if (plistDictionary == nil) {
		CCLOG(@"Error reading plist: %@.plist", className);
		return nil; // No Plist Dictionary or file found
	}
	
	// 4: Get just the mini-dictionary for this animation
	NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
	if (animationSettings == nil) {
		CCLOG(@"Could not locate AnimationWithName:%@",animationName);
		return nil;
	}
	
	// 5: Get the delay value for the animation
	float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
	animationToReturn = [CCAnimation animation];
	[animationToReturn setDelayPerUnit:animationDelay];
	
	// 6: Add the frames to the animation
	NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
	NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
	NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
	
	//[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Runner_Atlas.plist"];
	//CCSpriteBatchNode *animBatch = [CCSpriteBatchNode batchNodeWithFile:@"Runner_Atlas.png"];
	
	for (NSString *frameNumber in animationFrameNumbers) {
		NSString *frameName = [NSString stringWithFormat:@"%@%@.png",
							   animationFramePrefix,
							   frameNumber];
		[animationToReturn addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
										   spriteFrameByName:frameName]];
	}
	return animationToReturn;
}


- (id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
	if (self = [super initWithSpriteFrame:(CCSpriteFrame *)spriteFrame])
	{

		gravity = -0.50f;
		maxVelocity.x = 1000;
		maxVelocity.y = 360;
		velocity = ccp(0,0);
		minPos = 100;
		
		isTouched = NO;		
		[self initAnimations];
		
		[self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runningAnim]]];
	}
	return self;
}

	
@end
