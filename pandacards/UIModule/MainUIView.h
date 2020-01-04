//
//  MainUIView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlossyMenuView.h"

@interface MainUIView : GlossyMenuView //UIView 
{
}

-(void)OnOrientationChange;
-(void)InitSubViews;
-(void)UpdateSubViewsOrientation;
-(void)UpdateAdViewsState;
-(void)OnTimerEvent;

-(void)ResumeAds;
-(void)PauseAds;

-(void)ShowSpinner;
-(void)HideSpinner;

@end
