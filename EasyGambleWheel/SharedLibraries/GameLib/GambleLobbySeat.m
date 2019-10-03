//
//  GambleLobbySeat.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "GambleLobbySeat.h"
#import "GambleLobby.h"
#import "ImageLoader.h"
#import "GameConstants.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "RenderHelper.h"

#define AVATAR_ANIMATION_TIMEINTERNVAL      0.3
#define PLAYER_BALANCE_DISPLAY_TIME         4

@implementation GambleLobbySeat

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        m_OnlineAvatar = NULL;
        m_bWinResult = YES;
		CGFloat clrvals[] = {0.1, 0.1, 0.05, 1.0};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(3, 3);
        self.backgroundColor = [UIColor clearColor];
        m_bEnable = YES;
        
        m_BalanceView = [[PlayerBalanceView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:m_BalanceView];
        [self sendSubviewToBack:m_BalanceView];
        m_BalanceView.hidden = YES;
        m_bInAnimation = NO;
        self.exclusiveTouch = YES;
    }
    return self;
}

-(void)dealloc
{
    if(m_OnlineAvatar)
        CGImageRelease(m_OnlineAvatar);
    
	CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
}

-(void)SetGameResult:(BOOL)bWinResult
{
    m_bWinResult = bWinResult;
    [self setNeedsDisplay];
}

- (void)DrawAvatarIdle:(CGContextRef)context withRect:(CGRect)rect
{
    int index = m_nAnimationFrame;
    if(3 <= index)
        index = 1;
    
    [RenderHelper DrawAvatarIdle:context withRect:rect withIndex:index withFlag:m_Myself];
}

- (void)DrawAvatarPlay:(CGContextRef)context withRect:(CGRect)rect
{
    int index = m_nAnimationFrame;
    if(3 <= index)
        index = 1;
    if(m_bActivePlayer)
        [RenderHelper DrawAvatarPlay:context withRect:rect withIndex:index withFlag:m_Myself];
    else
        [RenderHelper DrawAvatarIdle:context withRect:rect withIndex:index withFlag:m_Myself];
}

- (void)DrawAvatarResult:(CGContextRef)context withRect:(CGRect)rect
{
    int index = m_nAnimationFrame;
    if(3 <= index)
        index = 1;
    if(m_bEnable)
    {    
        [RenderHelper DrawAvatarResult:context withRect:rect withIndex:index withResult:m_bWinResult withFlag:m_Myself];
    }
    else
    {
        [RenderHelper DrawAvatarResult:context withRect:rect withIndex:index withResult:NO withFlag:m_Myself];
    }
}


- (void)DrawOfflineAvatar:(CGContextRef)context withRect:(CGRect)rect
{
    if(m_GameController)
    {
        CGContextRef layerDC;
        CGLayerRef   layerObj;
        
        CGFloat fSize = [GUILayout GetAvatarImageSize];
        CGSize size =  CGSizeMake(fSize, fSize);
        layerObj = CGLayerCreateWithContext(context, size, NULL);
        layerDC = CGLayerGetContext(layerObj);
        CGRect rt = CGRectMake(0, 0, fSize, fSize);
        CGFloat shadowOffset = 3;
        if([ApplicationConfigure iPADDevice])
            shadowOffset *= 2;
        CGContextSetShadowWithColor(layerDC, m_ShadowSize, shadowOffset, m_ShadowClrs);
        
        if(m_bEnable)
        {    
            int nGameState = [m_GameController GetGameState];
            switch(nGameState)
            {
                case GAME_STATE_RESET:
                case GAME_STATE_READY:
                    [self DrawAvatarIdle:layerDC withRect:rt];
                    break;
                case GAME_STATE_RUN:
                    [self DrawAvatarPlay:layerDC withRect:rt];
                    break;
                case GAME_STATE_RESULT:
                    [self DrawAvatarResult:layerDC withRect:rt];
                    break;
            }
        }
        else
        {
            CGContextSetAlpha(layerDC, 0.2);
            [self DrawAvatarResult:layerDC withRect:rt];
        }
        CGContextDrawLayerInRect(context, rect, layerObj);    
        CGLayerRelease(layerObj);
    }
}

