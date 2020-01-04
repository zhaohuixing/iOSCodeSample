//
//  DealView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-16.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#include "stdinc.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GameView.h"
#import "GUILayout.h"
#import "GlossyMenuItem.h"
#import "MultiChoiceGlossyMenuItem.h"
#import "ImageLoader.h"
#import "StringFactory.h"
#import "NSData-Base64.h"
#import "UIDevice-Reachability.h"
#import "GameLayout.h"
#import "GameConfiguration.h"
#import "GameScore.h"
#import "ApplicationController.h"
#import "CustomModalAlertView.h"

@implementation GameView

- (void)CleanBubbleCheckState
{
    if(m_GameBoard && m_bShowQMark == YES)
    {    
        m_bShowQMark = NO;
        [m_GameBoard CleanBubbleCheckState];
    }
    
}

-(BOOL)IsEasyAnimation
{
    BOOL bRet = NO;
    
    if(m_GameBoard)
    {
        bRet = [m_GameBoard IsEasyAnimation];
    }
    
    return bRet;
}


- (void)UpdatePlayStepLabel
{
    int n = [GameConfiguration GetPlaySteps];
    NSString* str = [NSString stringWithFormat:@"%i", n];
    [m_PlaysLabel setText:str];
}

- (void)OnPlayStepChanged:(id)sender
{
    [self CleanBubbleCheckState];
    [self UpdatePlayStepLabel];
}

- (void)OnWizardClosed:(id)sender
{
    [self CleanBubbleCheckState];
	
    if(m_Menu && m_bMenuAnimtation == NO)
	{	
		if(m_bMenuShow == YES)
		{
            m_bMenuAnimtation = YES;
			[m_Menu Hide];
		}	
		else 
        {
            if([GameConfiguration IsDirty])
            {
                int nLevel = 0;
                if([GameConfiguration IsGameDifficulty])
                    nLevel = 1;
                [GameScore SetDefaultConfigure:(int)[GameConfiguration GetGridType] withLayout:(int)[GameConfiguration GetGridLayout] withEdge:[GameConfiguration GetBubbleUnit] withLevel:nLevel withBubble:(int)[GameConfiguration GetBubbleType] withGameType:[GameConfiguration GetGameType]];
                [GUIEventLoop SendEvent:GUIID_EVENT_CONFIGURECHANGE eventSender:self];
                [self StartNewGame:NO];
            }
            else if([m_GameBoard IsWinAnimation] == YES)
            {
                [self StartNewGame:NO];
            }
            
        }
		[self setNeedsDisplay];
	}
}

- (void)OnFileListClosed
{
    [self CleanBubbleCheckState];
	
    if(m_Menu && m_bMenuAnimtation == NO)
	{	
		if(m_bMenuShow == YES)
		{
            m_bMenuAnimtation = YES;
			[m_Menu Hide];
		}	
		else 
        {
            //???????????????????????????????
            //??????????????????????????????
            //???????????????????????????????
            //??????????????????????????????
            [self StartNewGame:YES];
        }
		[self setNeedsDisplay];
	}
}

