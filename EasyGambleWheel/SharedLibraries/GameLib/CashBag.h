//
//  CashBag.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashBag : UIView
{
@private    
    CGImageRef          m_Bag;
    
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;

    UILabel*            m_MoneyLabel;
    BOOL                m_bLabelInBottom;
}

-(void)SetToTop;
-(void)SetToBottom;
-(void)UpdateViewLayout;
-(void)SetLabelValue:(int)nChips;

@end
