//
//  NOMTweetReadingContentView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2/7/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsMetaDataRecord.h"
#import "NOMTweetReadingView.h"
#import "NOMTweetReadingContentView.h"
#import "NOMAppInfo.h"
#import "StringFactory.h"
#import "NOMGUILayout.h"
//#import "CustomImageButton.h"
#import "NonTouchableImageView.h"
#import "NonTouchableLabel.h"
#import "NOMTimeHelper.h"


#import <EventKit/EventKit.h>


#define NOM_TWEETREADINGVIEW_CLOSEBUTTON_ID         0
#define NOM_TWEETREADINGVIEW_LINKBUTTON_ID          1


@interface NOMTweetReadingContentView ()
{
@private
    //CustomImageButton*             m_CloseButton;
    //CustomImageButton*             m_LinkButton;
    NonTouchableLabel*              m_UserDisplayNameLabel;
    NonTouchableImageView*          m_UserIcon;
    UITextView*                     m_TweetContentView;
    NonTouchableLabel*              m_TweetTimeLabel;
    
    NonTouchableImageView*          m_TweetImagePreview;
    
    NSString*                       m_LinkURL;
}

@end

@implementation NOMTweetReadingContentView

+(double)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 20;
    else
        return 10;
}

+ (float)GetButtonWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 90;
    else
        return 60;
}

+ (float)GetButtonHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 60;
    else
        return 40;
}

+(float)GetDefaultTextHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 70;
    else
        return 40;
}

+(float)GetDefaultLabelHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 40;
    else
        return 20;
}

+(float)GetDefaultLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 120;
    else
        return 80;
}

+(float)GetDefaultReadingViewHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 160; //240;
    else
        return 90; //150;
}

- (float)GetImagePreviewSize
{
    float edge = [NOMTweetReadingContentView GetDefaultEdge];
    float w = self.frame.size.width;
    float fRet = w - 2*edge;
    return fRet;
}

-(float)GetViewHeight:(BOOL)bHasImageView
{
    float edge = [NOMTweetReadingContentView GetDefaultEdge];
    float textHeight = [NOMTweetReadingContentView GetDefaultTextHeight];
    float btnHeight = [NOMTweetReadingContentView GetButtonHeight];
    float viewHeight = [NOMTweetReadingContentView GetDefaultReadingViewHeight];
    float imageHeight = [self GetImagePreviewSize];
    float bRet = 4*edge + textHeight + btnHeight + viewHeight;
    if(bHasImageView)
    {
        bRet += (edge + imageHeight);
    }
    return bRet;
}

-(void)UpdateLayout
{
    float edge = [NOMTweetReadingContentView GetDefaultEdge];
    float textHeight = [NOMTweetReadingContentView GetDefaultTextHeight];
    float btnHeight = [NOMTweetReadingContentView GetButtonHeight];
    float viewHeight = [NOMTweetReadingContentView GetDefaultReadingViewHeight];
    float imageHeight = [self GetImagePreviewSize];
    float w;
    float h;
    float sy = edge;
    float sx = edge;
    CGRect rect;
    
    w = [NOMTweetReadingContentView GetDefaultTextHeight];
    h = w;
    rect = CGRectMake(sx, sy, w, w);
    [m_UserIcon setFrame:rect];
    
    sx += (w + edge);
    w = self.frame.size.width - sx - edge;
    rect = CGRectMake(sx, sy, w, h);
    [m_UserDisplayNameLabel setFrame:rect];
    
    sy += (edge + h);
    sx = edge;
    w = self.frame.size.width - 2.0*edge;
    h = [NOMTweetReadingContentView GetDefaultReadingViewHeight];
    rect = CGRectMake(sx, sy, w, h);
    [m_TweetContentView setFrame:rect];

    sy += (edge + h);
    sx = edge;
    w = self.frame.size.width - 2.0*edge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_TweetTimeLabel setFrame:rect];
    
    sy = 4*edge + 2*textHeight + viewHeight;
    sx = edge;
    w = self.frame.size.width - 2.0*edge;
    rect = CGRectMake(sx, sy, w, w);
    [m_TweetImagePreview setFrame:rect];
}

