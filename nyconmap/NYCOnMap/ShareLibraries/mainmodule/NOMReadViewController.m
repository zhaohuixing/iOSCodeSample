//
//  NOMReadViewController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMReadViewController.h"
#import "NOMReadView.h"
#import "NOMTweetReadingView.h"
#import "NOMSystemConstants.h"
#import "NOMGUILayout.h"

@interface NOMReadViewController()
{
    NOMReadView*                                m_NewsReadView;
    NOMTweetReadingView*                        m_TweetReadView;
    NOMDocumentController*                      m_ParentController;
}
@end

@implementation NOMReadViewController

-(void)Reset
{
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_NewsReadView = nil;
        m_TweetReadView = nil;
        m_ParentController = nil;
        [self Reset];
    }
    
    return self;
}


-(void)RegisterParent:(NOMDocumentController*)controller
{
    m_ParentController = controller;
}

-(void)InitializeReadView:(UIView*)pMainView
{
    if(pMainView == nil)
        return;
    
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    m_NewsReadView = [[NOMReadView alloc] initWithFrame:frame];
    [pMainView addSubview:m_NewsReadView];
    [m_NewsReadView CloseView:NO];
    
    m_TweetReadView = [[NOMTweetReadingView alloc] initWithFrame:frame];
    [pMainView addSubview:m_TweetReadView];
    [m_TweetReadView CloseView:NO];
}

-(void)UpdateReadViewLayout
{
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    if(m_NewsReadView != nil)
    {
        [m_NewsReadView setFrame:frame];
        [m_NewsReadView UpdateLayout];
    }
    if(m_TweetReadView != nil)
    {
        [m_TweetReadView setFrame:frame];
        [m_TweetReadView UpdateLayout];
    }
}


//
//INOMCustomMapViewPinItemDelegate methods
//
-(void)OpenNews:(NSString*)newsID with:(BOOL)bCanReport
{
    NOMNewsMetaDataRecord* pNews = nil;
    if(m_ParentController != nil && m_NewsReadView != nil)
    {
        pNews = [m_ParentController GetNews:newsID];
        if(pNews != nil)
        {
            [m_NewsReadView CleanControlState];
            double dSpan = [m_ParentController GetCurrentMapVisibleRegionMinSpan];
            [m_NewsReadView SetReferencePoint:pNews.m_NewsLatitude withLongitude:pNews.m_NewsLongitude withSpan:dSpan];
            [m_NewsReadView SetNewsData:pNews];
            [m_NewsReadView OpenView:YES];
        }
    }
}

-(void)OpenCalenderSupportedNews:(NSString*)newsID with:(BOOL)bCanReport withAddress:(NSString*)address
{
    
}

-(void)OpenTwitterTweet:(NSString*)newsID
{
    NOMNewsMetaDataRecord* pNews = nil;
    if(m_ParentController != nil && m_TweetReadView != nil)
    {
        pNews = [m_ParentController GetCachedSocialNews:newsID];
        if(pNews != nil)
        {
            //????????
            //????????
            //[m_TweetReadView CleanControlState];
            //double dSpan = [m_ParentController GetCurrentMapVisibleRegionMinSpan];
            //[m_TweetReadView SetReferencePoint:pNews.m_NewsLatitude withLongitude:pNews.m_NewsLongitude withSpan:dSpan];
            [m_TweetReadView SetTweetContent:pNews];
            [m_TweetReadView OpenView:YES];
        }
        else
        {
            pNews = [m_ParentController GetNews:newsID];
            if(pNews != nil)
            {
                [m_TweetReadView SetTweetContent:pNews];
                [m_TweetReadView OpenView:YES];
            }
        }
    }
}

@end
