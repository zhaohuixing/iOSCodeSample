//
//  CustomImageButton.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-10.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "CustomImageButton.h"


@implementation CustomImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_CustomImage = NULL;
    }
    return self;
}

-(void)dealloc
{
//    if(m_CustomImage != NULL)
//    {
//        CGImageRelease(m_CustomImage);
//    }
}

-(void)SetCustomImage:(CGImageRef)image
{
    m_CustomImage = image;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(m_CustomImage != NULL)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextDrawImage(context, rect, m_CustomImage);
        CGContextRestoreGState(context);
    }
}


@end
