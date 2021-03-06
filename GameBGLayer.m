//
//  GameBGLayer.m
//  CanaClone
//
//  Created by Josh Click on 12/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameBGLayer.h"


@implementation GameBGLayer

- (void)addScrollingBackgroundWithParallax
{
	//1st set
    CCSprite *bgLayer = [CCSprite spriteWithSpriteFrameName:@"midground1.png"];
	bgLayer.position = ccp(0,screenSize.height/2-50);
	[objectSpriteBatchNode addChild:bgLayer z:2];
	bgWidth = bgLayer.boundingBox.size.width-1;
	
	CCSprite *mgLayer = [CCSprite spriteWithSpriteFrameName:@"background.png"];
	mgLayer.position = ccp(0,screenSize.height/2+50);
	[objectSpriteBatchNode addChild:mgLayer z:1];
	
	//2nd set
	CCSprite *bgLayer2 = [CCSprite spriteWithSpriteFrameName:@"midground2.png"];
	bgLayer2.position = ccp(bgWidth, screenSize.height / 2-50);
	[objectSpriteBatchNode addChild:bgLayer2 z:2];

	CCSprite *mgLayer2 = [CCSprite spriteWithSpriteFrameName:@"background.png"];
	mgLayer2.position = ccp(bgWidth, screenSize.height / 2+50);
	[objectSpriteBatchNode addChild:mgLayer2 z:1];
	
	//3nd set
	CCSprite *bgLayer3 = [CCSprite spriteWithSpriteFrameName:@"midground1.png"];
	bgLayer3.position = ccp(bgWidth*2, screenSize.height / 2-50);
	[objectSpriteBatchNode addChild:bgLayer3 z:2];
	
	CCSprite *mgLayer3 = [CCSprite spriteWithSpriteFrameName:@"background.png"];
	mgLayer3.position = ccp(bgWidth*2, screenSize.height / 2+50);
	[objectSpriteBatchNode addChild:mgLayer3 z:1];
	
	//4th set
	CCSprite *bgLayer4 = [CCSprite spriteWithSpriteFrameName:@"midground2.png"];
	bgLayer4.position = ccp(bgWidth*3, screenSize.height / 2-50);
	[objectSpriteBatchNode addChild:bgLayer4 z:2];
	
	CCSprite *mgLayer4 = [CCSprite spriteWithSpriteFrameName:@"background.png"];
	mgLayer4.position = ccp(bgWidth*3, screenSize.height / 2+50);
	[objectSpriteBatchNode addChild:mgLayer4 z:1];
	
	
	// Set background color to light gray.
	CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(176, 176, 191, 255)];
	[self addChild:colorLayer z:0];
	
	// Initialize the array that contains the scroll factors for individual stripes.
	speedFactors=[NSMutableArray arrayWithCapacity:3];
	[speedFactors addObject:[NSNumber numberWithFloat:9.0f]];
	[speedFactors addObject:[NSNumber numberWithFloat:0.5f]];
	[speedFactors addObject:[NSNumber numberWithFloat:1.0f]];

}

-(void) update:(ccTime)delta withSpeed:(float)scrollSpeed
{	
    for (CCSprite* sprite in objectSpriteBatchNode.children)
    {
		NSNumber* factor=[speedFactors objectAtIndex:sprite.zOrder];
		CGPoint pos=sprite.position;
		
		pos.x -= scrollSpeed/2 * factor.floatValue * delta;
		
		if (pos.x < -bgWidth) {
			pos.x += bgWidth * 4;
		}
		
		sprite.position = pos;
	}
}

-(id)init {
    if (self = [super init]) {
		screenSize = [[CCDirector sharedDirector] winSize];
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bg_atlas.plist"];
		objectSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"bg_atlas.png"];
		[self addChild:objectSpriteBatchNode z:10];
		
		[self addScrollingBackgroundWithParallax];
		
	}
	return self;
}

@end
