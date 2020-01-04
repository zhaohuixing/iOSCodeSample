//
//  BubbleView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-09-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IconView.h"
#import "GameConstants.h"

@interface BubbleView : UIView 
{
    IconView*       m_ColorBubbleIcon;
    IconView*       m_StarBubbleIcon;
    IconView*       m_WoodBallIcon;
    IconView*       m_BlueBallIcon;
    IconView*       m_RedHeartBallIcon;

    enBubbleType      m_ActiveType;
}

-(void)UpdateViewLayout;
-(void)OpenView;
@end
