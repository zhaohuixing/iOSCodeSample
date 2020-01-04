//
//  LayoutView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IconView.h"

@interface LayoutView : UIView 
{
    IconView*       m_TriIcon;
    IconView*       m_SquareIcon;
    IconView*       m_DiaIcon;
    IconView*       m_HexIcon;
}

-(void)UpdateViewLayout;
-(void)OpenView;

@end
