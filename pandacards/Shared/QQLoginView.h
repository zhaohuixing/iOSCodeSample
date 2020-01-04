//
//  QQLoginView.h
//
//  Created by Zhaohui Xing on 2011-02-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQLoginView : UIView<UIWebViewDelegate> 
{
	UIImageView*					m_TitleIcon;
	UIButton*						m_CloseButton;
	
	float							m_fOldWidth;

	UIWebView*						m_WebLoginView;

	BOOL							m_CanWork;
	UIActivityIndicatorView*		m_Spinner;
}

- (id)initWithFrame:(CGRect)frame;
- (void)Login; 
- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh;
@end
