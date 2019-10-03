//
//  ChoiceDisplay.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;

@interface ChoiceDisplay : NSObject
{
@private    
    CGImageRef          m_ImageNumber;
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;
    
    int                 m_nSeatID;
    BOOL                m_bShowChoice;
    int                 m_LuckyNumber;
}


-(void)DrawChoice:(CGContextRef)context at:(CGRect)rect;
-(void)SetSeatID:(int)nID;
-(int)GetSeatID;
-(void)SetChoice:(int)nLuckNumber;
-(void)ClearChoice;
-(void)HideChoice;
-(void)ShowChoice;
@end
