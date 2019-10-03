//
//  GamePlayer.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-09-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GambleLobby.h"
#import "PlayerPopupMenu.h"
#import "ChoiceDisplay.h"
#import "BetIndicator.h"
#import "WinnerAnimator.h"
#import "GambleLobbySeat.h"
#import "GamePlayer.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "RenderHelper.h"
#import "StringFactory.h"
#include "drawhelper.h"
#import "GamePlayer+Online.h"
#import "GUIEventLoop.h"


#define ONLINE_LABEL_HEIGHT_RATIO           0.6

@implementation GamePlayer

- (id)init
{
    self = [super init];
    if (self) 
    {
        m_Packet = [[Packet alloc] init];
        m_PlayerName = nil;
        m_PlayerID = nil;
        m_nSeatID = -1;
        m_GameController = nil;
        m_BetLight = nil;
        m_ChoiceLight = nil;
        m_MySeat = nil;
        m_OnlinePlayerNameTag = nil;
        m_OnLineTextBoard = nil;
        m_OnlineTextPost = nil;
        
        m_nChoiceNumber = -1;    //Luck number for current bet
        m_nBetMoney = -1;        //The money/chip pledge for current bet
        m_bMyturn2Play = NO;
        m_bWinThisPlay = NO;
        m_bEnablePlayCurrentGame = NO;
        m_nReleaseVersion = [ApplicationConfigure GetCurrentReleaseVersion];
        m_nOnlinePlayingState = GAME_PLAYER_STATE_NORMAL;
        
        m_bAcitvated = YES;
        m_bMyself = NO;
        
        m_PlayerOnlineState = GAME_ONLINE_PLAYER_STATE_UNKNOWN;
        m_CachedGKMatchPlayer = nil;
        m_nCachedTransferedChip = 0;
        m_bGKCenterMaster = NO;
        m_bOnlinePlayer = NO;
        m_MessageUIStartTime = 0;
    }
    
    return self;
}

- (void)dealloc
{
    if(m_CachedGKMatchPlayer != nil)
    {
        m_CachedGKMatchPlayer = nil;
    }
}

-(void)Activate:(BOOL)bActivated
{
    m_bAcitvated = bActivated;
    if(m_bAcitvated)
    {
        m_MySeat.hidden = NO;
        if(m_bOnlinePlayer)
        {
            m_OnlinePlayerNameTag.hidden = NO;
            if([self IsMyself])
            {    
                [m_OnlinePlayerNameTag setText:[StringFactory GetString_OfflineMySelfID]];
                [m_OnlinePlayerNameTag setTextColor:[UIColor blueColor]];
            }
            else 
            {
                [m_OnlinePlayerNameTag setTextColor:[UIColor yellowColor]];
                if(m_PlayerName)
                {    
                    [m_OnlinePlayerNameTag setText:m_PlayerName];
                }    
                else
                {    
                    [m_OnlinePlayerNameTag setText:@""];
                }
            }     
        }
        else 
        {
            m_OnlinePlayerNameTag.hidden = YES;
        }
    }
    else
    {
        [m_PopupMenu CloseMenu];
        [m_OnlinePlayerNameTag setText:@""];
        m_OnlinePlayerNameTag.hidden = YES;
        m_MySeat.hidden = YES;
        [m_MySeat ReleaseOnlineAvatarImage];
        if(m_CachedGKMatchPlayer != nil)
        {
            m_CachedGKMatchPlayer = nil;
        }
        if(m_PlayerName)
        {    
            m_PlayerName = nil;
        }    
        if(m_PlayerID)
        {    
            m_PlayerID = nil;
        }    
        m_nSeatID = -1;
        m_bMyself = NO;
        m_PlayerOnlineState = GAME_ONLINE_PLAYER_STATE_UNKNOWN;
        m_nChoiceNumber = -1;    //Luck number for current bet
        m_nBetMoney = -1;        //The money/chip pledge for current bet
        [m_Packet Initialize:0];
        if(m_OnLineTextBoard != nil)
        {    
            [m_OnLineTextBoard CleanTextMessage];
            if([m_OnLineTextBoard IsOpened])
                [m_OnLineTextBoard CloseView:NO];
        }   
        if(m_OnlineTextPost != nil)
        {
            [m_OnlineTextPost CleanTextMessage];
            if([m_OnlineTextPost IsOpened])
                [m_OnlineTextPost CloseView:NO];
        }
    }
}

