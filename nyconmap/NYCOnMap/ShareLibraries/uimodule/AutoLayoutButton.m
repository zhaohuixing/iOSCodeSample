//
//  AutoLayoutButton.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-27.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "AutoLayoutButton.h"


@interface AutoLayoutButton ()
{
    CGRect          m_ProtraitFrame;
    CGRect          m_LandscapeFrame;
    
    
/*
 
 UIControlStateNormal       = 0,
 UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
 UIControlStateDisabled     = 1 << 1,
 UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
 UIControlStateApplication  = 0x00FF0000,              // additional flags available for application use
 UIControlStateReserved     = 0xFF000000               // flags reserved for internal framework use
 
*/
    CGImageRef      m_NormalImage;
    CGImageRef      m_HighlightImage;
    CGImageRef      m_SelectedImage;
    CGImageRef      m_DisableedImage;
    CGImageRef      m_OtherImage;
    
}

@end


@implementation AutoLayoutButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_NormalImage = NULL;
        m_HighlightImage = NULL;
        m_SelectedImage = NULL;
        m_DisableedImage = NULL;
        m_OtherImage = NULL;
    }
    return self;
}

-(void)UpdateLayout:(BOOL)bProtrait
{
    if(bProtrait == YES)
    {
        [self setFrame:m_ProtraitFrame];
    }
    else
    {
        [self setFrame:m_LandscapeFrame];
    }
    
}

-(void)SetProtraitLayout:(CGRect)rect
{
    m_ProtraitFrame = rect;
}

-(void)SetLandScapeLayout:(CGRect)rect
{
    m_LandscapeFrame = rect;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    if(state == UIControlStateNormal)
    {
        if(m_NormalImage != NULL)
        {
            CGImageRelease(m_NormalImage);
            m_NormalImage = NULL;
        }
        m_NormalImage = CGImageRetain(image.CGImage);
    }
    else if(state == UIControlStateHighlighted)
    {
        if(m_HighlightImage != NULL)
        {
            CGImageRelease(m_HighlightImage);
            m_HighlightImage = NULL;
        }
        m_HighlightImage = CGImageRetain(image.CGImage);
    }
    else if(state == UIControlStateDisabled)
    {
        if(m_DisableedImage != NULL)
        {
            CGImageRelease(m_DisableedImage);
            m_DisableedImage = NULL;
        }
        m_DisableedImage = CGImageRetain(image.CGImage);
    }
    else if(state == UIControlStateSelected)
    {
        if(m_SelectedImage != NULL)
        {
            CGImageRelease(m_SelectedImage);
            m_SelectedImage = NULL;
        }
        m_SelectedImage = CGImageRetain(image.CGImage);
    }
    else
    {
        if(m_OtherImage != NULL)
        {
            CGImageRelease(m_OtherImage);
            m_OtherImage = NULL;
        }
        m_OtherImage = CGImageRetain(image.CGImage);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (CGImageRef)GetCurrentStateImage
{
    CGImageRef image = NULL;
    
    if(self.state == UIControlStateNormal)
        image = m_NormalImage;
    else if(self.state == UIControlStateHighlighted)
        image = m_HighlightImage;
    else if(self.state == UIControlStateDisabled)
        image = m_DisableedImage;
    else if(self.state == UIControlStateSelected)
        image = m_SelectedImage;
    else
        image = m_OtherImage;
    
    if(image == NULL)
        image = m_NormalImage;
    
    return image;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGImageRef image = [self GetCurrentStateImage];
    if(image != nil)
    {
        //CGImageRef image = self.currentBackgroundImage.CGImage;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextDrawImage(context, rect, image);
        CGContextRestoreGState(context);
    }
    
}


@end
