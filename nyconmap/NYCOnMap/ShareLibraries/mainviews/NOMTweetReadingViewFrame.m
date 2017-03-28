//
//  NOMTweetReadingViewFrame.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/7/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTweetReadingView.h"
#import "NOMTweetReadingViewFrame.h"
#import "NOMTweetReadingContentView.h"

#import "NOMTweetReadingView.h"
#import "StringFactory.h"

@interface NOMTweetReadingViewFrame ()
{
    NOMTweetReadingContentView*          m_ContentView;
    
}
@end

@implementation NOMTweetReadingViewFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        m_ContentView = [[NOMTweetReadingContentView alloc] initWithFrame:rect];
        [self addSubview:m_ContentView];
        
		float h = [m_ContentView GetViewHeight:YES];
        [self setContentSize:CGSizeMake(frame.size.width, h)];
        
        
    }
    return self;
}

-(void)CloseView
{
    if([self.superview respondsToSelector:@selector(CloseView:)])
    {
        SEL sel = @selector(CloseView:);
        BOOL bAnimation = YES;
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.superview methodSignatureForSelector:sel]];
        [inv setSelector:sel];
        [inv setTarget:self.superview];
        [inv setArgument:&bAnimation atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [inv invoke];
    }
}

-(void)RestoreScrollViewDefaultPosition
{
    CGPoint pt = CGPointMake(0, 0);
    [self setContentOffset:pt animated:YES];
}

-(void)SetTweetContent:(NOMNewsMetaDataRecord*)pTweetRecord
{
    [m_ContentView SetTweetContent:pTweetRecord];
}

-(void)UpdateLayout
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_ContentView setFrame:rect];
    [m_ContentView UpdateLayout];
}

@end
