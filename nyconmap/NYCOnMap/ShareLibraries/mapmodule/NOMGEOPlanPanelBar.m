//
//  NOMGEOPlanPanelBar.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-27.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanPanelBar.h"
#import "NOMGUILayout.h"

@implementation NOMGEOPlanPanelBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)AddChild:(UIView*)child
{
    [self addSubview:child];
}

-(void)UpdateLayout
{
    BOOL bProtrait = [NOMGUILayout IsProtrait];
    
    int nCount = self.subviews.count;
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            UIView* pView = [self.subviews objectAtIndex:i];
            if(pView != nil && [pView respondsToSelector:@selector(UpdateLayout:)] == YES)
            {
                SEL sel = @selector(UpdateLayout:);
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[pView methodSignatureForSelector:sel]];
                [inv setSelector:sel];
                [inv setTarget:pView];
                [inv setArgument:&bProtrait atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
                [inv invoke];
                
            }
        }
    }
}

-(void)Open
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
}

-(void)Close
{
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