-(void)DrawOnlineAvatarHat:(CGContextRef)context withRect:(CGRect)rect
{
    static CGFloat fSteps[3] = {0.0, 0.5, 1.0};
    
    CGFloat w = rect.size.width*0.2;
    CGFloat h = w*2.0/3.0;
    int index = m_nAnimationFrame;
    if(3 <= index)
        index = 1;
    
    CGFloat dY = h*0.3;
    CGFloat sx = rect.origin.x + (rect.size.width-w)/2.0;
    CGFloat sy = rect.origin.y + dY*fSteps[index];
    CGRect drawRect = CGRectMake(sx, sy , w, h);
    [RenderHelper DrawOnlinePlayeHat:context withRect:drawRect];
}

- (void)DrawOnlineAvatarIdle:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnlineAvatar);
    if(m_Myself)
        [self DrawOnlineAvatarHat:context withRect:rect];
}

- (void)DrawOnlineAvatarPlay:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnlineAvatar);
    int index = m_nAnimationFrame;
    if(3 <= index)
        index = 1;
    if(m_bActivePlayer)
        [RenderHelper DrawOnlinePlayerGesture:context withRect:rect withIndex:index];

    if(m_Myself)
        [self DrawOnlineAvatarHat:context withRect:rect];
}

- (void)DrawOnlineAvatarResult:(CGContextRef)context withRect:(CGRect)rect
{
    [self DrawAvatarResult:context withRect:rect];
}


- (void)DrawOnlineAvatar:(CGContextRef)context withRect:(CGRect)rect
{
    if(m_GameController)
    {
        CGContextRef layerDC;
        CGLayerRef   layerObj;
        
        CGFloat fSize = [GUILayout GetAvatarImageSize];
        CGSize size =  CGSizeMake(fSize, fSize);
        layerObj = CGLayerCreateWithContext(context, size, NULL);
        layerDC = CGLayerGetContext(layerObj);
        CGRect rt = CGRectMake(0, 0, fSize, fSize);
        CGFloat shadowOffset = 3;
        if([ApplicationConfigure iPADDevice])
            shadowOffset *= 2;
        CGContextSetShadowWithColor(layerDC, m_ShadowSize, shadowOffset, m_ShadowClrs);
        if(m_bEnable)
        {    
            int nGameState = [m_GameController GetGameState];
            switch(nGameState)
            {
                case GAME_STATE_RESET:
                case GAME_STATE_READY:
                    [self DrawOnlineAvatarIdle:layerDC withRect:rt];
                    break;
                case GAME_STATE_RUN:
                    [self DrawOnlineAvatarPlay:layerDC withRect:rt];
                    break;
                case GAME_STATE_RESULT:
                    [self DrawOnlineAvatarResult:layerDC withRect:rt];
                    break;
            }
        }
        else
        {
            CGContextSetAlpha(layerDC, 0.2);
            [self DrawOnlineAvatarIdle:layerDC withRect:rt];
        }
        CGContextDrawLayerInRect(context, rect, layerObj);    
        CGLayerRelease(layerObj);
    }
}

-(void)DrawRectOnline:(CGContextRef)context withRect:(CGRect)rect
{
    if(m_OnlineAvatar)
    {
        [self DrawOnlineAvatar:context withRect:rect];
    }
    else
    {
        [self DrawOfflineAvatar:context withRect:rect];
    }
}

-(void)DrawRectOffline:(CGContextRef)context withRect:(CGRect)rect
{
    [self DrawOfflineAvatar:context withRect:rect];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    if(m_bOnlinePlayer)
    {
        [self DrawRectOnline:context withRect:rect];
    }
    else
    {
        [self DrawRectOffline:context withRect:rect];
    }
}


-(void)InitializeSeat:(id<GameControllerDelegate>)pController withID:(int)nID withType:(BOOL)bMyself
{
    m_GameController = pController;
    m_timerCount = [[NSProcessInfo processInfo] systemUptime];
    m_SeatID = nID;
    m_Myself = bMyself;
}

-(int)GetSeatNumber
{
    return m_SeatID;
}

-(void)SetSeatID:(int)nSeatID
{
    m_SeatID = nSeatID;
}

