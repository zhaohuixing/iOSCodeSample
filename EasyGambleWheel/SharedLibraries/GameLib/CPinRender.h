//
//  CPinRender.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;

@interface CPinRender : NSObject
{
    CGImageRef          m_Pointer;
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;
}

+(CGFloat)GetPointerImageLength;
+(CGFloat)GetPointerImageWidth;
+(CGImageRef)CreatePointerImage;
-(void)DrawPointer:(CGContextRef)context at:(CGRect)rect;
@end
