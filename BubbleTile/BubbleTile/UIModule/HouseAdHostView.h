//
//  HouseAdHostView.h
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-10-20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseAdView.h"

@interface HouseAdHostView : UIView
{
    HouseAdView*        m_AdViews[4];
    int                 m_nActiveAd;
    NSTimeInterval      m_StartTime;
}

- (void)OnTimerEvent;

@end
