//
//  PatternView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IconView.h"
#import "GameConstants.h"

@interface PatternView : UIView 
{
    IconView*       m_MatrixIcon;
    IconView*       m_SnakeIcon;
    IconView*       m_SpiralIcon;

    enGridType      m_ActiveType;
    enGridLayout    m_ActiveLayout;

}

-(void)UpdateViewLayout;
-(void)OpenView;
@end
