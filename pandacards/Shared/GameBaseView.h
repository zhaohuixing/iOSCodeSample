//
//  GameBaseView.h
//  xxxxx
//
//  Created by ZXing on 09/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameBaseView : UIView 
{
	BOOL	m_bShow;
}

- (void)OnTimerEvent;
- (void)Hide;
- (void)Show:(float)fAlpha;
- (BOOL)IsShow;
- (void)UpdateGameViewLayout;
- (int)GetViewType;

@end