-(void)InitUIs
{
    float edge = [NOMTweetReadingContentView GetDefaultEdge];
    float textHeight = [NOMTweetReadingContentView GetDefaultTextHeight];
    float btnHeight = [NOMTweetReadingContentView GetButtonHeight];
    float viewHeight = [NOMTweetReadingContentView GetDefaultReadingViewHeight];
//    float imageHeight = [self GetImagePreviewSize];
    float w;
    float h;
    float sy = edge;
    float sx = edge;
    CGRect rect;
    
    w = [NOMTweetReadingContentView GetDefaultTextHeight];
    h = w;
    rect = CGRectMake(sx, sy, w, w);
    m_UserIcon = [[NonTouchableImageView alloc] initWithFrame:rect];
    m_UserIcon.backgroundColor = [UIColor clearColor];
    m_UserIcon.contentMode = UIViewContentModeScaleAspectFit;
    [m_UserIcon setImage:[UIImage imageNamed:@"twitterlogo.png"]];
    [self addSubview:m_UserIcon];
    
    sx += (w + edge);
    w = self.frame.size.width - sx - edge;
    rect = CGRectMake(sx, sy, w, h);
    m_UserDisplayNameLabel = [[NonTouchableLabel alloc] initWithFrame:rect];
    m_UserDisplayNameLabel.backgroundColor = [UIColor whiteColor];
    [m_UserDisplayNameLabel setTextColor:[UIColor blackColor]];
    m_UserDisplayNameLabel.highlightedTextColor = [UIColor grayColor];
    [m_UserDisplayNameLabel setTextAlignment:NSTextAlignmentLeft];
    m_UserDisplayNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_UserDisplayNameLabel.adjustsFontSizeToFitWidth = YES;
    m_UserDisplayNameLabel.font = [UIFont systemFontOfSize:h*0.5];
    [m_UserDisplayNameLabel setText:@""];
    [self addSubview:m_UserDisplayNameLabel];
    
    sy += (edge + h);
    sx = edge;
    w = self.frame.size.width - 2.0*edge;
    h = [NOMTweetReadingContentView GetDefaultReadingViewHeight];
    rect = CGRectMake(sx, sy, w, h);
    m_TweetContentView = [[UITextView alloc] initWithFrame:rect];
    
    
    [m_TweetContentView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_TweetContentView setEditable:NO];
    m_TweetContentView.scrollEnabled = YES;
    m_TweetContentView.backgroundColor = [UIColor whiteColor];
    m_TweetContentView.font = [UIFont systemFontOfSize:[NOMTweetReadingContentView GetDefaultTextHeight]*0.35];
    
    [m_TweetContentView setTextColor:[UIColor blackColor]];
    m_TweetContentView.delegate = self;
    [m_TweetContentView setText:@""];

    
    [self addSubview:m_TweetContentView];
    
    sy += (edge + h);
    sx = edge;
    w = self.frame.size.width - 2.0*edge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_TweetTimeLabel = [[NonTouchableLabel alloc] initWithFrame:rect];
    m_TweetTimeLabel.backgroundColor = [UIColor whiteColor];
    [m_TweetTimeLabel setTextColor:[UIColor blackColor]];
    m_TweetTimeLabel.highlightedTextColor = [UIColor grayColor];
    [m_TweetTimeLabel setTextAlignment:NSTextAlignmentLeft];
    m_TweetTimeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_TweetTimeLabel.adjustsFontSizeToFitWidth = YES;
    m_TweetTimeLabel.font = [UIFont systemFontOfSize:h*0.25];
    [m_TweetTimeLabel setText:@""];
    [self addSubview:m_TweetTimeLabel];
    
    
    w = [NOMTweetReadingContentView GetButtonWidth];
    h = btnHeight;
    
    sy = 4*edge + 2*textHeight + viewHeight;
    
    sx = edge;
    w = self.frame.size.width - 2.0*edge;
    rect = CGRectMake(sx, sy, w, w);
    m_TweetImagePreview = [[NonTouchableImageView alloc] initWithFrame:rect];
    m_TweetImagePreview.backgroundColor = [UIColor clearColor];
    m_TweetImagePreview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:m_TweetImagePreview];
    m_TweetImagePreview.hidden = YES;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_LinkURL = nil;
        [self InitUIs];
        //frame.size.height = [NOMReadingContentView GetViewHeight:YES];
        //[self setFrame:frame];
    }
    return self;
}

-(void)SetTweetContent:(NOMNewsMetaDataRecord*)pTweetRecord
{
    m_LinkURL = nil;
    
    if(pTweetRecord != nil)
    {
        if(pTweetRecord.m_NewsPosterDisplayName != nil && 0 < pTweetRecord.m_NewsPosterDisplayName.length)
        {
            [m_UserDisplayNameLabel setText:pTweetRecord.m_NewsPosterDisplayName];
        }
        else
        {
            [m_UserDisplayNameLabel setText:@""];
        }
        
        if(pTweetRecord.m_TwitterUserIconURL != nil && 0 < pTweetRecord.m_TwitterUserIconURL.length)
        {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pTweetRecord.m_TwitterUserIconURL]];
            
            [m_UserIcon setImage:[UIImage imageWithData:data]];
        }
        else
        {
            [m_UserIcon setImage:[UIImage imageNamed:@"twitterlogo.png"]];
        }
        
        if(pTweetRecord.m_TweetText != nil && 0 < pTweetRecord.m_TweetText.length)
        {
            [m_TweetContentView setText:pTweetRecord.m_TweetText];
        }
        else
        {
            [m_TweetContentView setText:@""];
        }

        if(pTweetRecord.m_TwitterTweetLinkURL != nil && 0 < pTweetRecord.m_TwitterTweetLinkURL.length)
        {
            m_LinkURL = pTweetRecord.m_TwitterTweetLinkURL;
        }
        
        if(0 < pTweetRecord.m_nNewsTime)
        {
            NSDate* time = [NOMTimeHelper ConertIntegerToNSDate:pTweetRecord.m_nNewsTime];
            if(time != nil)
            {
                [m_TweetTimeLabel setText:[time description]];
            }
            else
            {
                [m_TweetTimeLabel setText:@""];
            }
        }
        else
        {
            [m_TweetTimeLabel setText:@""];
        }
        
        if(pTweetRecord.m_NewsResourceURL != nil && 0 < pTweetRecord.m_NewsResourceURL.length)
        {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pTweetRecord.m_NewsResourceURL]];
            [m_TweetImagePreview setImage:[UIImage imageWithData:data]];
            m_TweetImagePreview.hidden = NO;
        }
        else
        {
            m_TweetImagePreview.hidden = YES;
        }
    }
    else
    {
        [m_UserDisplayNameLabel setText:@""];
        [m_UserIcon setImage:[UIImage imageNamed:@"twitterlogo.png"]];
        [m_TweetContentView setText:@""];
        [m_TweetTimeLabel setText:@""];
        m_TweetImagePreview.hidden = YES;
    }
}


@end