-(BOOL)IsActivated
{
    return m_bAcitvated;
}

-(void)IntializeAdornments
{
    float yOffset = [GUILayout GetAvatarDislayVerticalMargin];
    float xOffset = [GUILayout GetAvatarDislayHorizontalMargin];
    float fSize = [GUILayout GetAvatarDislaySize];
    float fFlyerHeight = [GUILayout GetAvatarDislaySize]*[GUILayout GetWinnerAnimatorDislayRatio];
    float sx = xOffset;
    float sy = yOffset;
    //BOOL  bMySelf = (m_nSeatID == 0);
  
    if(m_OnLineTextBoard == nil)
    {
        float ftxtsize = fSize*2.0;
        if([ApplicationConfigure iPhoneDevice])
            ftxtsize = 160; 
        m_OnLineTextBoard = [[TextMsgDisplay alloc] initWithFrame:CGRectMake(0, 0, ftxtsize, ftxtsize)];
        [m_GameController RegisterSubUIObject:m_OnLineTextBoard];
        [m_OnLineTextBoard CloseView:NO];
    }
    if(m_OnlineTextPost == nil)
    {
        float ftxtsize2 = fSize*2.0;
        if([ApplicationConfigure iPhoneDevice])
            ftxtsize2 = 160; 
        m_OnlineTextPost = [[TextMsgPoster alloc] initWithFrame:CGRectMake(0, 0, ftxtsize2, ftxtsize2)];
        [m_GameController RegisterSubUIObject:m_OnlineTextPost];
        [m_OnlineTextPost CloseView:NO];
    }
        
    if(m_nSeatID == 1)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
    }
    else if(m_nSeatID == 2)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset;
    }
    else if(m_nSeatID == 3)
    {
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset;
    }
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    if(m_MySeat == nil)
    {    
        m_MySeat = [[GambleLobbySeat alloc] initWithFrame:rect];
        [m_GameController RegisterSubUIObject:m_MySeat];
    }
    [m_MySeat SetPlayerOnlineStatus:m_bOnlinePlayer];
    [m_MySeat InitializeSeat:m_GameController withID:m_nSeatID withType:m_bMyself];
    
    rect = CGRectMake(sx, sy, fSize, fSize*[GUILayout GetPlayerPopuoMenueHeightRatio]);
    if(m_PopupMenu == nil)
    {    
        m_PopupMenu = [[PlayerPopupMenu alloc] initWithFrame:rect];
        m_PopupMenu.hidden = YES;
        [m_GameController RegisterSubUIObject:m_PopupMenu];
        [self RegisterPopupMenuEvent];
    }
    
    float fLabelHeight = fSize*0.5*ONLINE_LABEL_HEIGHT_RATIO;
    sy = yOffset + fSize*1.5;
    sx = xOffset;
    if(m_nSeatID == 1)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
    }
    else if(m_nSeatID == 2)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset-fLabelHeight*0.95;
    }
    else if(m_nSeatID == 3)
    {
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset-fLabelHeight*0.95;
    }
    rect = CGRectMake(sx, sy, fSize, fLabelHeight);
    
    if(m_OnlinePlayerNameTag == nil)
    {    
        m_OnlinePlayerNameTag  = [[UILabel alloc] initWithFrame:rect];
        [m_GameController RegisterSubUIObject:m_OnlinePlayerNameTag];
        [m_OnlinePlayerNameTag.superview sendSubviewToBack:m_OnlinePlayerNameTag];
    }    
    m_OnlinePlayerNameTag.backgroundColor = [UIColor clearColor];
    [m_OnlinePlayerNameTag setTextColor:[UIColor yellowColor]];
    if(m_bMyself)
        [m_OnlinePlayerNameTag setTextColor:[UIColor blueColor]];
        
    m_OnlinePlayerNameTag.font = [UIFont fontWithName:@"Times New Roman" size:fLabelHeight*0.6];
    [m_OnlinePlayerNameTag setTextAlignment:NSTextAlignmentCenter];
    m_OnlinePlayerNameTag.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_OnlinePlayerNameTag.adjustsFontSizeToFitWidth = YES;
    [m_OnlinePlayerNameTag setText:@""];
    if(!m_bOnlinePlayer)
    {    
        m_OnlinePlayerNameTag.hidden = YES;
    }
    else
    {
        if(m_PlayerName)
        {    
            if([self IsMyself])
            {    
                [m_OnlinePlayerNameTag setText:[StringFactory GetString_OfflineMySelfID]];
            }    
            else    
                [m_OnlinePlayerNameTag setText:m_PlayerName];
        }
        else
        {
            if([self IsMyself])
                [m_OnlinePlayerNameTag setText:[StringFactory GetString_OfflineMySelfID]];
        }
        
        if([self IsActivated])
            m_OnlinePlayerNameTag.hidden = NO;
        else
            m_OnlinePlayerNameTag.hidden = YES;
    }
    
    if(m_BetLight == nil)
        m_BetLight = [[BetIndicator alloc] init];
    
    [m_BetLight SetSeatID:m_nSeatID];
    
    if(m_ChoiceLight == nil)
        m_ChoiceLight = [[ChoiceDisplay alloc] init];
    
    [m_ChoiceLight SetSeatID:m_nSeatID];

    sy = sy + fSize;
    rect = CGRectMake(sx, sy, fSize, fFlyerHeight);
    if(m_WinFlyer == nil)
    {    
        m_WinFlyer = [[WinnerAnimator alloc] initWithFrame:rect];
        [m_GameController RegisterSubUIObject:m_WinFlyer];
    }
    [m_MySeat.superview bringSubviewToFront:m_MySeat];
    [self UpdateLayout];
}

