//
//  PlayHelpView.h
//  XXXXXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FrameListView.h"

@interface PlayHelpItemListView : FrameListView
{
    int                     m_nSelectedIndex;
}

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(int)GetSelectedIndex;
@end


@interface PlayHelpView : UIView
{
@private
    CGPoint                 m_AchorPoint;
    PlayHelpItemListView*   m_ItemListView;
}

-(void)SetAchorAtTop:(float)fPostion;
-(void)UpdateViewLayout;

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(int)GetSelectedIndex;

@end

