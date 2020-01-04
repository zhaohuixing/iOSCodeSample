//
//  GlossyMenuItem.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MenuItemBase.h"

@interface GlossyMenuItem : MenuItemBase 
{
	CGImageRef					m_ImageNormal;
	CGImageRef					m_ImageHighLight;
	CGImageRef					m_ImageChecked;
	CGImageRef					m_ImageCheckedHighLight;

	CGPoint						m_ptGroundZero;
	CGPoint						m_ptDestination;
	CGSize						m_NormalSize;
	float						m_fDuration; //in second, animation duration
	BOOL						m_bReflection;				
	BOOL						m_bInFadeOut;
}

-(id)initWithMeueID:(int)nID withFrame:(CGRect)frame withContainer:(id<MenuHolderTemplate>)p; 
-(void)RegisterNormalImage:(NSString*)src;
-(void)RegisterHighLightImage:(NSString*)src;
-(void)RegisterCheckedImage:(NSString*)src;
-(void)RegisterCheckedHighLightImage:(NSString*)src;

-(void)SetAnimationDuration:(float)fSecond;
-(void)SetNormalCenter:(CGPoint)center;
-(void)SetGroundZero:(CGPoint)zero;
-(void)Reset;
-(void)Show;
-(void)Hide;
-(void)FadeIn;
-(void)FadeOut;
-(void)FadeInDone;
-(void)FadeOutDone;

-(void)SetCoolVisual:(BOOL)bEnable;


@end
