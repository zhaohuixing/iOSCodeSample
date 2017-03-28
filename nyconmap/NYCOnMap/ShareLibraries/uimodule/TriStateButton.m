//
//  TriStateButton.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "TriStateButton.h"

@interface TriStateButton ()
{
    CGImageRef      m_Image1;
    CGImageRef      m_Image2;
    CGImageRef      m_Image3;
    
    int             m_State;
}

@end

@implementation TriStateButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_Image1 = NULL;
        m_Image2 = NULL;
        m_Image3 = NULL;
        
        m_State = 0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)UpdateState
{
    m_State = (m_State + 1)%3;
    [self setNeedsDisplay];
}

-(int)GetState
{
    return m_State;
}

-(void)SetState:(int)nState
{
    m_State = nState;
    [self setNeedsDisplay];
}

-(void)SetImage:(CGImageRef)image1 Image2:(CGImageRef)image2 Image3:(CGImageRef)image3
{
    m_Image1 = image1;
    m_Image2 = image2;
    m_Image3 = image3;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if(m_State == 0)
        CGContextDrawImage(context, rect, m_Image1);
    else if(m_State == 1)
        CGContextDrawImage(context, rect, m_Image2);
    else if(m_State == 2)
        CGContextDrawImage(context, rect, m_Image3);
    
    CGContextRestoreGState(context);
}


@end