-(void)UpdateLayout
{
    float yOffset = [GUILayout GetAvatarDislayVerticalMargin];
    float xOffset = [GUILayout GetAvatarDislayHorizontalMargin];
    float fSize = [GUILayout GetAvatarDislaySize];
    float fFlyerHeight = [GUILayout GetAvatarDislaySize]*[GUILayout GetWinnerAnimatorDislayRatio];
    float sx = xOffset;
    float sy = yOffset;
    
    if(m_nSeatID == 1)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
    }
    else if(m_nSeatID == 2)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset;
    }
    else if(m_nSeatID == 3)
    {
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset;
    }
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    [m_MySeat setFrame:rect];
    
    rect = CGRectMake(sx, sy, m_PopupMenu.frame.size.width, m_PopupMenu.frame.size.height);
    [m_PopupMenu setFrame:rect]; 
    
    sy = sy + fSize;
    rect = CGRectMake(sx, sy, fSize, fFlyerHeight);
    [m_WinFlyer setFrame:rect];
    
    float fLabelHeight = fSize*0.5*ONLINE_LABEL_HEIGHT_RATIO;
    sy = yOffset + fSize*1.45;
    sx = xOffset;
    if(m_nSeatID == 1)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
    }
    else if(m_nSeatID == 2)
    {
        sx = [GUILayout GetMainUIWidth]-fSize-xOffset;
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset-fLabelHeight*0.95;
    }
    else if(m_nSeatID == 3)
    {
        sy = [GUILayout GetContentViewHeight] - fSize*1.5 - yOffset-fLabelHeight*0.95;
    }
    rect = CGRectMake(sx, sy, fSize, fLabelHeight);
    [m_OnlinePlayerNameTag setFrame:rect];
    
    CGRect txtFrame = m_OnLineTextBoard.frame;
    CGRect seatFrame = m_MySeat.frame;
    if([GUILayout IsProtrait])
    {
        if(m_nSeatID == 0)
        {
            txtFrame.origin.x = 0;
            txtFrame.origin.y = seatFrame.origin.y;
        }
        else if(m_nSeatID == 1)
        {
            txtFrame.origin.x = [GUILayout GetMainUIWidth]-txtFrame.size.width;
            txtFrame.origin.y = seatFrame.origin.y;
        }
        else if(m_nSeatID == 2)
        {
            txtFrame.origin.x = [GUILayout GetMainUIWidth]-txtFrame.size.width;
            txtFrame.origin.y = seatFrame.origin.y;
        }
        else if(m_nSeatID == 3)
        {
            txtFrame.origin.x = 0;
            txtFrame.origin.y = seatFrame.origin.y;
        }
    }
    else
    {
        if(m_nSeatID == 0)
        {
            if([ApplicationConfigure iPhoneDevice])
            {    
                txtFrame.origin.x = seatFrame.origin.x;
                txtFrame.origin.y = 0;
            }
            else 
            {
                txtFrame.origin.x = seatFrame.origin.x+seatFrame.size.width-txtFrame.size.width;
                txtFrame.origin.y = seatFrame.origin.y;
            }
        }
        else if(m_nSeatID == 1)
        {
            if([ApplicationConfigure iPhoneDevice])
            {
                txtFrame.origin.x = [GUILayout GetMainUIWidth]-txtFrame.size.width;
                txtFrame.origin.y = 0;
            }
            else 
            {
                txtFrame.origin.x = seatFrame.origin.x;
                txtFrame.origin.y = seatFrame.origin.y;
            }
        }
        else if(m_nSeatID == 2)
        {
            if([ApplicationConfigure iPhoneDevice])
            {
                txtFrame.origin.x = [GUILayout GetMainUIWidth]-txtFrame.size.width;
                txtFrame.origin.y = [GUILayout GetMainUIHeight]-txtFrame.size.height;
            }
            else
            {    
                txtFrame.origin.x = seatFrame.origin.x;
                txtFrame.origin.y = seatFrame.origin.y;
            }    
        }
        else if(m_nSeatID == 3)
        {
            if([ApplicationConfigure iPhoneDevice])
            {    
                txtFrame.origin.x = seatFrame.origin.x;
                txtFrame.origin.y = [GUILayout GetMainUIHeight]-txtFrame.size.height;
            }
            else 
            {
                txtFrame.origin.x = seatFrame.origin.x+seatFrame.size.width-txtFrame.size.width;
                txtFrame.origin.y = seatFrame.origin.y;
            }
        }
    }
    [m_OnLineTextBoard setFrame:txtFrame];
    [m_OnlineTextPost setFrame:txtFrame];
    [m_OnLineTextBoard UpdateViewLayout];
    [m_OnlineTextPost UpdateViewLayout];
}

