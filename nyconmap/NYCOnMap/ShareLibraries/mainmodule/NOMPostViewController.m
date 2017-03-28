//
//  NOMPostViewController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-17.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPostViewController.h"
#import "NOMPostView.h"
#import "NOMSystemConstants.h"
#import "NOMGUILayout.h"

@interface NOMPostViewController()
{
    NOMPostView*                                m_NewsPostView;
    NOMDocumentController*                      m_ParentController;
    int16_t                                     m_nNewsCategory;
    int16_t                                     m_nNewsSubCategory;
    int16_t                                     m_nNewsThirdCategory;
}
@end

@implementation NOMPostViewController

-(void)Reset
{
    m_nNewsCategory = -1;
    m_nNewsSubCategory = -1;
    m_nNewsThirdCategory = -1;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_NewsPostView = nil;
        m_ParentController = nil;
        [self Reset];
    }
    
    return self;
}

-(void)RegisterParent:(NOMDocumentController*)controller
{
    m_ParentController = controller;
}

-(void)InitializePostView:(UIView*)pMainView
{
    if(pMainView == nil)
        return;
    
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    m_NewsPostView = [[NOMPostView alloc] initWithFrame:frame];
    [pMainView addSubview:m_NewsPostView];
    [m_NewsPostView CloseView:NO];
    [m_NewsPostView RegisterController:self];
}

-(void)UpdatePostViewLayout
{
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    if(m_NewsPostView != nil)
    {
        [m_NewsPostView setFrame:frame];
        [m_NewsPostView UpdateLayout];
    }
}

-(void)OnPostViewClosed:(BOOL)bOK
{
    if(bOK == YES)
    {
        NSString* szSubject = [m_NewsPostView GetSubject];
        NSString* szPost = [m_NewsPostView GetPost];
        NSString* szKeyWord = [m_NewsPostView GetKeywords];
        NSString* szCopyRight = [m_NewsPostView GetCopyright];
        NSString* szKML = [m_NewsPostView GetGeographicKML];
        UIImage*  pImage = [m_NewsPostView GetImage];
        BOOL    bShareOnTwitter = [m_NewsPostView AllowTwitterShare];
        [m_ParentController StartPostNews:szSubject
                                 withPost:szPost
                              withKeyWord:szKeyWord
                            withCopyRight:szCopyRight
                                  withKML:szKML
                                withImage:pImage
                           shareOnTwitter:bShareOnTwitter];
    }
    else
    {
        [m_ParentController ResetUserStatus];
    }
}

-(void)CreatePostingNewsDetail:(int16_t)nNewsCategory withSubCategory:(int16_t)nNewsSubCategory withThirdCategory:(int16_t)nNewsThirdCategory
{
    [self Reset];
    m_nNewsCategory = nNewsCategory;
    m_nNewsSubCategory = nNewsSubCategory;
    m_nNewsThirdCategory = nNewsThirdCategory;
    if(m_NewsPostView != nil)
    {
        BOOL bCanShareOnTwitter = [m_ParentController CanShareOnTwitter];
        [m_NewsPostView SetTwitterEnabling:bCanShareOnTwitter];
        [m_NewsPostView SetReferenceInfo:m_nNewsCategory withSubType:m_nNewsSubCategory withThirdType:nNewsThirdCategory isTTweet:NO];
        [m_NewsPostView OpenView:YES];
    }
}

-(void)SetPostingViewReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span
{
    if(m_NewsPostView != nil)
    {
        [m_NewsPostView SetReferencePoint:dLat withLongitude:dLong withSpan:Span];
    }
}

@end
