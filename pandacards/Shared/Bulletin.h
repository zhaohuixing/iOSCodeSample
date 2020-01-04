//
//  Bulletin.h
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameBaseView;
@class DealController;

@interface BulletinSign : UIView 
{
    int                 m_Count;
    BOOL                m_bWinCount;
    BOOL                m_bUsed2NonWinSign;
    float               m_fRotateAngle;
}

- (void)SetCount:(int)n;
- (void)SetRotate:(float)fAngle;
- (void)SetType:(BOOL)bWinCount;
- (void)OnTimerEvent;
- (void)Reset;
- (void)Use2NonWinSign;

@end

@interface Bulletin : GameBaseView 
{
	int					m_nWinDeals;
    DealController*     m_Parent;
    BulletinSign*       m_DealSign;
    BulletinSign*       m_WinSign;
}

- (id)initWithFrame2:(CGRect)frame;

- (void)SetParent:(DealController*)parent;
- (void)OnTimerEvent;
- (int)GetViewType;
- (void)UpdateGameViewLayout;
- (void)Reset;
- (void)AddWinScore;
- (void)AddNonWinPoint:(int)nPoint;
- (void)AddWinPoint:(int)nPoint;


@end
