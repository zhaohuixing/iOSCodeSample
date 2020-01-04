//
//  PreviewView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FrameView.h"

@interface PreviewUI : FrameView
{
    CGImageRef          m_Preview;
    BOOL                m_bEasy;
}

-(void)SetPreview:(CGImageRef)image withLevel:(BOOL)bEasy;

@end


@interface PreviewView : UIView
{
    PreviewUI*          m_Preview;
}

-(void)UpdateSubViewsOrientation;
-(void)CloseView;
-(void)OpenView;
-(void)SetPreview:(CGImageRef)image withLevel:(BOOL)bEasy;

@end
