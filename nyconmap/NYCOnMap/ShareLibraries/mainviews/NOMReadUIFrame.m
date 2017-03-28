//
//  NOMReadUIFrame.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMReadUIFrame.h"
#import "NOMReadUICore.h"

@interface NOMReadUIFrame ()
{
    NOMReadUICore*      m_ReadView;
}

@end

@implementation NOMReadUIFrame

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
        m_ReadView = [[NOMReadUICore alloc] initWithFrame:rect];
        [self addSubview:m_ReadView];
        [self UpdateLayout];
    }
    return self;
}

-(void)UpdateLayout
{
    float height = [m_ReadView GetReadViewHeight];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, height);
    [m_ReadView setFrame:rect];
    [m_ReadView UpdateLayout];
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
    [m_ReadView CleanControlState];
}

-(void)SetSubject:(NSString*)szTitle
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetSubject:szTitle];
    }
}

-(void)SetAuthor:(NSString*)szAuthor
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetAuthor:szAuthor];
    }
}

-(void)SetPost:(NSString*)szPost
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetPost:szPost];
    }
}

-(void)SetKeywords:(NSString*)szKeywords
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetKeywords:szKeywords];
    }
}

-(void)SetCopyright:(NSString*)szCopyright
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetCopyright:szCopyright];
    }
}

-(void)SetGeographicKML:(NSString*)szKML
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetGeographicKML:szKML];
    }
}

-(void)SetImage:(UIImage*)image
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetImage:image];
    }
}

-(void)SetNewsData:(NOMNewsMetaDataRecord*)pData
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetNewsData:pData];
    }
}

-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
    if(m_ReadView != nil)
    {
        [m_ReadView SetReferencePoint:dLat withLongitude:dLong withSpan:Span];
    }
}
@end
