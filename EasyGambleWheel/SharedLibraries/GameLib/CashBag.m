//
//  CashBag.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CashBag.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"

@implementation CashBag

- (CGFloat)GetShadowSize
{
    if([ApplicationConfigure iPADDevice])
        return 6;
    else
        return 3;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_Bag = [ImageLoader LoadImageWithName:@"walleticon.png"];
		CGFloat clrvals[] = {0.5, 0.2, 0.05, 1.0};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		CGFloat ss = [self GetShadowSize];
        m_ShadowSize = CGSizeMake(ss, ss);
        
        CGRect rect = CGRectMake(0, frame.size.width, frame.size.width, [GUILayout GetCashBagLabelMinHeight]);
		m_MoneyLabel = [[UILabel alloc] initWithFrame:rect];
		m_MoneyLabel.backgroundColor = [UIColor clearColor];
		[m_MoneyLabel setTextColor:[UIColor yellowColor]];
		m_MoneyLabel.font = [UIFont fontWithName:@"Georgia" size:[GUILayout GetCashBagLabelMinFont]];
        [m_MoneyLabel setTextAlignment:NSTextAlignmentCenter];
        m_MoneyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_MoneyLabel.adjustsFontSizeToFitWidth = YES;
		[m_MoneyLabel setText:@"0"];
		[self addSubview:m_MoneyLabel];
        m_bLabelInBottom = YES;
    }
    return self;
}

-(void)dealloc
{
    CGImageRelease(m_Bag);
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
	CGFloat ss = [self GetShadowSize];
    CGFloat sx = rect.origin.x + ss;
    CGFloat sy = rect.origin.y + ss;
    if(m_bLabelInBottom == NO)
        sy += m_MoneyLabel.frame.size.height;
        
    CGFloat sw = rect.size.width - 2*ss;
    CGFloat sh = sw;//rect.size.height - 2*ss;
    CGRect rt=CGRectMake(sx, sy, sw, sh);
    
    CGContextSetShadowWithColor(context, m_ShadowSize, ss, m_ShadowClrs);
    
    CGContextDrawImage(context, rt, m_Bag);
    
    CGContextRestoreGState(context);
}

-(void)SetToTop
{
    CGFloat sw = [GUILayout GetMainUIWidth];
    CGFloat w = [GUILayout GetCashBagMinSize];
    CGFloat h = w + [GUILayout GetCashBagLabelMinHeight];
    CGFloat sx = sw - w;
    CGFloat sy = 0;
    CGRect rect = CGRectMake(sx, sy, w, h);
    [self setFrame:rect];
   
    rect = CGRectMake(0, w, w, [GUILayout GetCashBagLabelMinHeight]);
    [m_MoneyLabel setFrame:rect];
    m_MoneyLabel.font = [UIFont fontWithName:@"Georgia" size:[GUILayout GetCashBagLabelMinFont]];
    m_bLabelInBottom = YES;
}

-(void)SetToBottom
{
    CGFloat sw = [GUILayout GetMainUIWidth];
    CGFloat sh = [GUILayout GetContentViewHeight];
    CGFloat w = [GUILayout GetCashBagSize];
    CGFloat h = w + [GUILayout GetCashBagLabelHeight];
    CGFloat sx = sw - w;
    CGFloat sy = sh-h;
    CGRect rect = CGRectMake(sx, sy, w, h);
    [self setFrame:rect];
    
    rect = CGRectMake(0, 0, w, [GUILayout GetCashBagLabelHeight]);
    [m_MoneyLabel setFrame:rect];
    m_MoneyLabel.font = [UIFont fontWithName:@"Georgia" size:[GUILayout GetCashBagLabelFont]];
    m_bLabelInBottom = NO;
}

-(void)UpdateViewLayout
{
    CGRect rect = self.frame;
    rect.origin.x = [GUILayout GetMainUIWidth] - rect.size.width;
    if(m_bLabelInBottom == NO)
        rect.origin.y = [GUILayout GetContentViewHeight] - rect.size.height;
        
    [self setFrame:rect];
}

-(void)SetLabelValue:(int)nChips
{
    [m_MoneyLabel setText:[NSString stringWithFormat:@"%i", nChips]];
}

@end