-(void)IntializePlayerInfo:(NSString*) szName withID:(NSString*)szID inSeat:(int)SeatID isMyself:(BOOL)bMyself inLobby:(id<GameControllerDelegate>)pController
{
    m_PlayerName = [szName copy];
    m_PlayerID = [szID copy];
    m_bMyself = bMyself;
    
    m_GameController = pController;
    m_nSeatID = SeatID;
    [self IntializeAdornments];
}

-(void)SetupPacket:(int)nChips
{
    [m_Packet Initialize:nChips];
}

-(BOOL)IsMyself
{
    return m_bMyself;
}

-(void)SetPlayerName:(NSString*)szName
{
    m_PlayerName = [szName copy];
    if(m_OnlinePlayerNameTag && m_bOnlinePlayer)
    {
        [m_OnlinePlayerNameTag setText:m_PlayerName];
        if([self IsMyself])
            [m_OnlinePlayerNameTag setText:[StringFactory GetString_OfflineMySelfID]];
        
        
        if([self IsActivated])
            m_OnlinePlayerNameTag.hidden = NO;
        else
            m_OnlinePlayerNameTag.hidden = YES;
    }
}

-(void)SetPlayerID:(NSString*)szPlayerID
{
    m_PlayerID = [szPlayerID copy];
}

-(void)SetMySelfFlag:(BOOL)bMyself
{
    m_bMyself = bMyself;
    if(m_OnlinePlayerNameTag && m_bOnlinePlayer)
    {
        if([self IsMyself])
        {    
            [m_OnlinePlayerNameTag setText:[StringFactory GetString_OfflineMySelfID]];
            [m_OnlinePlayerNameTag setTextColor:[UIColor blueColor]];
        }    
        else
        {
            [m_OnlinePlayerNameTag setTextColor:[UIColor yellowColor]];
            if(m_PlayerName)
                [m_OnlinePlayerNameTag setText:m_PlayerName];
            else
                [m_OnlinePlayerNameTag setText:@""];
        }
    }
}

-(NSString*)GetPlayerName
{
    return m_PlayerName;
}


-(BOOL)IsMyTurn
{
    //?????????????????????????
    return m_bMyturn2Play;
}

-(BOOL)WinThisTime
{
    //?????????????????????????
    return m_bWinThisPlay;
}

-(void)SetPlayResult:(BOOL)bWin
{
    m_bWinThisPlay = bWin;
    if(m_MySeat)
        [m_MySeat SetGameResult:m_bWinThisPlay];
}

-(int)GetSeatID
{
    return m_nSeatID;
}

-(CGRect)GetSeatBound
{
    if(m_MySeat)
        return m_MySeat.frame;
    else
        return CGRectZero;
}