- (void)UndoButtonClick
{
    if([ApplicationConfigure GetAdViewsState] == YES && [UIDevice networkAvailable] == NO && [StringFactory IsNeedToCareLang] == YES)
    {
        NSString* str = [StringFactory GetString_NetworkWarn];
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
    
    if([self IsEasyAnimation])
        return;
    
    [self CleanBubbleCheckState];
    
    if([self IsUIEventLocked])
        return;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;
    
    [self UndoGame];
}

- (void)ResetButtonClick
{
    if([ApplicationConfigure GetAdViewsState] == YES && [UIDevice networkAvailable] == NO && [StringFactory IsNeedToCareLang] == YES)
    {
        NSString* str = [StringFactory GetString_NetworkWarn];
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
    
    if([self IsEasyAnimation])
        return;
    
    [self CleanBubbleCheckState];
    
    if([self IsUIEventLocked])
        return;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;
    
    [self ResetGame];
}

- (void)NextButtonClick
{
    [self CleanBubbleCheckState];
    
    if([self IsUIEventLocked])
        return;
  
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;
    
    if([m_GameBoard IsWinAnimation] == YES)
    {
        id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
        if(pGKDelegate && [UIDevice networkAvailable] == YES)
        {
            if ([CustomModalAlertView Ask:nil withButton1:[StringFactory GetString_Cancel] withButton2:[StringFactory   GetString_PostGameScore]] == ALERT_OK)
            {
                [pGKDelegate PostCurrentGameScoreOnline];
            }
        }
    }
    
    int nRet = [CustomModalAlertView Ask:[StringFactory GetString_SaveFileComfirmation] withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
    
    if(nRet == ALERT_NO)
    {
        [self StartNewGame:NO];
    }    
    else
    {    
        [self SaveCurrentGameToFile];
    }    
}

- (void)SystemButtonClick
{
    if([self IsEasyAnimation])
        return;
    
    [self CleanBubbleCheckState];

	if(m_Menu && m_bMenuAnimtation == NO)
	{	
		m_bMenuAnimtation = YES;
		if(m_bMenuShow == NO)
		{
            m_Overlay.hidden = NO;
            [self bringSubviewToFront:m_Overlay];
            [self bringSubviewToFront:m_NextButton];
            [self bringSubviewToFront:m_SystemButton];
            [self bringSubviewToFront:m_UndoButton];
            [self bringSubviewToFront:m_ResetButton];
            [self bringSubviewToFront:m_CheckButton];
            int nCount = [m_Menu GetMenuItemCount];
            if(0 < nCount)
            {
                for(int i = 0; i < nCount; ++i)
                {
                    [self bringSubviewToFront:((UIView*)[m_Menu GetMenuItemAt:i])];
                }	
            }	
            
            m_bMenuShow = YES;
			[m_Menu Show];
		}	
		else
		{
			[m_Menu Hide];
		}	
		
		[self setNeedsDisplay];
	}	
}

-(void)ResetSate
{
	if(m_Menu && m_bMenuAnimtation == NO)
	{	
		if(m_bMenuShow == YES)
		{
            m_bMenuAnimtation = YES;
			[m_Menu Hide];
		}
        else
        {
            [self StartNewGame:NO];
        }
	}
}

-(void)CheckButtonClick
{
    if([ApplicationConfigure GetAdViewsState] == YES && [UIDevice networkAvailable] == NO && [StringFactory IsNeedToCareLang] == YES)
    {
        NSString* str = [StringFactory GetString_NetworkWarn];
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
 
    if([self IsEasyAnimation])
        return;
    
    
    if([self IsUIEventLocked])
        return;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;
    
    if(m_GameBoard && m_bShowQMark == NO)
    {    
        ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];

        if(pController && [pController GetFileManager])
        {
            if([pController GetFileManager].m_PlayingFile && [[pController GetFileManager].m_PlayingFile IsValid] /*&& ![[pController GetFileManager].m_PlayingFile CurrentDocumentIsCacheFile]*/)
            {
                if([pController GetFileManager].m_PlayingFile.m_PlayRecordList && 0 < [[pController GetFileManager].m_PlayingFile CompletedGamePlaysNumber])
                {    
                    [GUIEventLoop SendEvent:GUIID_EVENT_OPENPLAYHELPVIEW eventSender:self];
                    return;
                }    
            }    
        }

        m_bShowQMark = YES;
        [m_GameBoard CheckBubbleState];
        if([GameConfiguration IsGameDifficulty] == NO)
        {
            [m_GameBoard StartEasyAnimation:-1];
        }
    }
    else
    {
        [self CleanBubbleCheckState];
    }
}

-(void)WizardButtonClick
{
    if([ApplicationConfigure GetAdViewsState] == YES && [UIDevice networkAvailable] == NO && [StringFactory IsNeedToCareLang] == YES)
    {
        NSString* str = [StringFactory GetString_NetworkWarn];
        [CustomModalAlertView SimpleSay:str closeButton:[StringFactory GetString_Close]];
    }
    if([self IsEasyAnimation])
        return;
    
    [self CleanBubbleCheckState];
    
    if([self IsUIEventLocked])
        return;
    
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES)
        return;
    
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventSender:self];
}


- (void)SetCurrentConfiguration
{
    enGameType enPlayType = (enGameType)[GameScore GetDefaultGame];
    enGridType enType = (enGridType)[GameScore GetDefaultType];
    enGridLayout enLayout = (enGridLayout)[GameScore GetDefaultLayout];
    int nEdge = [GameScore GetDefaultEdge];
    int nLevel = [GameScore GetDefaultLevel];
    if([ApplicationConfigure GetAdViewsState] == YES && enType != PUZZLE_GRID_TRIANDLE)
    {
        int nMinEdge = [GameConfiguration GetMinBubbleUnit:enType];
        if(nMinEdge < nEdge)
            nEdge = nMinEdge;
        //enType = PUZZLE_GRID_TRIANDLE;
    }
    [GameConfiguration SetGameType:enPlayType];
    [GameConfiguration SetGridType:enType];
    [GameConfiguration SetGridLayout:enLayout];

    [GameConfiguration SetBubbleType:(enBubbleType)[GameScore GetDefaultBubble]];
    if(nLevel == 0)
        [GameConfiguration SetGameDifficulty:NO];
    else
        [GameConfiguration SetGameDifficulty:YES];
    
    if([GameConfiguration GetMaxBubbleUnit:enType] < nEdge)
        nEdge = [GameConfiguration GetMaxBubbleUnit:enType];
    if(nEdge < [GameConfiguration GetMinBubbleUnit:enType])
        nEdge = [GameConfiguration GetMinBubbleUnit:enType];
    
    [GameConfiguration SetBubbleUnit:nEdge];
    [GameConfiguration RecheckConfigureValidation];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
     
        [self SetCurrentConfiguration];
        
        m_Overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_Overlay.backgroundColor = [UIColor lightGrayColor];
        [m_Overlay setAlpha:0.6];
        [self addSubview:m_Overlay];
        m_Overlay.hidden = YES;
        
        m_GameBoard = [[PlayBoard alloc] initWithFrame:[GameLayout GetPlayBoardRect]];
        [self addSubview:m_GameBoard];
        [m_GameBoard release];

        float fBtnSize = [GUILayout GetTitleBarHeight];
		CGRect rect = CGRectMake(0, 0, fBtnSize, fBtnSize);
		m_SystemButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_SystemButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_SystemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuicon.png"] forState:UIControlStateNormal];
		[m_SystemButton setBackgroundImage:[UIImage imageNamed:@"menuiconhi.png"] forState:UIControlStateHighlighted];
		[m_SystemButton addTarget:self action:@selector(SystemButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_SystemButton];

		//UIButton*				m_WizardButton
		rect = CGRectMake(fBtnSize+2.0, 0, fBtnSize, fBtnSize);
        m_WizardButton = [[UIButton alloc] initWithFrame:rect];
		// Set up the button aligment properties
		m_WizardButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_WizardButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_WizardButton setBackgroundImage:[UIImage imageNamed:@"wziardicon.png"] forState:UIControlStateNormal];
		[m_WizardButton setBackgroundImage:[UIImage imageNamed:@"wziardiconhi.png"] forState:UIControlStateHighlighted];
		[m_WizardButton addTarget:self action:@selector(WizardButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_WizardButton];
		[self bringSubviewToFront:m_WizardButton];
        
        
        
		rect = CGRectMake((fBtnSize+2)*2.0, 0, fBtnSize, fBtnSize);
        m_ResetButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_ResetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_ResetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_ResetButton setBackgroundImage:[UIImage imageNamed:@"previcon.png"] forState:UIControlStateNormal];
		[m_ResetButton setBackgroundImage:[UIImage imageNamed:@"previconhi.png"] forState:UIControlStateHighlighted];
		[m_ResetButton addTarget:self action:@selector(ResetButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_ResetButton];
		[self bringSubviewToFront:m_ResetButton];
        
		rect = CGRectMake((fBtnSize+2)*3.0, 0, fBtnSize, fBtnSize);
        m_NextButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_NextButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_NextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticon.png"] forState:UIControlStateNormal];
		[m_NextButton setBackgroundImage:[UIImage imageNamed:@"nexticonhi.png"] forState:UIControlStateHighlighted];
		[m_NextButton addTarget:self action:@selector(NextButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_NextButton];
		[self bringSubviewToFront:m_NextButton];
        
		rect = CGRectMake((fBtnSize+2)*4.0, 0, fBtnSize, fBtnSize);
        m_CheckButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_CheckButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_CheckButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_CheckButton setBackgroundImage:[UIImage imageNamed:@"qbutton.png"] forState:UIControlStateNormal];
		[m_CheckButton setBackgroundImage:[UIImage imageNamed:@"qbuttonhi.png"] forState:UIControlStateHighlighted];
		[m_CheckButton addTarget:self action:@selector(CheckButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_CheckButton];
		[self bringSubviewToFront:m_CheckButton];
        
		rect = CGRectMake((fBtnSize+2)*5.0, 0, fBtnSize, fBtnSize);
        m_UndoButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_UndoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_UndoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_UndoButton setBackgroundImage:[UIImage imageNamed:@"undoicon.png"] forState:UIControlStateNormal];
		[m_UndoButton setBackgroundImage:[UIImage imageNamed:@"undoiconhi.png"] forState:UIControlStateHighlighted];
		[m_UndoButton addTarget:self action:@selector(UndoButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_UndoButton];
		[self bringSubviewToFront:m_UndoButton];

		[self CreateMenu];
		
        float fSize = [GameLayout GetLayoutSignSize];
        rect = CGRectMake([GUILayout GetContentViewWidth]-fSize, 0, fSize, fSize);
        m_LayoutSign = [[FlagIconView alloc] initWithFrame:rect];
        [self addSubview:m_LayoutSign];
        [m_LayoutSign release];
       
      
        rect = CGRectMake((fBtnSize+2)*6.0, 0, 160, 30);
		m_PlaysLabel = [[UILabel alloc] initWithFrame:rect];
		m_PlaysLabel.backgroundColor = [UIColor clearColor];
		[m_PlaysLabel setTextColor:[UIColor redColor]];
		m_PlaysLabel.font = [UIFont fontWithName:@"Georgia" size:24];
        [m_PlaysLabel setTextAlignment:UITextAlignmentLeft];
        m_PlaysLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_PlaysLabel.adjustsFontSizeToFitWidth = YES;
		[m_PlaysLabel setText:@"0"];
		[self addSubview:m_PlaysLabel];
		[m_PlaysLabel release];
        
        [self bringSubviewToFront:m_SystemButton];
        m_bMenuAnimtation = NO;
        m_bFlagForHideAndPlay = NO;    
        [self UpdatePlayStepLabel];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_PLAYSTEPCHANGE eventHandler:@selector(OnPlayStepChanged:) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_WIZARDFINISHED eventHandler:@selector(OnWizardClosed:) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_FILELISTUICLOSED eventHandler:@selector(OnFileListClosed:) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_RESETEASYGAMESHUFFLE eventHandler:@selector(OnResetEasyShuffle:) eventReceiver:self eventSender:nil];
       
        [GUIEventLoop RegisterEvent:GUIID_EVENT_GOTONEXTGAMENOTIFICATION eventHandler:@selector(NextButtonClick) eventReceiver:self eventSender:nil];
        m_bShowQMark = NO;
	}
    return self;
}

- (void)CreateMenu
{
	if(m_Menu)
	{
        CGRect rect = CGRectMake(0, 0, [GUILayout GetGlossyMenuSize], [GUILayout GetGlossyMenuSize]);
    
        GlossyMenuItem*  menuLevel = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_CONFIGUREBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
        [menuLevel RegisterNormalImage:@"toolicon.png"];
        [menuLevel RegisterHighLightImage:@"tooliconhi.png"];
        [menuLevel SetGroundZero:CGPointMake(15, 15)];
        [menuLevel Reset];
        [self AddMenuItem:menuLevel];
        [GUIEventLoop RegisterEvent:GUIID_CONFIGUREBUTTON eventHandler:@selector(OnMenuSetting:) eventReceiver:self eventSender:self];

        GlossyMenuItem*  menuScoreHelp = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_SCOREHELPVIEWBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
        [menuScoreHelp RegisterNormalImage:@"helpicon2.png"];
        [menuScoreHelp RegisterHighLightImage:@"helpicon2.png"];
        [menuScoreHelp SetGroundZero:CGPointMake(15, 15)];
        [menuScoreHelp Reset];
        [self AddMenuItem:menuScoreHelp];
        [GUIEventLoop RegisterEvent:GUIID_SCOREHELPVIEWBUTTON eventHandler:@selector(OnMenuScoreView:) eventReceiver:self eventSender:self];
        
        MultiChoiceGlossyMenuItem*  menuBkgnd = [[[MultiChoiceGlossyMenuItem alloc] initWithMeueID:GUIID_BKGNDBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
        [menuBkgnd RegisterMenuImages:@"woodicon.png" withHigLight:@"woodiconhi.png"];
        [menuBkgnd RegisterMenuImages:@"greenicon.png" withHigLight:@"greeniconhi.png"];
        [menuBkgnd SetGroundZero:CGPointMake(15, 15)];
        [menuBkgnd Reset];
        [menuBkgnd SetActiveChoice:[GameConfiguration GetMainBackgroundType]%2];
        [self AddMenuItem:menuBkgnd];
        [GUIEventLoop RegisterEvent:GUIID_BKGNDBUTTON eventHandler:@selector(OnMenuBkGnd:) eventReceiver:self eventSender:self];
        
        GlossyMenuItem*  menuScore = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_SCOREBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
        [menuScore RegisterNormalImage:@"scoreicon.png"];
        [menuScore RegisterHighLightImage:@"scoreiconhi.png"];
        [menuScore SetGroundZero:CGPointMake(15, 15)];
        [menuScore Reset];
        [self AddMenuItem:menuScore];
        [GUIEventLoop RegisterEvent:GUIID_SCOREBUTTON eventHandler:@selector(OnMenuScore:) eventReceiver:self eventSender:self];
    
        GlossyMenuItem*  menuPost = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_POSTBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
        [menuPost RegisterNormalImage:@"posticon.png"];
        [menuPost RegisterHighLightImage:@"posticonhi.png"];
        [menuPost SetGroundZero:CGPointMake(15, 15)];
        [menuPost Reset];
        [self AddMenuItem:menuPost];
        [GUIEventLoop RegisterEvent:GUIID_POSTBUTTON eventHandler:@selector(OnMenuShare:) eventReceiver:self eventSender:self];
    
		GlossyMenuItem*  menuFriend = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_FRIENDBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
		[menuFriend RegisterNormalImage:@"friendicon.png"];
		[menuFriend RegisterHighLightImage:@"friendiconhi.png"];
		[menuFriend SetGroundZero:CGPointMake(15, 15)];
		[menuFriend Reset];
		[self AddMenuItem:menuFriend];
		[GUIEventLoop RegisterEvent:GUIID_FRIENDBUTTON eventHandler:@selector(OnMenuFriend:) eventReceiver:self eventSender:self];
        
        //if([ApplicationConfigure GetAdViewsState] == YES)
        if([GameScore CheckPaymentState] == NO)
        {
            GlossyMenuItem*  menuBuyIt = [[[GlossyMenuItem alloc] initWithMeueID:GUIID_PURCHASEBUTTON withFrame:rect withContainer:m_Menu]	autorelease];
            [menuBuyIt RegisterNormalImage:@"payicon.png"];
            [menuBuyIt RegisterHighLightImage:@"payicon.png"];
            [menuBuyIt SetGroundZero:CGPointMake(15, 15)];
            [menuBuyIt Reset];
            [self AddMenuItem:menuBuyIt];
            [GUIEventLoop RegisterEvent:GUIID_PURCHASEBUTTON eventHandler:@selector(OnMenuBuyIt:) eventReceiver:self eventSender:self];
        }
        [self UpdateMenuLayout];
    }  
}

-(void)OnMenuHide
{
	[super OnMenuHide];
	m_bMenuAnimtation = NO;
    [self sendSubviewToBack:m_Overlay];
    m_Overlay.hidden = YES;
    [self bringSubviewToFront:m_NextButton];
    [self bringSubviewToFront:m_SystemButton];
    [self setNeedsDisplay];
    [self.superview setNeedsDisplay];

    if(m_bFlagForHideAndPlay == YES)
    {
        m_bFlagForHideAndPlay = NO;
    }
    if([GameConfiguration IsDirty])
    {
        int nLevel = 0;
        if([GameConfiguration IsGameDifficulty])
            nLevel = 1;
        [GameScore SetDefaultConfigure:(int)[GameConfiguration GetGridType] withLayout:(int)[GameConfiguration GetGridLayout] withEdge:[GameConfiguration GetBubbleUnit]  withLevel:nLevel  withBubble:(int)[GameConfiguration GetBubbleType] withGameType:[GameConfiguration GetGameType]];
        [GUIEventLoop SendEvent:GUIID_EVENT_CONFIGURECHANGE eventSender:self];
        [self StartNewGame:NO];
    }
    else if([m_GameBoard IsWinAnimation] == YES)
    {
        //???????????????????????????????
        //??????????????????????????????
        [self StartNewGame:NO];
    }
    else 
    {
        //???????????????????????????????
        //??????????????????????????????
        //???????????????????????????????
        //??????????????????????????????
        //???????????????????????????????
        //??????????????????????????????
    }
}

-(void)OnMenuShow
{
	[super OnMenuShow];
	m_bMenuAnimtation = NO;
    [self setNeedsDisplay];
}	

-(void)OnMenuEvent:(int)menuID
{
	[GUIEventLoop SendEvent:menuID eventSender:self];
}	

-(void)OnMenuSetting:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENCONFIGUREVIEW eventSender:self];
}

-(void)OnMenuScoreView:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENSCOREHELPVIEW eventSender:self];
}

