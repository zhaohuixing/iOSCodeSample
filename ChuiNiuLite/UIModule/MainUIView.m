//
//  MainUIView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MainUIView.h"
#import "GUILayout.h"

@implementation MainUIView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self OnOrientationChange];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void)OnOrientationChange
{
	CGRect rect = self.frame;
	
	float longSize = (rect.size.width < rect.size.height ? rect.size.height:rect.size.width);
	float shortSize = (rect.size.width < rect.size.height ? rect.size.width:rect.size.height); 
	
	UIDevice * myPhone = [UIDevice currentDevice];
	if(myPhone.orientation == UIDeviceOrientationPortrait || myPhone.orientation == UIDeviceOrientationPortraitUpsideDown)
	{
		[GUILayout SetMainUIDimension:shortSize withHeight:longSize];
	}
	else if(myPhone.orientation == UIDeviceOrientationLandscapeLeft || myPhone.orientation == UIDeviceOrientationLandscapeRight)
	{
		[GUILayout SetMainUIDimension:longSize withHeight:shortSize];
	}
}

-(void)InitSubViews
{
}

-(void)UpdateSubViewsOrientation
{
}	

-(void)UpdateAdViewsState
{
}

-(void)OnTimerEvent
{
}	

-(void)ResumeAds
{
    
}

-(void)PauseAds
{
    
}

-(void)ShowSpinner
{
    
}

-(void)HideSpinner
{
    
}

@end
