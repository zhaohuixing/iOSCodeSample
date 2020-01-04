//
//  IconView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IconView : UIView 
{
    CGImageRef      m_IconImage;
    BOOL            m_bSelected;
    CGImageRef      m_CheckSign;
    int             m_nClickEvent;
    BOOL            m_bEnable;
    CGImageRef      m_StopSign;
}

-(void)SetIconImage:(CGImageRef)image;
-(void)RegisterEvent:(int)nClick;
-(void)SetSelected:(BOOL)bSelected;
-(void)SetEnable:(BOOL)bEnable;
@end
