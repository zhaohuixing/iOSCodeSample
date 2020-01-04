//
//  SinaTPostView.h
//  LoveCompassZH
//
//  Created by Zhaohui Xing on 11-02-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draft.h"
#import "WeiboClient.h"
#import "OAuthController.h"

@interface SinaTPostView : UIView <UITextViewDelegate> 
{
	Draft*					m_Draft;
	NSString*				m_GameTitle;
	NSString*				m_GameMsg;
	NSString*               m_GameIcon;
	NSString*				m_GameURL;
    BOOL					m_bInitialized;

	
	UIButton*				m_PostButton;
	
	UITextView*				m_GameTweetView;
	UIImageView*			m_GameIconView;
	UILabel*				m_CommentLabel;
	UITextView*				m_GameCommentView;
	UIImageView*			m_TitleIcon;
	UIButton*				m_CloseButton;
	
	float					m_fOldWidth;
	BOOL                    m_bTextInput;
	UIActivityIndicatorView*		m_Spinner;
}

@property(nonatomic,retain)NSString*				m_GameTitle;
@property(nonatomic,retain)NSString*				m_GameMsg;
@property(nonatomic,retain)NSString*				m_GameIcon;
@property(nonatomic,retain)NSString*				m_GameURL;


- (id)initWithFrame:(CGRect)frame;
- (void)PostSinaTweet:(NSString*)gameTitle withMessage:(NSString*)gameMsg withImage:(NSString*)gameIcon withURL:(NSString*)gameURL;
- (void)SetInitialized;
- (void)PostButtonClick;
- (void)CloseButtonClick;
- (void)DismissMe;
- (void)SetCloseButtonEnable:(BOOL)bYes;
- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh;

@end