-(void)OnTimerEvent
{
    NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];

    if(m_bShowBalanceView)
    {
        if(PLAYER_BALANCE_DISPLAY_TIME <= (currentTime - m_TimeStartShowBalance))
        {
            if(!m_bInAnimation)
            {    
                [self CloseBalanceView];
                return;
            }    
        }
    }
    
    
/*  ???????????????????????????
 
    if([self UsingOnlineAvatarImage])
        return;
*/    
    if(AVATAR_ANIMATION_TIMEINTERNVAL <= (currentTime - m_timerCount))
    {   
        m_timerCount = currentTime;
        m_nAnimationFrame = (1+m_nAnimationFrame)%4;
        [self setNeedsDisplay];
    }    
}

-(BOOL)UsingOnlineAvatarImage
{
    BOOL bRet = (m_OnlineAvatar != NULL);
    return bRet;
}

-(void)SetOnlineAvatarImage:(CGImageRef)image
{
    if(m_OnlineAvatar)
    {
        CGImageRelease(m_OnlineAvatar);
        m_OnlineAvatar = NULL;
    }
    m_OnlineAvatar = image;
    [self setNeedsDisplay];
}

-(void)ReleaseOnlineAvatarImage
{
    if(m_OnlineAvatar)
    {
        CGImageRelease(m_OnlineAvatar);
        m_OnlineAvatar = NULL;
    }
}

-(BOOL)IsActive
{
    BOOL bRet = (self.hidden == NO);
    return bRet;
}

-(void)SetEnable:(BOOL)bEnable
{
    m_bEnable = bEnable;
}

-(BOOL)GetEnable
{
    return m_bEnable;
}

-(void)SetyActivePlayer:(BOOL)bActivePlayer
{
    m_bActivePlayer = bActivePlayer;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bInAnimation || m_bShowBalanceView)
        return;

    //[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bInAnimation || m_bShowBalanceView)
        return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bInAnimation || m_bShowBalanceView)
        return;
    
    if(m_GameController && ![m_GameController IsOnline])
    {
        int nEvent = GUIID_EVENT_OFFLINE_POPUPMENU_ME;
        if(m_SeatID == 1)
            nEvent = GUIID_EVENT_OFFLINE_POPUPMENU_PLAYER1;
        else if(m_SeatID == 2)
            nEvent = GUIID_EVENT_OFFLINE_POPUPMENU_PLAYER2;
        else if(m_SeatID == 3)
            nEvent = GUIID_EVENT_OFFLINE_POPUPMENU_PLAYER3;
        
        [GUIEventLoop SendEvent:nEvent eventSender:nil];    
    }
    else if(m_GameController && [m_GameController IsOnline])
    {
        [m_GameController OpenOnlinePlayerPopupMenu:m_SeatID];
    }
}

-(void)OnBalanceViewShown
{
    m_bInAnimation = NO;
    [m_BalanceView setNeedsDisplay];
}

-(void)ShowBalanceView
{
    if(m_bShowBalanceView || !m_GameController)
        return;
    
    m_bInAnimation = YES;
    m_bShowBalanceView = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    int nChip = [m_GameController GetPlayerCurrentMoney:m_SeatID];
    [m_BalanceView SetMyCurrentMoney:nChip];
    m_BalanceView.hidden = NO;
    [self bringSubviewToFront:m_BalanceView];
    [m_BalanceView setNeedsDisplay];
    m_TimeStartShowBalance = [[NSProcessInfo  processInfo] systemUptime];    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnBalanceViewShown)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_BalanceView cache:YES];
    [UIView commitAnimations];
    
}

-(void)OnBalanceViewHidden
{
    m_bInAnimation = NO;
    m_bShowBalanceView = NO;
    [self sendSubviewToBack:m_BalanceView];
}

-(void)CloseBalanceView
{
    if(!m_bShowBalanceView)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    m_BalanceView.hidden = YES;
    m_bInAnimation = YES;
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnBalanceViewHidden)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_BalanceView cache:YES];
    [UIView commitAnimations];
    
}

-(void)SetPlayerOnlineStatus:(BOOL)bOnlinePlayer
{
    m_bOnlinePlayer = bOnlinePlayer;
}

-(BOOL)IsOnlinePlayer
{
    return m_bOnlinePlayer;
}

@end
