//
//  NOMTermAcceptUIFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTermAcceptUIFrame.h"
#import "NOMTermAcceptUICore.h"

@interface NOMTermAcceptUIFrame ()
{
    NOMTermAcceptUICore*      m_ReadView;
}

@end

@implementation NOMTermAcceptUIFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        CGRect rect = CGRectMake(0, 0, width, height);
        m_ReadView = [[NOMTermAcceptUICore alloc] initWithFrame:rect];
        [self addSubview:m_ReadView];
        [self UpdateLayout];
    }
    return self;
}

-(void)UpdateLayout
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_ReadView setFrame:rect];
    [m_ReadView UpdateLayout];
}

-(void)OpenPrivacyView
{
    [m_ReadView OpenPrivacyView];
}

-(void)OpenTermOfUseView
{
    [m_ReadView OpenTermOfUseView];
}

@end
