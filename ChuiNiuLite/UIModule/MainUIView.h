//
//  MainUIView.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainUIView : UIView 
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
