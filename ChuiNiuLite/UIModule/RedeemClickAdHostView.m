//
//  RedeemClickAdHostView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
//#import "FullScreenAdViewHolder.h"
#import "RedeemClickAdHostView.h"
#import "RectAdViewHolder.h"
#import "GUILayout.h"
#import "StringFactory.h"
#import "UIDevice-Reachability.h"
#import "DrawHelper2.h"
#import "drawhelper.h"
#import "ApplicationConfigure.h"

@implementation MyClickTroughLabel 

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

@end


@implementation RedeemClickAdHostView


-(void)PauseAd
{
    if(m_RectAdBanner.hidden == NO)
        [m_RectAdBanner CloseAdView];
    m_bPaused = YES;
    [m_RectAdBanner PauseAd];
    if(m_Delegate)
        [m_Delegate InterstitialAdViewClicked];
}

-(void)ResumeAd
{
    m_bPaused = NO;
    if(m_RectAdBanner.hidden == NO)
        [m_RectAdBanner ResumeAd];
    if([ApplicationConfigure iPADDevice])
    {
        if(m_RectAdBannerGoogle_iPAD.hidden == NO)
            [m_RectAdBannerGoogle_iPAD ResumeAd];
        if(m_RectAdBannerMM_iPAD.hidden == NO)
            [m_RectAdBannerMM_iPAD ResumeAd];
        if(m_RectAdBannerGoogle_iPAD2.hidden == NO)
            [m_RectAdBannerGoogle_iPAD2 ResumeAd];
    }
}

-(float)GetCloseButtonSize
{
	return 30.0;
}	

- (void)CloseButtonClick
{
    if(m_Delegate)
        [m_Delegate CloseRedeemAdView];
}

//-(void)SetPlayerName:(NSString*)szName
//{
//    [m_Label setText:szName];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
		float size = [GUILayout GetDefaultAlertUIEdge];
       
        float dw = frame.size.width-size*2.0;
        float dh = frame.size.height-size*2.0;
        CGRect rt = CGRectMake(size, size, dw, dh);
        m_NetWarnLabel = [[UILabel alloc] initWithFrame:rt];
        m_NetWarnLabel.backgroundColor = [UIColor clearColor];
        [m_NetWarnLabel setTextColor:[UIColor yellowColor]];
        m_NetWarnLabel.font = [UIFont fontWithName:@"Times New Roman" size:20];
        [m_NetWarnLabel setTextAlignment:UITextAlignmentCenter];
        m_NetWarnLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_NetWarnLabel.adjustsFontSizeToFitWidth = YES;
        m_NetWarnLabel.numberOfLines = 0;
        [m_NetWarnLabel setText:[StringFactory GetString_NetworkWarn]];
        [self addSubview:m_NetWarnLabel];
        [m_NetWarnLabel release];
        m_NetWarnLabel.hidden = YES;        
        
        m_RectAdBanner = [[RectAdViewHolder alloc] initWithFrame:CGRectMake(size, size, 300, 250)];
        m_RectAdBanner.m_Delegate = self;
        [self addSubview:m_RectAdBanner];
        [m_RectAdBanner release];
        [m_RectAdBanner CloseAdView];

        if([ApplicationConfigure iPADDevice])
        {
            m_RectAdBannerGoogle_iPAD = [[RectAdViewHolder alloc] initWithFrame:CGRectMake(size+300, size, 300, 250)];
            m_RectAdBannerGoogle_iPAD.m_Delegate = self;
            [self addSubview:m_RectAdBannerGoogle_iPAD];
            [m_RectAdBannerGoogle_iPAD release];
            [m_RectAdBannerGoogle_iPAD CloseAdView];

            m_RectAdBannerMM_iPAD = [[RectAdViewHolderMM alloc] initWithFrame:CGRectMake(size, size+250, 300, 250)];
            m_RectAdBannerMM_iPAD.m_Delegate = self;
            [self addSubview:m_RectAdBannerMM_iPAD];
            [m_RectAdBannerMM_iPAD release];
            [m_RectAdBannerMM_iPAD CloseAdView];

            m_RectAdBannerGoogle_iPAD2 = [[RectAdViewHolder alloc] initWithFrame:CGRectMake(size, size+250, 300, 250)];
            m_RectAdBannerGoogle_iPAD2.m_Delegate = self;
            [self addSubview:m_RectAdBannerGoogle_iPAD2];
            [m_RectAdBannerGoogle_iPAD2 release];
            [m_RectAdBannerGoogle_iPAD2 CloseAdView];
        }
        
        
 		CGRect rect = CGRectMake(size, size, frame.size.width-2*size, 40);
		m_Label = [[MyClickTroughLabel alloc] initWithFrame:rect];
		m_Label.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0.4];
		[m_Label setTextColor:[UIColor darkTextColor]];
		m_Label.font = [UIFont fontWithName:@"Times New Roman" size:16];
        [m_Label setTextAlignment:UITextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
		[m_Label setText:[StringFactory GetString_ClickToClose]];
		[self addSubview:m_Label];
		[m_Label release];
       
        m_bPaused = NO;
     
        m_nRedeemType = REDEEMTYPE_ONLINE;
        
        m_nRedeemClickThreshold = 1;
        m_nRedeemClickCount = 0;
        
        m_nPostPoint = 0;
        m_nPostSpeed = 0;
        m_nPostScore = 0;
        
    }
    return self;
}