-(void)OnTimerEvent
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_MySeat != nil)
        [m_MySeat OnTimerEvent];
    if(m_PopupMenu && m_PopupMenu.hidden == NO)
        [m_PopupMenu OnTimerEvent];
    
    if([m_OnLineTextBoard IsOpened])
    {
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(ONLINE_GAME_MESSAGE_DISPLAY_TIMELINE <= (currentTime - m_MessageUIStartTime))
        {
            [m_OnLineTextBoard CloseView:YES];
        }    
    }
    if([m_OnlineTextPost IsOpened] && [m_OnlineTextPost IsEditing])
    {
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(ONLINE_GAME_MESSAGE_DISPLAY_TIMELINE*4 <= (currentTime - m_MessageUIStartTime))
        {
            [m_OnlineTextPost CloseView:YES];
        }    
    }
}

-(void)ChangeWinFlyerState
{
    if(m_GameController != nil)
    {    
        int nState = [m_GameController GetGameState];
        if(nState == GAME_STATE_RESULT && [self WinThisTime])
        {
            [m_WinFlyer StartAnimation];
        }
        else
        {  
            if([m_WinFlyer IsActive])
                [m_WinFlyer StopAnimation];
        }
    }    
}

-(void)GameStateChange
{
    if([self IsEnabled])
    {   
        [m_MySeat SetEnable:YES];
        [self ChangeWinFlyerState];
    }
    else
    {
        if([m_WinFlyer IsActive])
            [m_WinFlyer StopAnimation];
        [m_MySeat SetEnable:NO];
    }
    [m_MySeat setNeedsDisplay];
}

-(void)DrawIndicators:(CGContextRef)context
{
    CGRect frameRT = m_MySeat.frame;
    float sx = frameRT.origin.x;
    float sy = frameRT.origin.y+frameRT.size.height;
    float fsize = frameRT.size.width/2.0;
    CGRect rt = CGRectMake(sx, sy, fsize, fsize);
    [m_BetLight DrawIndicator:context at:rt];
    sx += fsize;
    rt = CGRectMake(sx, sy, fsize, fsize);
    [m_ChoiceLight DrawChoice:context at:rt];
}

-(void)DrawCrossSign:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 0.5);
    CGRect frameRT = m_MySeat.frame;
    float fsize = frameRT.size.width*0.3;
    float sx = frameRT.origin.x+(frameRT.size.width-fsize)/2.0;
    float sy = frameRT.origin.y+frameRT.size.height;
    CGRect rt = CGRectMake(sx, sy, fsize, fsize);
    [RenderHelper DrawCrossSign:context at:rt];
    CGContextRestoreGState(context);
}

-(void)Draw:(CGContextRef)context
{
    if(m_bAcitvated == NO)
        return;
    
    if([self IsEnabled])
        [self DrawIndicators:context];
    else
        [self DrawCrossSign:context];
}

-(BOOL)CanPlayGame:(int)nType
{
    BOOL bRet = NO;
    if(m_Packet != nil)
    {    
        int nChips = [m_Packet Balance];
        switch (nType) 
        {
            case GAME_TYPE_8LUCK:
                if(GAME_BET_THRESHOLD_8LUCK <= nChips)
                    bRet = YES;
                break;
            case GAME_TYPE_6LUCK:
                if(GAME_BET_THRESHOLD_6LUCK <= nChips)
                    bRet = YES;
                break;
            case GAME_TYPE_4LUCK:
                if(GAME_BET_THRESHOLD_4LUCK <= nChips)
                    bRet = YES;
                break;
            case GAME_TYPE_2LUCK:
                if(GAME_BET_THRESHOLD_2LUCK <= nChips)
                    bRet = YES;
                break;
        }
    }
    return bRet;
}

-(BOOL)IsEnabled
{
    if(m_bAcitvated == NO)
        return NO;
    
    return m_bEnablePlayCurrentGame;
}

-(void)UpdateCurrentGamePlayablity
{
    if(m_GameController)
    {
        int nType = [m_GameController GetGameType];
        m_bEnablePlayCurrentGame = [self CanPlayGame:nType];
        [m_MySeat SetEnable:m_bEnablePlayCurrentGame];
        [self ClearPlayBet];
        if([self IsMyself] == YES && m_bEnablePlayCurrentGame == NO)
        {
            [GUIEventLoop SendEvent:GUIID_EVENT_ENABLEADBANNERVIEW eventSender:self];
        }
    }
}

-(void)SetMyTurn:(BOOL)bMyTurn
{
    m_bMyturn2Play = bMyTurn;
    [m_MySeat SetyActivePlayer:m_bMyturn2Play];
}