-(void)OnMenuScore:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENSCOREVIEW eventSender:self];
}

-(void)OnMenuShare:(id)sender
{
    if([StringFactory IsOSLangZH])
        [CustomModalAlertView SimpleSay:@"注意：Facebook在某些地区可能被屏蔽，这些地区的玩家可能不能使用Facebook的服务来与其他朋友共享游戏信息!" closeButton:[StringFactory GetString_Close]];
	[GUIEventLoop SendEvent:GUIID_EVENT_OPENSHAREVIEW eventSender:self];
}

-(void)OnMenuBuyIt:(id)sender
{
	[GUIEventLoop SendEvent:GUIID_EVENT_PURCHASE eventSender:self];
}

- (void)OnMenuFriend:(id)sender
{
    [GUIEventLoop SendEvent:GUIID_OPENFRIENDVIEW eventSender:self];
}

-(void)OnMenuBkGnd:(id)sender
{
	int n = [GameConfiguration GetMainBackgroundType];
	n = (n+1)%2;
    [GameScore SaveBackgoundType:n];
	[GameConfiguration SetMainBackgroundType:n];
	[(MultiChoiceGlossyMenuItem*)[m_Menu GetMenuItem:GUIID_BKGNDBUTTON] SetActiveChoice:n];
	[self.superview setNeedsDisplay];
}

