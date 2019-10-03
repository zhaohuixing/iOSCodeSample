//
//  OverLayView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "OverLayView.h"
#import "RenderHelper.h"

@implementation OverLayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, colorSpace);
    
	float fAlpha = 0.65;
	[RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
    CGColorSpaceRelease(colorSpace);
	CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect:rect];
}

@end