-(int)GetPacketBalance
{
    return [m_Packet Balance];
}

-(int)AddMoneyToPacket:(int)nChips
{
    [m_Packet Earn:nChips];
    int nRet = [m_Packet Balance];
    return nRet;
}

-(int)GenerateAutoOffLineBetLuckNumber:(int)nType
{
    int nRet = -1;
    if(m_bAcitvated == NO)
        return nRet;
    
    int nRand = [GameUitltyHelper CreateRandomNumberWithSeed:(m_nSeatID+1)];//[GameUitltyHelper CreateRandomNumber];
    int nThreshold = [GameUitltyHelper GetGameLuckNumberThreshold:nType];
    nRet = nRand%nThreshold + 1;
    return nRet;
}

-(int)GenerateAutoOffLineBetPledge:(int)nType
{
    int nRet = -1;
    if(m_bAcitvated == NO)
        return nRet;
        
    if(m_Packet)
    {    
        int nRand = [GameUitltyHelper CreateRandomNumberWithSeed:(m_nSeatID+1)];//[GameUitltyHelper CreateRandomNumber];
        int nThreshold = [GameUitltyHelper GetGameBetPledgeThreshold:nType];
        int nBalance = [m_Packet Balance];
        int nDiff = nBalance - nThreshold;
        if(nDiff < 0)
            return nBalance;
        
        //nDiff = nDiff%nThreshold + 1; 
        //if(nDiff == 0)
        //    return nBalance;
        
        nRet = nThreshold + nRand%nThreshold;
    }
    return nRet;
}

-(CPinActionLevel*)GenerateAutoOffLineAction
{
    CPinActionLevel* action = [[CPinActionLevel alloc] initRandomLevel];
    return action;
}

-(void)MakePlayBet:(int)nLuckNumber withPledge:(int)nBetPledge
{
    m_nChoiceNumber = nLuckNumber; 
    m_nBetMoney = [m_Packet Pay:nBetPledge];
    [m_BetLight SetBet:m_nBetMoney];
    [m_BetLight HideBet];
    [m_ChoiceLight SetChoice:m_nChoiceNumber];
    [m_ChoiceLight HideChoice];
}

-(BOOL)AlreadyMadePledge
{
    BOOL bRet = (-1 < m_nChoiceNumber && -1 < m_nBetMoney);
    return bRet;
}

-(void)ShowPlayBet
{
    [m_BetLight ShowBet];
    [m_ChoiceLight ShowChoice];
}

-(void)ClearPlayBet
{
    m_nChoiceNumber = -1; 
    m_nBetMoney = -1;
    [m_BetLight ClearBet];
    [m_ChoiceLight ClearChoice];
}

-(int)GetPlayBetLuckNumber
{
    return m_nChoiceNumber;
}

-(int)GetPlayBet
{
    return m_nBetMoney;
}

-(void)SetReleaseVersion:(int)nVersion
{
    m_nReleaseVersion = nVersion;
}

-(int)GetReleaseVersion
{
    return m_nReleaseVersion;
}

-(BOOL)CanProcessMoneyTransfer
{
    BOOL bRet = NO;
    if(m_nReleaseVersion == APPLICATION_RELEASE_VERSION_ONE)
        bRet = NO;
    
    return bRet;
}

-(void)SetOnlinePlayingState:(int)nState
{
    m_nOnlinePlayingState = nState;
    if(m_nOnlinePlayingState == GAME_ONLINE_PLAYER_STATE_RESET && [m_GameController GetGameState] == GAME_STATE_RESET)
    {    
        [self UpdateOnlinePlayingStateByMoneyBalance];
    }    
    [self GameStateChange];
}

-(int)GetOnlinePlayingState
{
    return m_nOnlinePlayingState;
}

-(void)UpdateOnlinePlayingStateByMoneyBalance
{
    [self UpdateCurrentGamePlayablity];
    //if(m_bEnablePlayCurrentGame)
    //    m_nOnlinePlayingState = GAME_PLAYER_STATE_NORMAL;
    //else
    //    m_nOnlinePlayingState = GAME_PLAYER_STATE_SUSPEND;
}

-(NSString*)GetPlayerID
{
    return m_PlayerID;
}