- (void)dealloc 
{
	
    [super dealloc];
}

- (void)OnTimerEvent
{
    [m_GameBoard OnTomerEvent];
	[self setNeedsDisplay];
}	

- (void)UpdateGameViewLayout
{
    [m_Overlay setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [m_GameBoard setFrame:[GameLayout GetPlayBoardRect]];
    [m_GameBoard UpdateGameViewLayout];
	
    float fSize = [GameLayout GetLayoutSignSize];
    CGRect rect = CGRectMake([GUILayout GetContentViewWidth]-fSize, 0, fSize, fSize);
    [m_LayoutSign setFrame:rect];
    
    [self OnOrientationChange];	
    
    
    [self setNeedsDisplay];
}	

- (void)StartNewGame:(BOOL)bLoadCacheData
{
    if(!bLoadCacheData)
       [self ClearupFileManagerData];

    [GameConfiguration CleanPlaySteps];
    if([GameConfiguration IsValentineDay])
    {
        float fSeed = [[NSProcessInfo processInfo] systemUptime];
        srand((unsigned)fSeed);
        int nRand = rand();
        if(nRand%2==0)
        {
            [GameConfiguration SetOddState:NO];
        }
        else
        {
            [GameConfiguration SetOddState:YES];
        }
            
    }
	[m_GameBoard StartNewGame:bLoadCacheData];
    [self UpdatePlayStepLabel];
}

- (void)UndoGame
{
	[m_GameBoard UndoGame];
}

- (void)ResetGame
{
	[m_GameBoard ResetGame];
}

- (BOOL)canBecomeFirstResponder 
{
	return YES;
}


- (BOOL)GameOverPresentationDone
{
    return YES;
}

-(BOOL)IsUIEventLocked
{
    if(m_bMenuShow == YES || m_bMenuAnimtation == YES || [m_GameBoard InAnimation] == YES)
        return YES;
    
    return NO;
}


-(void)RemovePurchaseButton
{
    if([m_Menu GetMenuItem:GUIID_PURCHASEBUTTON] != nil)
    {    
        [GUIEventLoop RemoveEvent:GUIID_PURCHASEBUTTON eventReceiver:self eventSender:self];
        [m_Menu RemoveMenuItem:GUIID_PURCHASEBUTTON];
        [self UpdateMenuLayout];
    }    
}

-(BOOL)IsGameComplete
{
    BOOL bRet = YES;
    if(m_GameBoard)
        bRet = [m_GameBoard IsGameComplete];
    return bRet;
}

- (void)LoadGameSet:(NSMutableDictionary**)dataDict
{
    if(m_GameBoard)
        [m_GameBoard LoadGameSet:dataDict];
}

//-(void)LoadUndoList:(NSMutableDictionary**)dataDict withKey:(NSString*)szKey
- (void)LoadUndoList:(NSMutableDictionary**)dataDict withPrefIndex:(int)index
{
    if(m_GameBoard)
        [m_GameBoard LoadUndoList:dataDict withPrefIndex:index];
}


-(void)SaveCurrentGameToFile
{
    [GUIEventLoop SendEvent:GUIID_EVENT_OPENFILESAVEUI eventSender:self];

}

-(void)ClearupFileManagerData
{
    ApplicationController* pController = ( ApplicationController*)[GUILayout GetMainViewController];
    if(pController)
        [pController CleanCurrentGameData];
}

-(void)StartNewGameFromOpenFile:(BOOL)bRestart
{
    //???
   
    if(m_GameBoard)
        [m_GameBoard StartNewGameFromOpenFile:bRestart];
}

-(void)OnResetEasyShuffle:(id)sender
{
    [self StartNewGame:NO];
}

-(void)StartPlayHelpAnimation:(int)nSelectedType
{
    m_bShowQMark = YES;
    if(nSelectedType < 0)
    {
        [m_GameBoard CheckBubbleState];
        if([GameConfiguration IsGameDifficulty] == NO)
        {
            [m_GameBoard StartEasyAnimation:-1];
        }
    }
    else
    {
        [m_GameBoard CheckBubbleState];
        [m_GameBoard StartEasyAnimation:nSelectedType];
    }
}

@end
