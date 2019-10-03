//
//  BetIndicator.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;

@interface BetIndicator : NSObject
{
@private    
    CGImageRef          m_ImageNumber;
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;
    
    int                 m_nSeatID;
    BOOL                m_bShowBet;
}

+(float)GetIndicatorSize;
+(float)GetBufferImageSize;

-(void)DrawIndicator:(CGContextRef)context at:(CGRect)rect;
-(void)SetSeatID:(int)nID;
-(int)GetSeatID;
-(void)SetBet:(int)nBetMoney;
-(void)ClearBet;
-(void)HideBet;
-(void)ShowBet;

@end