-(void)SetSeatID:(int)nSeatID
{
    m_nSeatID = nSeatID;
    if(m_MySeat)
        [m_MySeat SetSeatID:nSeatID];
    if(m_BetLight)
        [m_BetLight SetSeatID:m_nSeatID];
    if(m_BetLight)
        [m_ChoiceLight SetSeatID:m_nSeatID];
    [self UpdateLayout];
}


-(void)CancelPendingBet
{
    if(0 <= m_nBetMoney)
    {    
        [m_Packet Earn:m_nBetMoney];
    }    
    [self ClearPlayBet];
}

//Popup menu events
-(void)ForceClosePopupMenu
{
    if(m_PopupMenu.hidden == NO)
    {
        [m_PopupMenu CloseMenu];
    }
}

-(void)RegisterPopupMenuEvent
{
    if(m_GameController && [m_GameController IsOnline] == NO)
    {
        [self RegisterOfflinePopupMenuEvent];
    }
}

-(void)RegisterOfflinePopupMenuEvent
{
    switch(m_nSeatID)
    {
        case 0:
            [self RegisterOfflinePopupMenuEventMe];
            break;
        case 1:
            [self RegisterOfflinePopupMenuEventPlayer1];
            break;
        case 2:
            [self RegisterOfflinePopupMenuEventPlayer2];
            break;
        case 3:
            [self RegisterOfflinePopupMenuEventPlayer3];
            break;
    }
        
}

-(void)RegisterOfflinePopupMenuEventMe
{
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUPMENU_ME eventHandler:@selector(OnOpenOfflinePopupMenuMe) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_ME_CHIP eventHandler:@selector(OnOfflineMeMoneyBalance) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_ME_EARN eventHandler:@selector(OnOfflineMeClickToEarn) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_ME_TRANSACTION eventHandler:@selector(OnOfflineMeSendMenoy) eventReceiver:self eventSender:nil];
}

-(void)RegisterOfflinePopupMenuEventPlayer1
{
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUPMENU_PLAYER1 eventHandler:@selector(OnOpenOfflinePopupMenuPlayer1) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER1_CHIP eventHandler:@selector(OnOfflinePlayer1MoneyBalance) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER1_EARN eventHandler:@selector(OnOfflinePlayer1ClickToEarn) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER1_TRANSACTION eventHandler:@selector(OnOfflinePlayer1SendMenoy) eventReceiver:self eventSender:nil];
}

-(void)RegisterOfflinePopupMenuEventPlayer2
{
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUPMENU_PLAYER2 eventHandler:@selector(OnOpenOfflinePopupMenuPlayer2) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER2_CHIP eventHandler:@selector(OnOfflinePlayer2MoneyBalance) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER2_EARN eventHandler:@selector(OnOfflinePlayer2ClickToEarn) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER2_TRANSACTION eventHandler:@selector(OnOfflinePlayer2SendMenoy) eventReceiver:self eventSender:nil];
}

-(void)RegisterOfflinePopupMenuEventPlayer3
{
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUPMENU_PLAYER3 eventHandler:@selector(OnOpenOfflinePopupMenuPlayer3) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER3_CHIP eventHandler:@selector(OnOfflinePlayer3MoneyBalance) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER3_EARN eventHandler:@selector(OnOfflinePlayer3ClickToEarn) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_OFFLINE_POPUP_PLAYER3_TRANSACTION eventHandler:@selector(OnOfflinePlayer3SendMenoy) eventReceiver:self eventSender:nil];
}

-(void)OnOpenOfflinePopupMenuMe
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 0)
        return;
    
    [m_PopupMenu OpenMenu];
    [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_ME_CHIP withLabel:[StringFactory GetString_Chips]];
    if([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET)
    {
        [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_ME_EARN withLabel:[StringFactory GetString_Earn]];
        if(0 < [self GetPacketBalance])
        {
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_ME_TRANSACTION withLabel:[StringFactory GetString_SendMoney]];
        }
    }
}

-(void)OnOpenOfflinePopupMenuPlayer1
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 1)
        return;
    [m_PopupMenu OpenMenu];
    [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER1_CHIP withLabel:[StringFactory GetString_Chips]];
    if([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET)
    {
        if(![ApplicationConfigure EarnChipFromInApp])
        {    
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER1_EARN withLabel:[StringFactory GetString_Earn]];
        }    
        if(0 < [self GetPacketBalance])
        {
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER1_TRANSACTION withLabel:[StringFactory GetString_SendMoney]];
        }
    }
}

