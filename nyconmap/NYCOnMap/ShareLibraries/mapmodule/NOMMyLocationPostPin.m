//
//  NOMMyLocationPostPin.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-30.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMMyLocationPostPin.h"
#import "ImageLoader.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "CustomImageButton.h"

@interface NOMMyLocationPostPin ()
{
    CustomImageButton*       m_OKButton;
    CustomImageButton*       m_CancelButton;
    
    CGImageRef      m_PinImage;
    
    int             m_OKButtonID;
    int             m_CancelButtonID;
}

@end


@implementation NOMMyLocationPostPin

-(void)OnOKButtonClick
{
    [GUIEventLoop SendEvent:m_OKButtonID eventSender:self];
}

-(void)OnCancelButtonClick
{
    [GUIEventLoop SendEvent:m_CancelButtonID eventSender:self];
}

-(void)InitWithSubControls
{
    float sx = 0;
    float sy = 0;
    float w = self.frame.size.width*0.5;
    float h = w;
    
    CGRect rect = CGRectMake(sx+w, sy, w, h);
    m_OKButton = [[CustomImageButton alloc] initWithFrame:rect];
    m_OKButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OKButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_OKButton addTarget:self action:@selector(OnOKButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OKButton SetCustomImage:[ImageLoader LoadImageWithName:@"gokbtn200.png"]];
    [self addSubview:m_OKButton];
    
    rect = CGRectMake(sx, sy, w, h);
    m_CancelButton = [[CustomImageButton alloc] initWithFrame:rect];
    m_CancelButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_CancelButton addTarget:self action:@selector(OnCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_CancelButton SetCustomImage:[ImageLoader LoadImageWithName:@"bclosebtn200.png"]];
    [self addSubview:m_CancelButton];
    
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size withOK:(int)nOKButtonID withCancel:(int)nCancelButtonID
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, size.height*(-0.5));
        CGRect frame = self.frame;
        frame.size = size;
        self.frame = frame;
        // Initialization code
        [self InitWithSubControls];
        m_PinImage = [ImageLoader LoadImageWithName:@"greenpin200.png"];
        
        m_OKButtonID = nOKButtonID;
        m_CancelButtonID = nCancelButtonID;
        
    }
    return self;
}

-(void)DrawPinSign:(CGContextRef)context inRect:(CGRect)rect
{
    float sy = rect.origin.y + rect.size.height*0.5;
    float sx = rect.origin.x + rect.size.width*0.25;
    float w = rect.size.width*0.5;
    float h = rect.size.height*0.5;
    CGRect rt = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, rt, m_PinImage);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawPinSign:context inRect:rect];
}


@end
