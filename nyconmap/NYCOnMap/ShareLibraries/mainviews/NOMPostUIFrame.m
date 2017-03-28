//
//  NOMPostUIFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostUIFrame.h"
#import "NOMPostUICore.h"

@interface NOMPostUIFrame ()
{
    NOMPostUICore*      m_PostView;
}

@end

@implementation NOMPostUIFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		self.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
		self.scrollEnabled = YES;
		[self setCanCancelContentTouches:NO];
		self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        CGRect rect = CGRectMake(0, 0, width, height);
        m_PostView = [[NOMPostUICore alloc] initWithFrame:rect];
        [self addSubview:m_PostView];
        [self UpdateLayout];
    }
    return self;
}

-(void)UpdateLayout
{
    float height = [m_PostView GetPostViewHeight];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, height);
    [m_PostView setFrame:rect];
    [m_PostView UpdateLayout];
	[self setContentSize:CGSizeMake(self.frame.size.width, height)];
}

-(void)ScrollViewTo:(float)scrollOffsetY
{
    CGPoint pt = CGPointMake(0, scrollOffsetY);
    [self setContentOffset:pt animated:YES];
}

-(void)RestoreScrollViewDefaultPosition
{
    CGPoint pt = CGPointMake(0, 0);
    [self setContentOffset:pt animated:YES];
}

-(void)CleanControlState
{
    [m_PostView CleanControlState];
}

-(void)OnAddMapElementClick
{
    if([self.superview respondsToSelector:@selector(OpenMapElementView)] == YES)
    {
        [self.superview performSelector:@selector(OpenMapElementView)];
    }
}

-(void)OpenView
{
    [m_PostView OpenView];
}

-(void)SetKML:(NSString*)kml
{
    [m_PostView SetKML:kml];
}

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
    [m_PostView SetReferencePoint:dLat withLongitude:dLong withSpan:Span];
}

-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet
{
    [m_PostView SetReferenceInfo:nMainCate withSubType:nSubCate withThirdType:nThirdType isTTweet:bTwitterTweet];
}

-(NSString*)GetSubject
{
    return [m_PostView GetSubject];
}

-(NSString*)GetPost
{
    return [m_PostView GetPost];
}

-(NSString*)GetKeywords
{
    return [m_PostView GetKeywords];
}

-(NSString*)GetCopyright
{
    return [m_PostView GetCopyright];
}

-(NSString*)GetGeographicKML
{
    return [m_PostView GetGeographicKML];
}

-(UIImage*)GetImage
{
    return [m_PostView GetImage];
}

-(void)HideKeyboard
{
    [m_PostView HideKeyboard];
}


@end
