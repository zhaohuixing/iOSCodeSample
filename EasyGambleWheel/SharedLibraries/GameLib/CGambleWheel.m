//
//  CGambleWheel.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CGambleWheel.h"
#import "ApplicationConfigure.h"

#define WHEEL_RENDER_SIZE_IPHONE           270
#define WHEEL_RENDER_SIZE_IPAD             640

@implementation CGambleWheel

+(float)GetRenderSize
{
    float fSize = WHEEL_RENDER_SIZE_IPHONE;
    if([ApplicationConfigure iPADDevice])
        fSize = WHEEL_RENDER_SIZE_IPAD;
    
    return fSize;
    
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Compass = [[CCompass alloc] init];
        m_Pointer = [[CPointer alloc] init];
    }
    return self;
}

-(void)dealloc
{
}

- (void)OnTimerEvent
{
    [m_Compass OnTimerEvent];
    [m_Pointer OnTimerEvent];
}

- (void)Draw:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextRef layerDC;
	CGLayerRef   layerObj;
	
    float fSize = [CGambleWheel GetRenderSize];
    float fLayerSize = fSize*[ApplicationConfigure GetCurrentDisplayScale];
        
    CGSize size =  CGSizeMake(fLayerSize, fLayerSize);
        
    layerObj = CGLayerCreateWithContext(context, size, NULL);
	layerDC = CGLayerGetContext(layerObj);
    
    [m_Compass DrawCompass:layerDC withSize:size];
    [m_Pointer DrawPointer:layerDC withSize:size];

    float sx = rect.origin.x + (rect.size.width - fSize)/2.0;
    float sy = rect.origin.y + (rect.size.height - fSize)/2.0;
    CGRect drawRect = CGRectMake(sx, sy, fSize, fSize);
    CGContextDrawLayerInRect(context, drawRect, layerObj);    
	CGLayerRelease(layerObj);
}

- (void)StartSpin:(CPinActionLevel*)action
{
    [m_Pointer StartSpin:action];
}

- (void)RegisterDelegate:(id<GameStateDelegate>)delegate
{
    [super RegisterDelegate:delegate];
    [m_Compass RegisterDelegate:delegate];
    [m_Pointer RegisterDelegate:delegate];
}

- (void)SetGameType:(int)nType theme:(int)themeType
{
    [m_Compass SetGameType:nType theme:themeType];
}

- (void)Stop
{
    [m_Pointer Reset];
}
@end