-(void)OnOpenOfflinePopupMenuPlayer2
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 2)
        return;
    
    [m_PopupMenu OpenMenu];
    [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER2_CHIP withLabel:[StringFactory GetString_Chips]];
    if([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET)
    {
        if(![ApplicationConfigure EarnChipFromInApp])
        {    
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER2_EARN withLabel:[StringFactory GetString_Earn]];
        }    
        if(0 < [self GetPacketBalance])
        {
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER2_TRANSACTION withLabel:[StringFactory GetString_SendMoney]];
        }
    }
}

-(void)OnOpenOfflinePopupMenuPlayer3
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 3)
        return;
    
    [m_PopupMenu OpenMenu];
    [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER3_CHIP withLabel:[StringFactory GetString_Chips]];
    if([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET)
    {
        if(![ApplicationConfigure EarnChipFromInApp])
        {    
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER3_EARN withLabel:[StringFactory GetString_Earn]];
        }    
        if(0 < [self GetPacketBalance])
        {
            [m_PopupMenu AddMenuItem:GUIID_EVENT_OFFLINE_POPUP_PLAYER3_TRANSACTION withLabel:[StringFactory GetString_SendMoney]];
        }
    }
}

-(void)OnOfflineMeMoneyBalance
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 0)
        return;
    
    [m_PopupMenu CloseMenu];
    [m_MySeat ShowBalanceView];
}

-(void)OnOfflineMeClickToEarn
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 0)
        return;
    [m_PopupMenu CloseMenu];
    if(m_GameController && ([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET))
        [m_GameController OpenRedeemViewForPlayer:m_nSeatID];
}

-(void)OnOfflineMeSendMenoy
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 0)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController)
        [m_GameController MakePlayerTransaction:m_nSeatID];
}

-(void)OnOfflinePlayer1MoneyBalance
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 1)
        return;
    
    [m_PopupMenu CloseMenu];
    [m_MySeat ShowBalanceView];
}

-(void)OnOfflinePlayer1ClickToEarn
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 1)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController && ([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET))
        [m_GameController OpenRedeemViewForPlayer:m_nSeatID];
}

-(void)OnOfflinePlayer1SendMenoy
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 1)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController)
        [m_GameController MakePlayerTransaction:m_nSeatID];
}

-(void)OnOfflinePlayer2MoneyBalance
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 2)
        return;
    
    [m_PopupMenu CloseMenu];
    [m_MySeat ShowBalanceView];
}

-(void)OnOfflinePlayer2ClickToEarn
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 2)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController && ([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET))
        [m_GameController OpenRedeemViewForPlayer:m_nSeatID];
}

-(void)OnOfflinePlayer2SendMenoy
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 2)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController)
        [m_GameController MakePlayerTransaction:m_nSeatID];
}

-(void)OnOfflinePlayer3MoneyBalance
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 3)
        return;
    
    [m_PopupMenu CloseMenu];
    [m_MySeat ShowBalanceView];
}

-(void)OnOfflinePlayer3ClickToEarn
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 3)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController && ([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET))
        [m_GameController OpenRedeemViewForPlayer:m_nSeatID];
}

-(void)OnOfflinePlayer3SendMenoy
{
    if(m_bAcitvated == NO)
        return;
    
    if(m_nSeatID != 3)
        return;
    
    [m_PopupMenu CloseMenu];
    if(m_GameController)
        [m_GameController MakePlayerTransaction:m_nSeatID];
}

-(void)OnMenuEvent:(int)nEventID
{
    if(m_bAcitvated == NO)
        return;
    
    [m_PopupMenu CloseMenu];
    
    switch(nEventID)
    {
        case GUIID_EVENT_ONLINE_POPUPMENU_CHIP:
            [self OnOnLineChipBalance];
            break;
        case GUIID_EVENT_ONLINE_POPUPMENU_EARN:
            [self OnOnLineEarnChipBalance];
            break;
        case GUIID_EVENT_ONLINE_POPUPMENU_TRANSACTION:
            [self OnOnLineSendMoney];
            break;
        case GUIID_EVENT_ONLINE_POPUPMENU_MESSAGE:
            [self OnOnLinePlayerMessage];
            break;
        case GUIID_EVENT_ONLINE_POPUPMENU_LOCATION:
            [self OnOnLinePlayerLocation];
            break;
    }
}

-(void)OnMsgBoardClose
{
    
}
@end
