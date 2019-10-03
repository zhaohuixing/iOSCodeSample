//
//  GoldenCoin.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldenCoin : UIView
{
@private    
    CGImageRef          m_Coin;
    
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;
}

-(void)SetHide;
-(void)OnTimerEvent;

@end
