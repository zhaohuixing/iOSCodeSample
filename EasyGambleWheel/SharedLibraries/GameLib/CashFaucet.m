//
//  CashFaucet.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CashFaucet.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"

@implementation CashFaucet

- (float)GetShadowSize
{
    if([ApplicationConfigure iPADDevice])
        return 4;
    else
        return 2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_Faucet = [ImageLoader LoadImageWithName:@"throticon.png"];
		CGFloat clrvals[] = {0.5, 0.2, 0.05, 1.0};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		float ss = [self GetShadowSize];
        m_ShadowSize = CGSizeMake(ss, ss);
    }
    return self;
}

-(void)dealloc
{
    CGImageRelease(m_Faucet);
	CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	float ss = [self GetShadowSize];
    float sx = rect.origin.x + ss;
    float sy = rect.origin.y + ss;
    float sw = rect.size.width - 2*ss;
    float sh = rect.size.height - 2*ss;
    CGRect rt=CGRectMake(sx, sy, sw, sh);
    
    CGContextSetShadowWithColor(context, m_ShadowSize, ss, m_ShadowClrs);
    
    CGContextDrawImage(context, rt, m_Faucet);
    
    CGContextRestoreGState(context);
}

-(void)SetHide
{
    self.hidden = YES;
}

@end
