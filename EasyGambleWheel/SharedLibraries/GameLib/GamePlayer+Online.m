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
#import "GamePlayer+Online.h"
#import "GUILayout.h"
#import "ApplicationConfigure.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "RenderHelper.h"
#import "StringFactory.h"
#include "drawhelper.h"

@implementation GamePlayer (Online) 

-(void)LoadAppleGameCenterPlayerImage:(GKPlayer*)gkPlayer
{
    if(m_CachedGKMatchPlayer != nil)
    {    
        m_CachedGKMatchPlayer = nil;
    }    
    m_CachedGKMatchPlayer = gkPlayer;
    if(m_CachedGKMatchPlayer != nil)
    {
        GKPhotoSize imgSize = GKPhotoSizeSmall;
        if(1.0 < [ApplicationConfigure GetCurrentDisplayScale])
            imgSize = GKPhotoSizeNormal;
        [m_CachedGKMatchPlayer loadPhotoForSize:imgSize withCompletionHandler:^(UIImage *photo, NSError *error) 
        {
            if(error)
            {
                NSLog(@"GamePlayer LoadAppleGameCenterPlayerImage is failed for %@", [error localizedDescription]);
                return;
            }
            if(photo && photo.CGImage && m_MySeat && (0 < photo.size.width && 0 < photo.size.height))
            {
                [m_MySeat SetOnlineAvatarImage:CloneImage(photo.CGImage, true)];
                [m_MySeat setNeedsDisplay];
            }
        }];
    }
}

-(void)SetCachedTransferedChipNumber:(int)nCachedSentChips
{
    m_nCachedTransferedChip = nCachedSentChips;
}


-(void)SetGKCenterMaster:(BOOL)bGKMaster
{
    m_bGKCenterMaster = bGKMaster;
}

-(BOOL)IsGKCenterMaster
{
    return m_bGKCenterMaster;
}

-(void)SetPlayerOnlineStatus:(BOOL)bOnlinePlayer
{
    m_bOnlinePlayer = bOnlinePlayer;
    if(m_MySeat != nil)
    {
        [m_MySeat SetPlayerOnlineStatus:bOnlinePlayer];
    }
    if(m_OnlinePlayerNameTag)
    {
        if(!bOnlinePlayer || ![self IsActivated])
            m_OnlinePlayerNameTag.hidden = YES;
        else    
        {    
            m_OnlinePlayerNameTag.hidden = NO;
            if(m_PlayerName)
                [m_OnlinePlayerNameTag setText:m_PlayerName];
            if([self IsMyself])
                [m_OnlinePlayerNameTag setText:[StringFactory GetString_OfflineMySelfID]];
        }    
    }
}

-(BOOL)IsOnlinePlayer
{
    return m_bOnlinePlayer;
}

-(void)OpenOnlinePopupMenuMe
{
    if(m_bAcitvated == NO)
        return;
    
    if(![self IsMyself])
        return;
    
    [m_PopupMenu OpenMenu];
  
    [m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_CHIP withLabel:[StringFactory GetString_Chips] withDelegate:self];
    if([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET)
    {
        [m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_EARN withLabel:[StringFactory GetString_Earn] withDelegate:self];
        [m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_TRANSACTION withLabel:[StringFactory GetString_SendMoney] withDelegate:self];
    }    
    [m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_MESSAGE withLabel:[StringFactory GetString_Message] withDelegate:self];
    //[m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_LOCATION withLabel:[StringFactory GetString_Location] withDelegate:self];
}

-(void)OpenOnlinePopupMenuOther
{
    if(m_bAcitvated == NO)
        return;
    
    if([self IsMyself])
        return;
    
    [m_PopupMenu OpenMenu];
    [m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_CHIP withLabel:[StringFactory GetString_Chips] withDelegate:self];
    [m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_MESSAGE withLabel:[StringFactory GetString_Message] withDelegate:self];
    //[m_PopupMenu AddOnlinePlayerMenuItem:GUIID_EVENT_ONLINE_POPUPMENU_LOCATION withLabel:[StringFactory GetString_Location] withDelegate:self];
    
}

-(void)OpenOnlinePopupMenu
{
    if([self IsMyself])
    {
        [self OpenOnlinePopupMenuMe];
    }
    else
    {    
        [self OpenOnlinePopupMenuOther];
    }
}

-(void)OnOnLineChipBalance
{
    [m_MySeat ShowBalanceView];
}

-(void)OnOnLineEarnChipBalance
{
    if([self IsMyself])
    {
        if(m_GameController && ([m_GameController GetGameState] == GAME_STATE_READY || [m_GameController GetGameState] == GAME_STATE_RESET))
            [m_GameController OpenRedeemViewForPlayer:m_nSeatID];
    }
}

-(void)OnOnLineSendMoney
{
    if(m_GameController && [self IsMyself])
        [m_GameController MakePlayerTransaction:m_nSeatID];
}

-(void)OnOnLinePlayerMessage
{
    m_MessageUIStartTime = [[NSProcessInfo processInfo] systemUptime];
    if(!m_bMyself)
    {
        if(![m_OnLineTextBoard IsOpened])
            [m_OnLineTextBoard OpenView:YES];
    }
    else 
    {
        if(![m_OnlineTextPost IsOpened])
        {
            [self UpdateLayout];
            [m_OnlineTextPost CleanTextMessage];
            [m_OnlineTextPost OpenView:YES];
        }    
    }
}

-(void)OnOnLinePlayerLocation
{
    
}

-(NSString*)GetMyOnlineTextMessage
{
    NSString* szEmpty = @"";
    
    if(m_OnlineTextPost && [m_OnlineTextPost HasTextMessage])
        return [m_OnlineTextPost GetTextMessage];
    
    return szEmpty;
}

-(void)ShowOnlineMessage:(NSString*)szText
{
    if(!m_bMyself)
    {
        [m_PopupMenu CloseMenu];
        [m_MySeat CloseBalanceView];
        m_MessageUIStartTime = [[NSProcessInfo processInfo] systemUptime];
        [m_OnLineTextBoard SetTextMessage:szText];
        if(![m_OnLineTextBoard IsOpened])
            [m_OnLineTextBoard OpenView:YES];
    }
}

-(void)ShowBalance
{
    [m_PopupMenu CloseMenu];
    if(![m_OnLineTextBoard IsOpened])
        [m_OnLineTextBoard CloseView:YES];
    if(![m_OnlineTextPost IsOpened])
        [m_OnlineTextPost CloseView:YES];
    [m_MySeat ShowBalanceView];
}

@end