- (void)dealloc
{
//    [m_FullScreenAdView release];
    [super dealloc];
}

-(void)RegisterDelegate:(id<AdRequestHandlerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)AdViewClicked:(int)nType
{
    [ApplicationConfigure SetAsRedeemModalPresent];
//    if(m_Delegate)
//        [m_Delegate AdViewClicked:nType];
    if(m_Delegate)
    {    
        [ApplicationConfigure SetModalPresentAccountable];
        [m_Delegate InterstitialAdViewClicked];
    }      
}

-(void)RedeemAdViewClosed
{
    ++m_nRedeemClickCount;
    if(m_nRedeemClickThreshold <= m_nRedeemClickCount)
    {
        [ApplicationConfigure ClearRedeemModalPresent];
        [self FinishRedeem];
    }
}

-(void)AdViewClosed:(int)nType
{
    
}

-(void)AdViewLoaded:(int)nType
{
    
}

-(void)AdViewFailed
{
    [m_RectAdBanner CloseAdView];
}

-(void)AdLoadSucceed
{
//    if(m_Delegate)
//        [m_Delegate InterstitialAdViewClicked];
}

-(void)AdLoadFailed
{
    [m_RectAdBanner OpenAdView];
}

-(void)StartShowAd
{
    [m_RectAdBanner OpenAdView];
    if([ApplicationConfigure iPADDevice])
    {
        [m_RectAdBannerGoogle_iPAD OpenAdViewGoogleFirst];
        [m_RectAdBannerMM_iPAD OpenAdView];
        [m_RectAdBannerGoogle_iPAD2 OpenAdViewGoogleFirst];
    }
    [self bringSubviewToFront:m_Label];
}

-(void)StopShowAd
{
    if(m_RectAdBanner.hidden == NO)
        [m_RectAdBanner CloseAdView];
    if([ApplicationConfigure iPADDevice])
    {
        if(m_RectAdBannerGoogle_iPAD.hidden == NO)
            [m_RectAdBannerGoogle_iPAD CloseAdView];
        
        if(m_RectAdBannerMM_iPAD.hidden == NO)
            [m_RectAdBannerMM_iPAD CloseAdView];
        
        if(m_RectAdBannerGoogle_iPAD2.hidden == NO)
            [m_RectAdBannerGoogle_iPAD2 CloseAdView];
        
    }
    [ApplicationConfigure ClearModalPresentAccountable];
}

-(void)OnTimerEvent
{
    if(m_bPaused)
        return;
    if(m_RectAdBanner.hidden == NO)
        [m_RectAdBanner OnTimerEvent];

    if(m_NetWarnLabel.hidden == YES && [UIDevice networkAvailable] == NO)
    {
        m_Label.hidden = YES;
        m_RectAdBanner.hidden = YES;
        m_NetWarnLabel.hidden = NO;
    }
    else if(m_NetWarnLabel.hidden == NO && [UIDevice networkAvailable] == YES)
    {
        m_Label.hidden = NO;
        m_RectAdBanner.hidden = NO;
        [m_RectAdBanner ResumeAd];
        m_NetWarnLabel.hidden = YES;
    }
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    float fsize = [GUILayout GetOptionalAlertUIConner];
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawOptionalAlertBackground:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawOptionalAlertBackgroundDecoration:context];
    CGContextRestoreGState(context);
}


-(void)FinishRedeem
{
    [self StopShowAd];
    if(m_Delegate)
    {    
        //[ApplicationConfigure SetOneTimeTemporaryAccess:YES];
        [m_Delegate CloseRedeemAdView];
        /*if(m_nRedeemType == REDEEMTYPE_ONLINE)
        {
            [m_Delegate HandleFreeVersionOnlineOption];
        }
        else if(m_nRedeemType == REDEEMTYPE_SCOREPOST)
        {
            [m_Delegate HandleFreeVersionGameCenterScorePost:m_nPostScore withPoint:m_nPostPoint withSpeed:m_nPostSpeed];
        }
        else if(m_nRedeemType == REDEEMTYPE_INVITATION)
        {
            [m_Delegate HandleFreeVersionOnlineInvitation];
        }*/
    }    
}

-(void)SetRedeemType:(int)nType
{
    m_nRedeemType = nType;
    
    m_nRedeemClickThreshold = 1;
    m_nRedeemClickCount = 0;
}

-(void)SetScorePost:(int)nScore withPoint:(int)nPoint withSpeed:(int)nSpeed
{
//    m_nRedeemType = REDEEMTYPE_SCOREPOST;
//    m_nPostPoint = nScore;
//    m_nPostSpeed = nPoint;
//    m_nPostScore = nScore;
}

@end
